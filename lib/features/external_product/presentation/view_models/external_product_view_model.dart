import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_product_repository.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

class ExternalProductViewModel extends Notifier<ExternalProductState>
    with WidgetsBindingObserver {
  ExternalProductViewModel(this.productRef);

  final ExternalProductRef productRef;

  /// 이만큼 대기하면 상품 정보를 계속 기다리고 있음을 알린다.
  static const _slowAfter = Duration(seconds: 30);

  /// 이보다 오래 걸리면 기다리기를 멈추고 다시 시도하게 한다.
  static const _giveUpAfter = Duration(seconds: 120);

  ExternalProductRepository get _repository =>
      ref.read(externalProductRepositoryProvider);

  /// 다시 불러올 때마다 올린다. 이전 요청과 대기를 모두 버린다.
  int _generation = 0;
  int _snapshotRevision = 0;
  bool _backgrounded = false;
  Timer? _pollTimer;
  Timer? _deadlineTimer;
  DateTime? _startedAt;
  final Set<String> _loadedCursors = {};

  @override
  ExternalProductState build() {
    if (!kIsWeb) {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      _backgrounded = _isBackgroundState(binding.lifecycleState);
      binding.addObserver(this);
      ref.onDispose(() => binding.removeObserver(this));
    }
    ref.onDispose(() {
      _generation++;
      _stopPolling();
    });
    Future.microtask(load);
    return ExternalProductState(
      summary: ref.read(productSummaryCacheProvider).get(productRef),
    );
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    final generation = ++_generation;
    _stopPolling();
    _loadedCursors.clear();
    state = state.copyWith(
      phase: ExternalProductPhase.loading,
      isLoadingMore: false,
      loadMoreFailed: false,
      isSlow: false,
      isRefreshDelayed: false,
      clearCollectionError: true,
    );
    if (_backgrounded) return;
    _startDeadline(generation);
    await _fetch(generation);
  }

  bool _isBackgroundState(AppLifecycleState? lifecycle) => switch (lifecycle) {
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached => true,
    _ => false,
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _handleLifecycle(state);

  void _handleLifecycle(AppLifecycleState lifecycle) {
    if (kIsWeb || !ref.mounted || lifecycle == AppLifecycleState.inactive) {
      return;
    }
    final backgrounded = _isBackgroundState(lifecycle);
    if (_backgrounded == backgrounded) return;
    _backgrounded = backgrounded;
    final generation = ++_generation;
    _stopPolling();
    state = state.copyWith(isLoadingMore: false);
    if (_backgrounded) return;
    state = state.copyWith(isRefreshDelayed: false, isSlow: false);
    _startDeadline(generation);
    unawaited(_fetch(generation));
  }

  Future<void> _fetch(int generation, {String? reviewError}) async {
    if (!_isCurrent(generation)) return;
    if (state.isLoadingMore) {
      _wait(generation);
      return;
    }
    final revision = _snapshotRevision;
    final result = await _repository.getProduct(productRef);
    if (!_isCurrent(generation)) return;
    // 더 늦게 시작한 페이지 요청이 반영됐으면 이전 상세 응답을 버린다.
    if (revision != _snapshotRevision) {
      if (!state.isTerminal) _wait(generation);
      return;
    }

    result.when(
      success: (snapshot) {
        final product = snapshot.product;
        if (product != null && product.ref == productRef) {
          final summary = ProductSummary(
            product: product,
            catalogAnalysis:
                snapshot.analysisStatus.toUpperCase() == 'DONE' &&
                    state.summary?.matches(productRef) == true
                ? state.summary?.catalogAnalysis
                : null,
            springProductId: snapshot.springProductId,
            observedAt: DateTime.now(),
            source: ProductSummarySource.previousDetail,
          );
          ref.read(productSummaryCacheProvider).remember(summary);
          state = ExternalProductState(
            phase: ExternalProductPhase.ready,
            product: product,
            summary: summary,
            isStale: snapshot.status == CollectionStatus.stale,
            collectionStatus: snapshot.collectionStatus,
            job: snapshot.job,
            hasAnalysis: snapshot.hasAnalysis,
            analysisStatus: snapshot.analysisStatus,
            analysis: snapshot.analysis,
            springProductId: snapshot.springProductId,
            reviews: _loadedCursors.isEmpty
                ? snapshot.reviews
                : _mergeReviews(snapshot),
            nextCursor: _loadedCursors.isEmpty
                ? snapshot.nextCursor
                : state.nextCursor,
            loadMoreFailed: state.loadMoreFailed,
            isLoadingMore: state.isLoadingMore,
            collectionError:
                reviewError ??
                (snapshot.job?.status == CollectionJobStatus.partial
                    ? snapshot.job?.lastError
                    : null),
          );
        } else {
          state = state.copyWith(
            collectionStatus: snapshot.collectionStatus,
            job: snapshot.job,
            clearJob: snapshot.job == null,
            analysisStatus: snapshot.analysisStatus,
            phase: state.product != null
                ? ExternalProductPhase.ready
                : ExternalProductPhase.unavailable,
            collectionError: snapshot.job?.lastError,
            clearCollectionError: snapshot.job?.lastError == null,
          );
        }
        if (!state.isTerminal) {
          _wait(generation);
        } else {
          _stopPolling();
        }
      },
      failure: (_) {
        if (state.product != null ||
            state.phase == ExternalProductPhase.collecting) {
          _wait(generation);
        } else {
          state = state.copyWith(phase: ExternalProductPhase.failure);
          _stopPolling();
        }
      },
    );
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _deadlineTimer?.cancel();
  }

  void _startDeadline(int generation) {
    _startedAt = DateTime.now();
    _deadlineTimer = Timer(_giveUpAfter, () => _markDelayed(generation));
  }

  void _markDelayed(int generation) {
    if (!_isCurrent(generation)) return;
    _stopPolling();
    _generation++;
    state = state.copyWith(
      phase: state.product == null
          ? ExternalProductPhase.unavailable
          : ExternalProductPhase.ready,
      isRefreshDelayed: true,
      isSlow: true,
      isLoadingMore: false,
    );
  }

  /// 수집·분석이 끝날 때까지 기존 상품을 유지하며 확인한다.
  void _wait(int generation) {
    if (!_isCurrent(generation)) return;
    final elapsed = DateTime.now().difference(_startedAt!);
    if (elapsed >= _giveUpAfter) {
      _markDelayed(generation);
      return;
    }
    state = state.copyWith(
      phase: state.product == null
          ? ExternalProductPhase.collecting
          : ExternalProductPhase.ready,
      isSlow: elapsed >= _slowAfter,
    );
    _pollTimer?.cancel();
    final interval = ref.read(externalProductPollIntervalProvider);
    // 상품을 이미 보여 주는 중이면 뒤에서 조용히 갱신하므로 덜 자주 확인한다.
    final base = state.product == null ? interval : interval * 3;
    _pollTimer = Timer(base * _backoffFactor(elapsed), () {
      _poll(generation);
    });
  }

  /// 오래 기다릴수록 서버 확인 간격을 늘린다(30초 이후 2배, 60초 이후 3배).
  static int _backoffFactor(Duration elapsed) {
    if (elapsed >= _slowAfter * 2) return 3;
    if (elapsed >= _slowAfter) return 2;
    return 1;
  }

  Future<void> _poll(int generation) async {
    if (!_isCurrent(generation)) return;
    final jobId = state.job?.id;
    // 상품이 있으면 분석과 수집을 함께 확인한다.
    if (state.product != null || jobId == null) return _fetch(generation);

    final result = await _repository.getJob(jobId);
    if (!_isCurrent(generation)) return;

    await result.when(
      success: (job) async {
        state = state.copyWith(job: job);
        if (job.isFinished) {
          await _fetch(
            generation,
            reviewError: job.status == CollectionJobStatus.partial
                ? job.lastError
                : null,
          );
        } else if (job.isTerminal) {
          state = state.copyWith(
            phase: ExternalProductPhase.unavailable,
            collectionError: job.lastError,
          );
          _stopPolling();
        } else {
          _wait(generation);
        }
      },
      // 한 번 확인에 실패해도 수집은 계속되고 있을 수 있어 계속 기다린다.
      failure: (_) async => _wait(generation),
    );
  }

  bool _analysisChanged(ExternalProductSnapshot snapshot) {
    final before = state.analysis;
    final after = snapshot.analysis;
    return state.analysisStatus != snapshot.analysisStatus ||
        before?.modelVersion != after?.modelVersion ||
        before?.policyVersion != after?.policyVersion ||
        before?.reviewCount != after?.reviewCount ||
        before?.sampled != after?.sampled ||
        before?.sourceReviewCount != after?.sourceReviewCount;
  }

  List<ExternalReview> _mergeReviews(ExternalProductSnapshot snapshot) {
    final changed = _analysisChanged(snapshot);
    final merged = <String, ExternalReview>{
      for (final review in state.reviews)
        review.reviewId: changed
            ? ExternalReview(
                reviewId: review.reviewId,
                content: review.content,
                rating: review.rating,
                author: review.author,
                writtenAt: review.writtenAt,
                option: review.option,
                images: review.images,
                helpfulCount: review.helpfulCount,
              )
            : review,
    };
    for (final review in snapshot.reviews) {
      merged[review.reviewId] = review;
    }
    return merged.values.toList();
  }

  Future<void> loadMoreReviews() async {
    final cursor = state.nextCursor;
    if (_backgrounded ||
        cursor == null ||
        state.isLoadingMore ||
        state.phase != ExternalProductPhase.ready) {
      return;
    }
    final generation = _generation;
    state = state.copyWith(isLoadingMore: true, loadMoreFailed: false);

    final result = await _repository.getProduct(productRef, cursor: cursor);
    if (!_isCurrent(generation)) return;

    result.when(
      success: (snapshot) {
        // 같은 리뷰가 두 페이지에 걸쳐 와도 한 번만 보여 준다.
        _snapshotRevision++;
        _loadedCursors.add(cursor);
        final next = snapshot.nextCursor;
        final exhausted =
            next == null || next.isEmpty || _loadedCursors.contains(next);
        final after = snapshot.analysis;
        final changed = _analysisChanged(snapshot);
        final summary = state.summary;
        final safeSummary = changed && summary != null
            ? ProductSummary(
                product: summary.product,
                springProductId: summary.springProductId,
                observedAt: summary.observedAt,
                source: summary.source,
              )
            : summary;
        if (changed && safeSummary != null) {
          ref.read(productSummaryCacheProvider).remember(safeSummary);
        }
        state = state.copyWith(
          isLoadingMore: false,
          summary: safeSummary,
          collectionStatus: snapshot.collectionStatus,
          job: snapshot.job,
          clearJob: snapshot.job == null,
          hasAnalysis: snapshot.hasAnalysis,
          analysisStatus: snapshot.analysisStatus,
          analysis: after,
          clearAnalysis: after == null,
          reviews: _mergeReviews(snapshot),
          nextCursor: exhausted ? null : next,
          clearNextCursor: exhausted,
        );
        if (state.isTerminal) {
          _stopPolling();
        } else if (!state.isRefreshDelayed) {
          if (!(_deadlineTimer?.isActive ?? false)) _startDeadline(generation);
          _wait(generation);
        }
      },
      failure: (_) =>
          state = state.copyWith(isLoadingMore: false, loadMoreFailed: true),
    );
  }

  bool _isCurrent(int generation) =>
      ref.mounted && !_backgrounded && generation == _generation;
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_product_repository.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

class ExternalProductViewModel extends Notifier<ExternalProductState> {
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
  Timer? _pollTimer;
  final Set<String> _loadedCursors = {};

  @override
  ExternalProductState build() {
    ref.onDispose(() => _pollTimer?.cancel());
    Future.microtask(load);
    return ExternalProductState(
      summary: ref.read(productSummaryCacheProvider).get(productRef),
    );
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    final generation = ++_generation;
    _pollTimer?.cancel();
    _loadedCursors.clear();
    state = state.copyWith(
      phase: ExternalProductPhase.loading,
      isLoadingMore: false,
      loadMoreFailed: false,
      isSlow: false,
      clearCollectionError: true,
    );
    await _fetch(generation, startedAt: DateTime.now());
  }

  Future<void> _fetch(
    int generation, {
    required DateTime startedAt,
    String? reviewError,
  }) async {
    final result = await _repository.getProduct(productRef);
    if (!_isCurrent(generation)) return;

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
            hasAnalysis: snapshot.hasAnalysis,
            analysisStatus: snapshot.analysisStatus,
            analysis: snapshot.analysis,
            springProductId: snapshot.springProductId,
            reviews: snapshot.reviews,
            nextCursor: snapshot.nextCursor,
            collectionError:
                reviewError ??
                (snapshot.job?.status == CollectionJobStatus.partial
                    ? snapshot.job?.lastError
                    : null),
          );
        } else if (snapshot.status == CollectionStatus.queued) {
          _wait(generation, startedAt: startedAt, jobId: snapshot.job?.id);
        } else {
          state = state.copyWith(phase: ExternalProductPhase.unavailable);
        }
      },
      failure: (_) =>
          state = state.copyWith(phase: ExternalProductPhase.failure),
    );
  }

  /// 수집이 끝날 때까지 주기적으로 확인한다.
  void _wait(int generation, {required DateTime startedAt, int? jobId}) {
    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed >= _giveUpAfter) {
      state = state.copyWith(phase: ExternalProductPhase.unavailable);
      return;
    }
    state = state.copyWith(
      phase: ExternalProductPhase.collecting,
      isSlow: elapsed >= _slowAfter,
    );
    _pollTimer?.cancel();
    _pollTimer = Timer(ref.read(externalProductPollIntervalProvider), () {
      _poll(generation, startedAt: startedAt, jobId: jobId);
    });
  }

  Future<void> _poll(
    int generation, {
    required DateTime startedAt,
    int? jobId,
  }) async {
    if (!_isCurrent(generation)) return;
    // 작업 번호를 못 받았으면 상품을 다시 조회해 상태를 확인한다.
    if (jobId == null) return _fetch(generation, startedAt: startedAt);

    final result = await _repository.getJob(jobId);
    if (!_isCurrent(generation)) return;

    await result.when(
      success: (job) async {
        if (job.isFinished) {
          await _fetch(
            generation,
            startedAt: startedAt,
            reviewError: job.status == CollectionJobStatus.partial
                ? job.lastError
                : null,
          );
        } else if (job.status == CollectionJobStatus.failed) {
          state = state.copyWith(
            phase: ExternalProductPhase.unavailable,
            collectionError: job.lastError,
          );
        } else {
          _wait(generation, startedAt: startedAt, jobId: jobId);
        }
      },
      // 한 번 확인에 실패해도 수집은 계속되고 있을 수 있어 계속 기다린다.
      failure: (_) async =>
          _wait(generation, startedAt: startedAt, jobId: jobId),
    );
  }

  Future<void> loadMoreReviews() async {
    final cursor = state.nextCursor;
    if (cursor == null ||
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
        _loadedCursors.add(cursor);
        final next = snapshot.nextCursor;
        final exhausted =
            next == null || next.isEmpty || _loadedCursors.contains(next);
        final before = state.analysis;
        final after = snapshot.analysis;
        final changed =
            state.analysisStatus != snapshot.analysisStatus ||
            before?.modelVersion != after?.modelVersion ||
            before?.policyVersion != after?.policyVersion ||
            before?.reviewCount != after?.reviewCount ||
            before?.sampled != after?.sampled ||
            before?.sourceReviewCount != after?.sourceReviewCount;
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
        state = state.copyWith(
          isLoadingMore: false,
          summary: safeSummary,
          hasAnalysis: snapshot.hasAnalysis,
          analysisStatus: snapshot.analysisStatus,
          analysis: after,
          clearAnalysis: after == null,
          reviews: merged.values.toList(),
          nextCursor: exhausted ? null : next,
          clearNextCursor: exhausted,
        );
      },
      failure: (_) =>
          state = state.copyWith(isLoadingMore: false, loadMoreFailed: true),
    );
  }

  bool _isCurrent(int generation) => ref.mounted && generation == _generation;
}

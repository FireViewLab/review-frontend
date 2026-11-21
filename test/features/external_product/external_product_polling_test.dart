import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/analysis_progress_state.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_view_model.dart';

import 'external_product_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(ExternalProductViewModel, () {
    for (final status in [
      'DONE',
      'NOT_ANALYZED',
      'FAILED',
      'DISABLED',
      'UNAVAILABLE',
    ]) {
      test(
        'stops polling and cancels its deadline when analysis is $status',
        () {
          _withPolling((time, subject) {
            subject.repository.products = [Success(_snapshot(status))];
            time.flushMicrotasks();
            expect(subject.state.isTerminal, isTrue);
            expect(subject.state.analysisStatus, status);
            expect(subject.state.phase, ExternalProductPhase.ready);
            time.elapse(const Duration(seconds: 121));
            expect(subject.repository.cursors, [null]);
            expect(subject.state.isRefreshDelayed, isFalse);
          });
        },
      );
    }

    test(
      'continues polling a running analysis and stops after DONE arrives',
      () {
        _withPolling((time, subject) {
          subject.repository.products = [
            Success(_snapshot('RUNNING')),
            Success(_snapshot('DONE')),
          ];
          time.flushMicrotasks();
          expect(subject.state.isAnalyzing, isTrue);
          expect(subject.state.isTerminal, isFalse);
          time.elapse(const Duration(milliseconds: 2999));
          expect(subject.repository.cursors, hasLength(1));
          time.elapse(const Duration(milliseconds: 1));
          expect(subject.repository.cursors, hasLength(2));
          expect(subject.state.analysisState, ExternalAnalysisStatus.done);
          time.elapse(const Duration(seconds: 121));
          expect(subject.repository.cursors, hasLength(2));
          expect(subject.state.isRefreshDelayed, isFalse);
        });
      },
    );

    test(
      'keeps polling an active collection job even when analysis is DONE',
      () {
        _withPolling((time, subject) {
          subject.repository.products = [
            Success(
              _snapshot(
                'DONE',
                job: const CollectionJob(
                  id: 9,
                  status: CollectionJobStatus.running,
                ),
              ),
            ),
          ];
          time.flushMicrotasks();
          expect(subject.state.isTerminal, isFalse);
          expect(subject.state.isCollecting, isTrue);
          time.elapse(const Duration(seconds: 6));
          expect(subject.repository.cursors, hasLength(3));
        });
      },
    );

    test('stops polling after a failed collection job without a product', () {
      _withPolling((time, subject) {
        subject.repository.products = [const Success(queued)];
        subject.repository.jobs = const [
          Success(
            CollectionJob(
              id: 9,
              status: CollectionJobStatus.failed,
              lastError: '수집 실패',
            ),
          ),
        ];
        time.flushMicrotasks();
        expect(subject.state.phase, ExternalProductPhase.collecting);
        time.elapse(const Duration(seconds: 1));
        expect(subject.state.phase, ExternalProductPhase.unavailable);
        expect(subject.state.failureMessage, '수집 실패');
        time.elapse(const Duration(seconds: 121));
        expect(subject.repository.jobRequests, [9]);
        expect(subject.repository.cursors, [null]);
        expect(subject.state.isRefreshDelayed, isFalse);
      });
    });

    test('stops polling after the initial product request fails', () {
      _withPolling((time, subject) {
        subject.repository.products = [failure];
        time.flushMicrotasks();
        expect(subject.state.phase, ExternalProductPhase.failure);
        time.elapse(const Duration(seconds: 121));
        expect(subject.repository.cursors, [null]);
        expect(subject.state.isRefreshDelayed, isFalse);
      });
    });

    test(
      'retains a displayed product and retries a transient polling failure',
      () {
        _withPolling((time, subject) {
          subject.repository.products = [
            Success(_snapshot('RUNNING')),
            failure,
            Success(_snapshot('DONE')),
          ];
          time.flushMicrotasks();
          time.elapse(const Duration(seconds: 3));
          expect(subject.state.product, kurlyProduct);
          expect(subject.state.phase, ExternalProductPhase.ready);
          time.elapse(const Duration(seconds: 3));
          expect(subject.state.isTerminal, isTrue);
          expect(subject.repository.cursors, hasLength(3));
        });
      },
    );

    test(
      'marks a still-running product delayed at the 120 second deadline',
      () {
        _withPolling((time, subject) {
          subject.repository.products = [Success(_snapshot('RUNNING'))];
          time.flushMicrotasks();
          time.elapse(const Duration(seconds: 119));
          expect(subject.state.isRefreshDelayed, isFalse);
          time.elapse(const Duration(seconds: 1));
          expect(subject.state.isRefreshDelayed, isTrue);
          expect(subject.state.isSlow, isTrue);
          expect(subject.state.phase, ExternalProductPhase.ready);
          expect(subject.state.product, kurlyProduct);
          final count = subject.repository.cursors.length;
          time.elapse(const Duration(seconds: 30));
          expect(subject.repository.cursors, hasLength(count));
        });
      },
    );

    test(
      'ignores an initial response arriving after the collection deadline',
      () {
        _withPolling((time, subject) {
          final pending = Completer<Result<ExternalProductSnapshot>>();
          subject.repository.pendingProduct = pending;
          time.flushMicrotasks();
          time.elapse(const Duration(seconds: 120));
          expect(subject.state.phase, ExternalProductPhase.unavailable);
          expect(subject.state.isRefreshDelayed, isTrue);
          pending.complete(Success(_snapshot('DONE')));
          time.flushMicrotasks();
          expect(subject.state.product, isNull);
          expect(subject.state.isRefreshDelayed, isTrue);
          expect(subject.repository.cursors, [null]);
        });
      },
    );

    for (final lifecycle in [
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.detached,
    ]) {
      test(
        'pauses in ${lifecycle.name} and resumes with an immediate refresh',
        () {
          _withPolling((time, subject) {
            subject.repository.products = [Success(_snapshot('RUNNING'))];
            time.flushMicrotasks();
            expect(subject.repository.cursors, hasLength(1));
            subject.notifier.didChangeAppLifecycleState(lifecycle);
            time.elapse(const Duration(seconds: 121));
            expect(subject.repository.cursors, hasLength(1));
            expect(subject.state.isRefreshDelayed, isFalse);
            subject.notifier.didChangeAppLifecycleState(
              AppLifecycleState.resumed,
            );
            time.flushMicrotasks();
            expect(subject.repository.cursors, hasLength(2));
            expect(subject.state.isRefreshDelayed, isFalse);
            time.elapse(const Duration(seconds: 3));
            expect(subject.repository.cursors, hasLength(3));
          });
        },
      );
    }

    test('continues polling while inactive without starting a second loop', () {
      _withPolling((time, subject) {
        subject.repository.products = [Success(_snapshot('RUNNING'))];
        time.flushMicrotasks();
        subject.notifier.didChangeAppLifecycleState(AppLifecycleState.inactive);
        time.elapse(const Duration(seconds: 3));
        expect(subject.repository.cursors, hasLength(2));
      });
    });

    test('discards a response from before backgrounding', () {
      _withPolling((time, subject) {
        final pending = Completer<Result<ExternalProductSnapshot>>();
        subject.repository.pendingProduct = pending;
        time.flushMicrotasks();
        subject.notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
        pending.complete(Success(_snapshot('DONE')));
        time.flushMicrotasks();
        expect(subject.state.product, isNull);
        subject.repository.pendingProduct = null;
        subject.repository.products = [Success(_snapshot('NOT_ANALYZED'))];
        subject.notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
        time.flushMicrotasks();
        expect(subject.state.analysisStatus, 'NOT_ANALYZED');
        expect(subject.state.isTerminal, isTrue);
      });
    });
  });

  group(AnalysisProgressState, () {
    test(
      'completes the review step when reviews exist without a collection job',
      () {
        final result = AnalysisProgressState.fromDetail(
          ExternalProductState(
            product: kurlyProduct,
            collectionStatus: 'FRESH',
            analysisStatus: 'DONE',
            reviews: [reviewOf('1')],
          ),
        );
        expect(result.product, AnalysisStepStatus.complete);
        expect(result.reviews, AnalysisStepStatus.complete);
        expect(result.analysis, AnalysisStepStatus.complete);
        expect(result.notice, AnalysisProgressNotice.complete);
        expect(result.showSteps, isFalse);
      },
    );
    test(
      'does not infer completed review collection from an empty review list',
      () {
        final result = AnalysisProgressState.fromDetail(
          const ExternalProductState(
            product: kurlyProduct,
            collectionStatus: 'FRESH',
            analysisStatus: 'NOT_ANALYZED',
          ),
        );
        expect(result.reviews, AnalysisStepStatus.unknown);
        expect(result.analysis, AnalysisStepStatus.notAnalyzed);
        expect(result.notice, AnalysisProgressNotice.notAnalyzed);
      },
    );
    test(
      'honors an active review job even when some reviews are already present',
      () {
        final result = AnalysisProgressState.fromDetail(
          ExternalProductState(
            product: kurlyProduct,
            collectionStatus: 'FRESH',
            analysisStatus: 'RUNNING',
            reviews: [reviewOf('1')],
            job: const CollectionJob(
              id: 9,
              status: CollectionJobStatus.running,
              productStatus: 'DONE',
              reviewStatus: 'RUNNING',
            ),
          ),
        );
        expect(result.reviews, AnalysisStepStatus.inProgress);
        expect(result.analysis, AnalysisStepStatus.inProgress);
        expect(result.notice, AnalysisProgressNotice.collecting);
      },
    );
    test('shows a delayed notice before an underlying failed step', () {
      final result = AnalysisProgressState.fromDetail(
        const ExternalProductState(
          collectionStatus: 'FAILED',
          analysisStatus: 'FAILED',
          isRefreshDelayed: true,
        ),
      );
      expect(result.product, AnalysisStepStatus.failed);
      expect(result.analysis, AnalysisStepStatus.failed);
      expect(result.notice, AnalysisProgressNotice.delayed);
    });
  });
}

ExternalProductSnapshot _snapshot(
  String analysisStatus, {
  CollectionJob? job,
}) => ExternalProductSnapshot(
  status: CollectionStatus.fresh,
  product: kurlyProduct,
  analysisStatus: analysisStatus,
  hasAnalysis: analysisStatus == 'DONE',
  job: job,
  reviews: [reviewOf('1')],
);

void _withPolling(void Function(FakeAsync, _PollingHarness) body) {
  fakeAsync((time) {
    final subject = _PollingHarness();
    try {
      body(time, subject);
    } finally {
      subject.container.dispose();
      time.flushMicrotasks();
    }
  });
}

class _PollingHarness {
  _PollingHarness() {
    container = ProviderContainer(
      overrides: [
        externalProductRepositoryProvider.overrideWithValue(repository),
        externalProductPollIntervalProvider.overrideWithValue(
          const Duration(seconds: 1),
        ),
      ],
    );
    container.listen(provider, (_, _) {});
  }
  final repository = FakeExternalProductRepository();
  final provider = externalProductViewModelProvider(kurlyRef);
  late final ProviderContainer container;
  ExternalProductState get state => container.read(provider);
  ExternalProductViewModel get notifier => container.read(provider.notifier);
}

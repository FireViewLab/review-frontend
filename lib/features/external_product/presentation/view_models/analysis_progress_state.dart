import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

enum AnalysisStepStatus {
  complete,
  inProgress,
  waiting,
  failed,
  notAnalyzed,
  unknown,
  refreshing,
  disabled,
  unavailable,
  partial,
}

enum AnalysisProgressNotice {
  collecting,
  refreshing,
  analyzing,
  notAnalyzed,
  complete,
  failed,
  delayed,
  checking,
  disabled,
  unavailable,
}

/// 상품·리뷰·분석 단계는 서로의 완료 여부를 추측하지 않는다.
class AnalysisProgressState {
  const AnalysisProgressState({
    required this.product,
    required this.reviews,
    required this.analysis,
    required this.notice,
  });

  factory AnalysisProgressState.fromDetail(ExternalProductState state) {
    final product = state.product != null
        ? state.collection == CollectionStatus.stale &&
                  (state.job?.productState == CollectionJobStatus.running)
              ? AnalysisStepStatus.refreshing
              : AnalysisStepStatus.complete
        : switch (state.collection) {
            CollectionStatus.queued ||
            CollectionStatus.running => AnalysisStepStatus.inProgress,
            CollectionStatus.failed => AnalysisStepStatus.failed,
            CollectionStatus.disabled => AnalysisStepStatus.disabled,
            CollectionStatus.unavailable => AnalysisStepStatus.unavailable,
            _ => _jobStep(state.job?.productState),
          };
    final reviews = state.reviews.isNotEmpty
        ? state.job?.reviewState == CollectionJobStatus.running
              ? AnalysisStepStatus.inProgress
              : AnalysisStepStatus.complete
        : _jobStep(state.job?.reviewState);
    final analysis = switch (state.analysisState) {
      ExternalAnalysisStatus.pending => AnalysisStepStatus.waiting,
      ExternalAnalysisStatus.running => AnalysisStepStatus.inProgress,
      ExternalAnalysisStatus.done => AnalysisStepStatus.complete,
      ExternalAnalysisStatus.failed => AnalysisStepStatus.failed,
      ExternalAnalysisStatus.notAnalyzed => AnalysisStepStatus.notAnalyzed,
      ExternalAnalysisStatus.disabled => AnalysisStepStatus.disabled,
      ExternalAnalysisStatus.unavailable => AnalysisStepStatus.unavailable,
      ExternalAnalysisStatus.unknown => AnalysisStepStatus.unknown,
    };
    final failed =
        [product, reviews, analysis].any(
          (status) =>
              status == AnalysisStepStatus.failed ||
              status == AnalysisStepStatus.partial,
        ) ||
        state.collection == CollectionStatus.failed ||
        state.job?.productState == CollectionJobStatus.failed ||
        state.job?.status == CollectionJobStatus.failed ||
        state.job?.status == CollectionJobStatus.partial ||
        state.phase == ExternalProductPhase.failure;
    final AnalysisProgressNotice notice;
    if (!failed &&
        state.hasCollectedContent &&
        !state.isRefreshRunning &&
        state.analysisState == ExternalAnalysisStatus.done) {
      notice = AnalysisProgressNotice.complete;
    } else if (state.isRefreshDelayed) {
      notice = AnalysisProgressNotice.delayed;
    } else if (failed) {
      notice = AnalysisProgressNotice.failed;
    } else if (state.isStaleRefreshing) {
      notice = AnalysisProgressNotice.refreshing;
    } else if (state.isCollecting &&
        (!state.hasCollectedContent || state.isRefreshRunning)) {
      notice = AnalysisProgressNotice.collecting;
    } else if (state.isAnalyzing) {
      notice = AnalysisProgressNotice.analyzing;
    } else if (state.analysisState == ExternalAnalysisStatus.notAnalyzed) {
      notice = AnalysisProgressNotice.notAnalyzed;
    } else if (state.isTerminal &&
        state.analysisState == ExternalAnalysisStatus.done) {
      notice = AnalysisProgressNotice.complete;
    } else if (state.analysisState == ExternalAnalysisStatus.disabled) {
      notice = AnalysisProgressNotice.disabled;
    } else if (state.analysisState == ExternalAnalysisStatus.unavailable) {
      notice = AnalysisProgressNotice.unavailable;
    } else {
      notice = AnalysisProgressNotice.checking;
    }
    return AnalysisProgressState(
      product: product,
      reviews: reviews,
      analysis: analysis,
      notice: notice,
    );
  }

  final AnalysisStepStatus product;
  final AnalysisStepStatus reviews;
  final AnalysisStepStatus analysis;
  final AnalysisProgressNotice notice;

  bool get showSteps => notice != AnalysisProgressNotice.complete;

  static AnalysisStepStatus _jobStep(CollectionJobStatus? status) =>
      switch (status) {
        CollectionJobStatus.succeeded ||
        CollectionJobStatus.done => AnalysisStepStatus.complete,
        CollectionJobStatus.running => AnalysisStepStatus.inProgress,
        CollectionJobStatus.pending ||
        CollectionJobStatus.queued => AnalysisStepStatus.waiting,
        CollectionJobStatus.failed => AnalysisStepStatus.failed,
        CollectionJobStatus.disabled => AnalysisStepStatus.disabled,
        CollectionJobStatus.partial => AnalysisStepStatus.partial,
        CollectionJobStatus.unknown || null => AnalysisStepStatus.unknown,
      };
}

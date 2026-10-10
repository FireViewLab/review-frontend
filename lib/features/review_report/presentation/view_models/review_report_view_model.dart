import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/review_report/domain/usecases/submit_review_report_use_case.dart';
import 'package:re_view_front/features/review_report/presentation/providers/review_report_dep_providers.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_state.dart';

class ReviewReportViewModel extends Notifier<ReviewReportState> {
  late final SubmitReviewReportUseCase _submitUseCase;

  @override
  ReviewReportState build() {
    _submitUseCase = ref.watch(submitReviewReportUseCaseProvider);
    return const ReviewReportInitial();
  }

  Future<void> submit({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) async {
    if (!ref.mounted) return;
    state = const ReviewReportSubmitting();

    final result = await _submitUseCase(
      reviewId: reviewId,
      reason: reason,
      detail: detail,
      includeAiEvidence: includeAiEvidence,
      attachmentUrl: attachmentUrl,
    );

    if (!ref.mounted) return;
    state = result.when(
      success: ReviewReportSuccess.new,
      failure: (f) => ReviewReportFailure(
        f.message,
        isDuplicate: f.code == 'REPORT_ALREADY_EXISTS',
      ),
    );
  }

  void reset() => state = const ReviewReportInitial();
}

import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/domain/repositories/review_report_repository.dart';

class SubmitReviewReportUseCase {
  const SubmitReviewReportUseCase(this._repository);
  final ReviewReportRepository _repository;

  Future<Result<ReviewReport>> call({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) => _repository.submitReport(
        reviewId: reviewId,
        reason: reason,
        detail: detail,
        includeAiEvidence: includeAiEvidence,
        attachmentUrl: attachmentUrl,
      );
}

import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

abstract interface class ReviewReportRepository {
  Future<Result<ReviewReport>> submitReport({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence,
    String? attachmentUrl,
  });
}

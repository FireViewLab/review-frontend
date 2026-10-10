import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

sealed class ReviewReportState {
  const ReviewReportState();
}

class ReviewReportInitial extends ReviewReportState {
  const ReviewReportInitial();
}

class ReviewReportSubmitting extends ReviewReportState {
  const ReviewReportSubmitting();
}

class ReviewReportSuccess extends ReviewReportState {
  const ReviewReportSuccess(this.report);
  final ReviewReport report;
}

class ReviewReportFailure extends ReviewReportState {
  const ReviewReportFailure(this.message, {this.isDuplicate = false});
  final String message;
  final bool isDuplicate;
}

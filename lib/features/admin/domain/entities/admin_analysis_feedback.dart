/// 분석 피드백(RTI 이의 제기) 처리 상태.
enum AnalysisFeedbackStatus {
  submitted('SUBMITTED'),
  underReview('UNDER_REVIEW'),
  resolved('RESOLVED'),
  rejected('REJECTED');

  const AnalysisFeedbackStatus(this.code);

  final String code;

  static AnalysisFeedbackStatus? fromCode(String? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// 관리자 검수용 분석 피드백 항목.
class AdminAnalysisFeedback {
  const AdminAnalysisFeedback({
    required this.feedbackId,
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    required this.feedbackType,
    required this.feedbackTypeDescription,
    required this.userJudgment,
    required this.relatedSignals,
    required this.detail,
    required this.attachmentUrl,
    required this.replyEmail,
    required this.status,
    required this.statusDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  final int feedbackId;
  final int reviewId;
  final String productName;
  final String reviewContent;
  final String feedbackType;
  final String feedbackTypeDescription;
  final String? userJudgment;
  final List<String> relatedSignals;
  final String? detail;
  final String? attachmentUrl;
  final String? replyEmail;
  final AnalysisFeedbackStatus? status;
  final String statusDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminAnalysisFeedback copyWith({
    AnalysisFeedbackStatus? status,
    String? statusDescription,
    DateTime? updatedAt,
  }) {
    return AdminAnalysisFeedback(
      feedbackId: feedbackId,
      reviewId: reviewId,
      productName: productName,
      reviewContent: reviewContent,
      feedbackType: feedbackType,
      feedbackTypeDescription: feedbackTypeDescription,
      userJudgment: userJudgment,
      relatedSignals: relatedSignals,
      detail: detail,
      attachmentUrl: attachmentUrl,
      replyEmail: replyEmail,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

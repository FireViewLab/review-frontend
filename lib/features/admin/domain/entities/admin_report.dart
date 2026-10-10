/// 신고 처리 상태.
enum ReportStatus {
  pending('PENDING'),
  underReview('UNDER_REVIEW'),
  accepted('ACCEPTED'),
  rejected('REJECTED');

  const ReportStatus(this.code);

  final String code;

  static ReportStatus? fromCode(String? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// 관리자 검수용 신고 항목.
class AdminReport {
  const AdminReport({
    required this.reportId,
    required this.reviewId,
    required this.productName,
    required this.reviewContent,
    required this.reason,
    required this.reasonDescription,
    required this.detail,
    required this.attachmentUrl,
    required this.includeAiEvidence,
    required this.status,
    required this.statusDescription,
    required this.adminComment,
    required this.createdAt,
    required this.updatedAt,
    this.externalReviewId,
    this.productExternalId,
  });

  final String? externalReviewId;
  final String? productExternalId;
  final int reportId;
  final int? reviewId;
  final String productName;
  final String? reviewContent;
  final String reason;
  final String reasonDescription;
  final String detail;
  final String? attachmentUrl;
  final bool includeAiEvidence;
  final ReportStatus? status;
  final String statusDescription;
  final String? adminComment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminReport copyWith({
    ReportStatus? status,
    String? statusDescription,
    String? adminComment,
    bool clearAdminComment = false,
    DateTime? updatedAt,
  }) {
    return AdminReport(
      reportId: reportId,
      reviewId: reviewId,
      externalReviewId: externalReviewId,
      productExternalId: productExternalId,
      productName: productName,
      reviewContent: reviewContent,
      reason: reason,
      reasonDescription: reasonDescription,
      detail: detail,
      attachmentUrl: attachmentUrl,
      includeAiEvidence: includeAiEvidence,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      adminComment:
          clearAdminComment ? null : (adminComment ?? this.adminComment),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

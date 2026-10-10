import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

class ReviewReportDto {
  const ReviewReportDto({
    required this.reportId,
    required this.reviewId,
    required this.reason,
    required this.status,
    required this.productName,
    required this.reviewContent,
    this.detail,
    this.attachmentUrl,
    this.includeAiEvidence = false,
    this.externalReviewId,
    this.productExternalId,
    this.createdAt,
  });

  factory ReviewReportDto.fromJson(Map<String, dynamic> json) {
    return ReviewReportDto(
      reportId: (json['reportId'] ?? json['id'] ?? 0) as int,
      reviewId: (json['reviewId'] as num?)?.toInt(),
      reason: (json['reason'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      productName: (json['productName'] ?? '').toString(),
      reviewContent: (json['reviewContent'] ?? json['reviewContentSummary'])?.toString(),
      detail: json['detail']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      includeAiEvidence: json['includeAiEvidence'] == true,
      externalReviewId: json['externalReviewId']?.toString(),
      productExternalId: json['productExternalId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  final int reportId;
  final int? reviewId;
  final String reason;
  final String status;
  final String productName;
  final String? reviewContent;
  final String? detail;
  final String? attachmentUrl;
  final bool includeAiEvidence;
  final String? externalReviewId;
  final String? productExternalId;
  final DateTime? createdAt;

  ReviewReport toEntity() => ReviewReport(
    reportId: reportId,
    reviewId: reviewId,
    reason: reason,
    status: status,
    productName: productName,
    reviewContent: reviewContent,
    detail: detail,
    attachmentUrl: attachmentUrl,
    includeAiEvidence: includeAiEvidence,
    externalReviewId: externalReviewId,
    productExternalId: productExternalId,
    createdAt: createdAt,
  );
}

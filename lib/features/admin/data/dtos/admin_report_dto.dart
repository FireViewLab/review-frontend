import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';

class AdminReportDto {
  const AdminReportDto(this._json);

  final Map<String, dynamic> _json;

  AdminReport toEntity() {
    return AdminReport(
      reportId: (_json['reportId'] as num?)?.toInt() ?? 0,
      reviewId: (_json['reviewId'] as num?)?.toInt(),
      externalReviewId: _json['externalReviewId']?.toString(),
      productExternalId: _json['productExternalId']?.toString(),
      productName: _json['productName']?.toString() ?? '',
      reviewContent: (_json['reviewContent'] ?? _json['reviewContentSummary'])?.toString(),
      reason: _json['reason']?.toString() ?? '',
      reasonDescription: _json['reasonDescription']?.toString() ?? '',
      detail: _json['detail']?.toString() ?? '',
      attachmentUrl: _json['attachmentUrl']?.toString(),
      includeAiEvidence: _json['includeAiEvidence'] == true,
      status: ReportStatus.fromCode(_json['status']?.toString()),
      statusDescription: _json['statusDescription']?.toString() ?? '',
      adminComment: _json['adminComment']?.toString(),
      createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(_json['updatedAt']?.toString() ?? ''),
    );
  }
}

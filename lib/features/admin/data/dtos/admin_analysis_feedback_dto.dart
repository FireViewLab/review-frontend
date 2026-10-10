import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';

class AdminAnalysisFeedbackDto {
  const AdminAnalysisFeedbackDto(this._json);

  final Map<String, dynamic> _json;

  AdminAnalysisFeedback toEntity() {
    final signals = _json['relatedSignals'];
    return AdminAnalysisFeedback(
      feedbackId: (_json['feedbackId'] as num?)?.toInt() ?? 0,
      reviewId: (_json['reviewId'] as num?)?.toInt() ?? 0,
      productName: _json['productName']?.toString() ?? '',
      reviewContent: _json['reviewContent']?.toString() ?? '',
      feedbackType: _json['feedbackType']?.toString() ?? '',
      feedbackTypeDescription:
          _json['feedbackTypeDescription']?.toString() ?? '',
      userJudgment: _json['userJudgment']?.toString(),
      relatedSignals: <String>[
        if (signals is List)
          for (final s in signals) s.toString(),
      ],
      detail: _json['detail']?.toString(),
      attachmentUrl: _json['attachmentUrl']?.toString(),
      replyEmail: _json['replyEmail']?.toString(),
      status: AnalysisFeedbackStatus.fromCode(_json['status']?.toString()),
      statusDescription: _json['statusDescription']?.toString() ?? '',
      createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(_json['updatedAt']?.toString() ?? ''),
    );
  }
}

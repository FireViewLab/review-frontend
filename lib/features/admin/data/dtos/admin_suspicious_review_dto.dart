import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';

class AdminSuspiciousReviewDto {
  const AdminSuspiciousReviewDto(this._json);

  final Map<String, dynamic> _json;

  AdminSuspiciousReview toEntity() {
    final reasons = _json['reasons'];
    return AdminSuspiciousReview(
      reviewId: (_json['reviewId'] as num?)?.toInt() ?? 0,
      productId: (_json['productId'] as num?)?.toInt() ?? 0,
      productName: _json['productName']?.toString() ?? '',
      reviewerNickname: _json['reviewerNickname']?.toString() ?? '',
      content: _json['content']?.toString() ?? '',
      rating: (_json['rating'] as num?)?.toInt() ?? 0,
      rtiScore: (_json['rtiScore'] as num?)?.toDouble() ?? 0,
      trustGrade: TrustGrade.fromCode(_json['trustGrade']?.toString()),
      reasons: <String>[
        if (reasons is List)
          for (final r in reasons) r.toString(),
      ],
      isVerifiedPurchase: _json['isVerifiedPurchase'] == true,
      writtenAt: DateTime.tryParse(_json['writtenAt']?.toString() ?? ''),
    );
  }
}

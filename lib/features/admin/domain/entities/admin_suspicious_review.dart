/// 리뷰 신뢰 등급.
enum TrustGrade {
  danger('DANGER'),
  warning('WARNING'),
  safe('SAFE');

  const TrustGrade(this.code);

  final String code;

  static TrustGrade? fromCode(String? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// 관리자 검토용 의심 리뷰 항목.
class AdminSuspiciousReview {
  const AdminSuspiciousReview({
    required this.reviewId,
    required this.productId,
    required this.productName,
    required this.reviewerNickname,
    required this.content,
    required this.rating,
    required this.rtiScore,
    required this.trustGrade,
    required this.reasons,
    required this.isVerifiedPurchase,
    required this.writtenAt,
  });

  final int reviewId;
  final int productId;
  final String productName;
  final String reviewerNickname;
  final String content;
  final int rating;
  final double rtiScore;
  final TrustGrade? trustGrade;
  final List<String> reasons;
  final bool isVerifiedPurchase;
  final DateTime? writtenAt;
}

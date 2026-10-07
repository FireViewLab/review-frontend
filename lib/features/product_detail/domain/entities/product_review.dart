import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductReview {
  const ProductReview({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.platform,
    required this.isVerifiedPurchase,
    required this.rtiScore,
    required this.rtiColor,
    required this.rtiLabel,
    this.imageUrls = const [],
    this.hashtags = const [],
    this.reasons = const [],
    this.rtiDetail,
  });

  final int id;
  final String authorName;
  final String? authorAvatarUrl;
  final double rating;
  final String content;
  final String createdAt;
  final String platform;
  final bool isVerifiedPurchase;
  final int? rtiScore;
  final String? rtiColor;
  final String? rtiLabel;
  final List<String> imageUrls;
  final List<String> hashtags;
  final List<String> reasons;
  final ReviewRtiDetail? rtiDetail;
}

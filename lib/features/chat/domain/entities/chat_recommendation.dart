import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

/// Real products returned as structured alternatives, never extracted from prose.
class ChatRecommendation {
  const ChatRecommendation({
    required this.ref,
    required this.name,
    this.price,
    this.thumbnailUrl,
    this.reviewCount,
    this.rating,
    this.observedAt,
  });
  final ExternalProductRef ref;
  final String name;
  final int? price;
  final String? thumbnailUrl;
  final int? reviewCount;
  final double? rating;
  final DateTime? observedAt;

  ProductSummary get summary => ProductSummary(
    product: ExternalProduct(
      ref: ref,
      name: name,
      price: price,
      thumbnailUrl: thumbnailUrl,
      reviewCount: reviewCount,
      rating: rating,
    ),
    observedAt: observedAt,
  );
}

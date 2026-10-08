import '../../domain/entities/external_product.dart';
import '../../domain/entities/external_product_ref.dart';

/// Preserves nullable values from a list response before display formatting.
class ProductSummaryDto {
  static ProductSummary? fromJson(
    Map<String, dynamic> json, {
    bool cart = false,
  }) {
    final target = ExternalProductRef.resolve(
      externalId: text(json['externalId']),
      dataPlatform: text(json['dataPlatform']),
      dataProductId: text(json['dataProductId']),
    );
    if (target == null) return null;
    final rawId = cart
        ? json['productId'] ?? json['product_id']
        : json['productId'] ?? json['id'];
    final platforms = json['platforms'];
    Map? shop;
    if (platforms is List) {
      for (final item in platforms) {
        if (item is Map &&
            text(item['platform'])?.toLowerCase() == target.platform) {
          shop = item;
          break;
        }
      }
    }
    return ProductSummary(
      springProductId: integer(rawId),
      observedAt: DateTime.now(),
      product: ExternalProduct(
        ref: target,
        name: text(json['name'] ?? json['productName'] ?? json['title']) ?? '',
        thumbnailUrl: text(
          json['imageUrl'] ??
              json['image_url'] ??
              json['thumbnailUrl'] ??
              json['thumbnail'] ??
              json['image'],
        ),
        price: integer(
          json['price'] ??
              json['salePrice'] ??
              json['currentPrice'] ??
              json['discountPrice'] ??
              json['lowestPrice'] ??
              shop?['price'],
        ),
        url: webUrl(json['url'] ?? json['purchaseUrl'] ?? shop?['url']),
        seller: text(
          json['platform'] ?? json['storeName'] ?? shop?['platform'],
        ),
        brand: text(json['brand']),
        category: text(json['subCategory'] ?? json['categoryDisplayName']),
        reviewCount: integer(json['reviewCount'] ?? json['review_count']),
        rating: number(
          json['avgRating'] ?? json['rating'] ?? json['starRating'],
        ),
      ),
    );
  }

  static String? text(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static int? integer(Object? value) {
    final parsed = number(value);
    return parsed != null &&
            parsed.isFinite &&
            parsed == parsed.truncateToDouble()
        ? parsed.toInt()
        : null;
  }

  static double? number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse(text(value) ?? '');
  static String? webUrl(Object? value) {
    final textValue = text(value);
    final uri = Uri.tryParse(textValue ?? '');
    return uri != null &&
            (uri.scheme == 'https' || uri.scheme == 'http') &&
            uri.host.isNotEmpty
        ? textValue
        : null;
  }
}

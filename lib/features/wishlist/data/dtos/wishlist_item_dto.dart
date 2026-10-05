import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';

class WishlistItemDto {
  const WishlistItemDto({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.categoryDisplayName,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.reviewCount,
    required this.avgRating,
    required this.isPriceDrop,
    required this.isNewAlert,
    this.platform,
    this.savedAt,
  });

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) {
    return WishlistItemDto(
      productId: _readInt(json, ['productId', 'id']),
      name: _readString(json, ['name', 'productName', 'title']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      price: _readInt(json, ['price', 'salePrice', 'currentPrice']),
      category: _readString(json, ['category', 'categoryCode']),
      categoryDisplayName: _readNullableString(json, [
        'categoryDisplayName',
        'categoryName',
        'category',
      ]),
      avgRti: _readDouble(json, ['avgRti', 'rtiScore', 'rti']),
      rtiGrade: _readNullableString(json, ['rtiGrade', 'grade']),
      rtiColor: _readNullableString(json, ['rtiColor', 'color']),
      reviewCount: _readInt(json, ['reviewCount', 'review_count']),
      avgRating: _readDouble(json, ['avgRating', 'rating', 'starRating']) ?? 0.0,
      isPriceDrop: json['isPriceDrop'] == true || json['priceDrop'] == true,
      isNewAlert: json['isNewAlert'] == true || json['newAlert'] == true,
      platform: _readNullableString(json, ['platform', 'storeName', 'brandName']),
      savedAt: _readDateTime(json, ['savedAt', 'createdAt', 'wishlistAt']),
    );
  }

  final int productId;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String? categoryDisplayName;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int reviewCount;
  final double avgRating;
  final bool isPriceDrop;
  final bool isNewAlert;
  final String? platform;
  final DateTime? savedAt;

  WishlistItem toEntity() {
    return WishlistItem(
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      category: category,
      categoryDisplayName: categoryDisplayName,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      reviewCount: reviewCount,
      avgRating: avgRating,
      isPriceDrop: isPriceDrop,
      isNewAlert: isNewAlert,
      platform: platform,
      savedAt: savedAt,
    );
  }
}

String _readString(Map<String, dynamic> json, List<String> keys) =>
    _readNullableString(json, keys) ?? '';

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return null;
}

int _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
  }
  return 0;
}

double? _readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
  }
  return null;
}

DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
  }
  return null;
}

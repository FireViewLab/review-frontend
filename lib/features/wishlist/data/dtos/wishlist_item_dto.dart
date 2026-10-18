import 'package:re_view_front/features/external_product/data/dtos/product_summary_dto.dart';
import 'package:re_view_front/features/external_product/domain/entities/product_summary.dart';
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
    this.priceDropStatus,
    this.platform,
    this.savedAt,
    this.summary,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) {
    return WishlistItemDto(
      summary: ProductSummaryDto.fromJson(json),
      externalId: json['externalId'] as String?,
      dataPlatform: json['dataPlatform'] as String?,
      dataProductId: json['dataProductId']?.toString(),
      subCategory: json['subCategory'] as String?,
      productId: _readInt(json, ['productId', 'id']),
      name: _readString(json, ['name', 'productName', 'title']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      price: _readNullableInt(json, ['price', 'salePrice', 'currentPrice']),
      category: _readString(json, ['category', 'categoryCode']),
      categoryDisplayName: _readNullableString(json, [
        'categoryDisplayName',
        'categoryName',
        'category',
      ]),
      avgRti: _readDouble(json, ['avgRti', 'rtiScore', 'rti']),
      rtiGrade: _readNullableString(json, ['rtiGrade', 'grade']),
      rtiColor: _readNullableString(json, ['rtiColor', 'color']),
      reviewCount: _readNullableInt(json, ['reviewCount', 'review_count']),
      avgRating: _readDouble(json, ['avgRating', 'rating', 'starRating']),
      priceDropStatus: _priceDrop(json),
      isPriceDrop: _priceDrop(json) ?? false,
      isNewAlert: json['isNewAlert'] == true || json['newAlert'] == true,
      platform: _readNullableString(json, [
        'platform',
        'storeName',
        'brandName',
      ]),
      savedAt: _readDateTime(json, [
        'savedAt',
        'addedAt',
        'createdAt',
        'wishlistAt',
      ]),
    );
  }

  final ProductSummary? summary;
  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;

  final int productId;
  final String name;
  final String imageUrl;
  final int? price;
  final String category;
  final String? categoryDisplayName;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int? reviewCount;
  final double? avgRating;
  final bool? priceDropStatus;
  final bool isPriceDrop;
  final bool isNewAlert;
  final String? platform;
  final DateTime? savedAt;

  WishlistItem toEntity() {
    return WishlistItem(
      summary: summary,
      externalId: externalId,
      dataPlatform: dataPlatform,
      dataProductId: dataProductId,
      subCategory: subCategory,
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
      priceDropStatus: priceDropStatus,
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

int _readInt(Map<String, dynamic> json, List<String> keys) =>
    _readNullableInt(json, keys) ?? 0;
int? _readNullableInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
  }
  return null;
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

bool? _priceDrop(Map<String, dynamic> json) {
  final value = json['isPriceDrop'] ?? json['priceDrop'];
  return value is bool ? value : null;
}

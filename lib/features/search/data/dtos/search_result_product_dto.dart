import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

class SearchResultProductDto {
  const SearchResultProductDto({
    required this.id,
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
    this.platform,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  factory SearchResultProductDto.fromJson(Map<String, dynamic> json) {
    return SearchResultProductDto(
      externalId: json['externalId'] as String?,
      dataPlatform: json['dataPlatform'] as String?,
      dataProductId: json['dataProductId']?.toString(),
      subCategory: json['subCategory'] as String?,
      id: _readInt(json, ['id', 'productId']),
      name: _readString(json, ['name', 'productName', 'title']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      price: _readInt(json, ['price', 'salePrice', 'discountPrice']),
      category: _readString(json, ['category', 'categoryCode']),
      categoryDisplayName: _readString(json, [
        'categoryDisplayName',
        'categoryName',
        'category',
      ]),
      avgRti: _readDouble(json, ['avgRti', 'rtiScore', 'rti']),
      rtiGrade: _readNullableString(json, ['rtiGrade', 'grade']),
      rtiColor: _readNullableString(json, ['rtiColor', 'color']),
      reviewCount: _readNullableInt(json, ['reviewCount', 'review_count']),
      avgRating: _readDouble(json, ['avgRating', 'rating', 'starRating']),
      platform: _readNullableString(json, [
        'platform',
        'storeName',
        'brandName',
      ]),
    );
  }

  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;

  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String categoryDisplayName;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int? reviewCount;
  final double? avgRating;
  final String? platform;

  SearchResultProduct toEntity() {
    final normalizedDisplayName =
        subCategory ??
        (category.isEmpty
            ? categoryDisplayName
            : normalizedCategoryLabel(
                category: category,
                categoryDisplayName: categoryDisplayName,
                productName: name,
              ));

    return SearchResultProduct(
      externalId: externalId,
      dataPlatform: dataPlatform,
      dataProductId: dataProductId,
      subCategory: subCategory,
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      category: category,
      categoryDisplayName: normalizedDisplayName,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      reviewCount: reviewCount,
      avgRating: avgRating,
      platform: platform,
    );
  }
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  return _readNullableString(json, keys) ?? '';
}

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

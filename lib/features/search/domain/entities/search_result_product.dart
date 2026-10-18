import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class SearchResultProduct {
  const SearchResultProduct({
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
    this.summary,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
    this.majorCategory,
  });

  final ProductSummary? summary;
  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;
  final String? majorCategory;
  ExternalProductRef? get externalRef => ExternalProductRef.resolve(
    dataPlatform: dataPlatform,
    dataProductId: dataProductId,
    externalId: externalId,
  );
  String get detailPath => externalRef?.routePath ?? '/product/$id';
  String? get chatProductId => (externalId?.trim().isNotEmpty ?? false)
      ? externalId
      : externalRef?.externalId;
  ProductRouteContext get routeContext =>
      ProductRouteContext(chatProductId: chatProductId, summary: summary);

  final int id;
  final String name;
  final String imageUrl;
  final int? price;
  final String category;
  final String categoryDisplayName;
  final String? platform;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int? reviewCount;
  final double? avgRating;
}

String? normalizeSearchPlatform(String? value) {
  final raw = value?.trim();
  if (raw == null || raw.isEmpty) return null;
  return switch (raw.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '')) {
    'kurly' || '컬리' || '마켓컬리' => '컬리',
    'oliveyoung' || '올리브영' => '올리브영',
    'musinsa' || '무신사' => '무신사',
    '11st' || '11street' || 'elevenst' || '11번가' => '11번가',
    _ => raw,
  };
}

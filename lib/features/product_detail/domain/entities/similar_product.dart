import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class SimilarProduct {
  const SimilarProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.avgRating,
    required this.reviewCount,
    required this.avgRti,
    required this.rtiColor,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;
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
      ProductRouteContext(chatProductId: chatProductId);

  final int id;
  final String name;
  final String brand;
  final String imageUrl;
  final int price;
  final double? avgRating;
  final int? reviewCount;
  final double? avgRti;
  final String? rtiColor;
}

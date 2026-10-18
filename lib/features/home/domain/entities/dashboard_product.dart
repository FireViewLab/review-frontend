import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class DashboardProduct {
  const DashboardProduct({
    required this.id,
    required this.name,
    required this.storeName,
    required this.price,
    required this.imageUrl,
    this.label,
    this.rating,
    this.reviewCount,
    this.rtiScore,
    this.summary,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  final ProductSummary? summary;
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
      ProductRouteContext(chatProductId: chatProductId, summary: summary);

  final String id;
  final String name;
  final String storeName;
  final int price;
  final String imageUrl;
  final String? label;
  final double? rating;
  final int? reviewCount;
  final int? rtiScore;
}

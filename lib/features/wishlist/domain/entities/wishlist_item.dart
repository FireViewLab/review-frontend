import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class WishlistItem {
  const WishlistItem({
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
  String get detailPath => externalRef?.routePath ?? '/product/$productId';
  String? get chatProductId => (externalId?.trim().isNotEmpty ?? false)
      ? externalId
      : externalRef?.externalId;
  ProductRouteContext get routeContext =>
      ProductRouteContext(chatProductId: chatProductId, summary: summary);

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

  /// The server owns grade thresholds. An unanalysed product is never a warning.
  bool get needsAttention =>
      avgRti != null &&
      avgRti!.isFinite &&
      avgRti! >= 0 &&
      avgRti! <= 100 &&
      const {'SUSPICIOUS', 'DANGER'}.contains(rtiGrade?.trim().toUpperCase());

  /// Null means the server did not provide a comparison, not a confirmed false.
  final bool? priceDropStatus;
  bool get hasPriceDropInformation => priceDropStatus != null || isPriceDrop;
  final bool isPriceDrop;
  final bool isNewAlert;
  final String? platform;
  final DateTime? savedAt;
}

import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class CartItem {
  const CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.trustLevel,
    required this.shippingFee,
    this.originalPrice,
    this.priceDropAmount,
    this.variant,
    this.platform,
    this.badge,
    this.estimatedDelivery,
    this.stockCount,
    this.maxQuantity = 99,
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

  final int cartItemId;
  final int productId;
  final String name;
  final String imageUrl;
  final int? price;
  final int quantity;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final String trustLevel;
  final int shippingFee;
  final int? originalPrice;
  final int? priceDropAmount;
  final String? variant;
  final String? platform;
  final String? badge;
  final String? estimatedDelivery;
  final int? stockCount;
  final int maxQuantity;

  bool get isFreeShipping => shippingFee == 0;
  bool get isLowStock => stockCount != null && stockCount! <= 5;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      summary: summary,
      externalId: externalId,
      dataPlatform: dataPlatform,
      dataProductId: dataProductId,
      subCategory: subCategory,
      cartItemId: cartItemId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      trustLevel: trustLevel,
      shippingFee: shippingFee,
      originalPrice: originalPrice,
      priceDropAmount: priceDropAmount,
      variant: variant,
      platform: platform,
      badge: badge,
      estimatedDelivery: estimatedDelivery,
      stockCount: stockCount,
      maxQuantity: maxQuantity,
    );
  }
}

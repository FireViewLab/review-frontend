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
  });

  final int cartItemId;
  final int productId;
  final String name;
  final String imageUrl;
  final int price;
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

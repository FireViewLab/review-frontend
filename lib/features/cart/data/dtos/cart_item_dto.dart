import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';

class CartItemDto {
  const CartItemDto({
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
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      externalId: json['externalId'] as String?,
      dataPlatform: json['dataPlatform'] as String?,
      dataProductId: json['dataProductId']?.toString(),
      subCategory: json['subCategory'] as String?,
      cartItemId: _readInt(json, ['cartItemId', 'cartId', 'id']),
      productId: _readInt(json, ['productId', 'product_id']),
      name: _readString(json, ['name', 'productName', 'title']),
      imageUrl: _readString(json, [
        'imageUrl',
        'image_url',
        'thumbnailUrl',
        'thumbnail',
        'image',
      ]),
      price: _readInt(json, ['price', 'salePrice', 'currentPrice']),
      quantity: _readInt(json, ['quantity', 'qty', 'count']),
      avgRti: _readDouble(json, ['avgRti', 'rtiScore', 'rti']),
      rtiGrade: _readNullableString(json, ['rtiGrade', 'grade']),
      rtiColor: _readNullableString(json, ['rtiColor', 'color']),
      trustLevel: _readString(json, ['trustLevel', 'trust', 'rtiLabel']),
      shippingFee: _readInt(json, [
        'shippingFee',
        'shipping_fee',
        'deliveryFee',
      ]),
      originalPrice: _readNullableInt(json, [
        'originalPrice',
        'regularPrice',
        'listPrice',
      ]),
      priceDropAmount: _readNullableInt(json, [
        'priceDropAmount',
        'discountAmount',
        'priceDrop',
      ]),
      variant: _readNullableString(json, ['variant', 'option', 'optionName']),
      platform: _readNullableString(json, [
        'platform',
        'storeName',
        'brandName',
      ]),
      badge: _readNullableString(json, ['badge', 'label', 'tag']),
      estimatedDelivery: _readNullableString(json, [
        'estimatedDelivery',
        'deliveryDate',
        'delivery',
      ]),
      stockCount: _readNullableInt(json, [
        'stockCount',
        'stock',
        'remainStock',
      ]),
      maxQuantity: _readInt(json, ['maxQuantity', 'maxQty']) == 0
          ? 99
          : _readInt(json, ['maxQuantity', 'maxQty']),
    );
  }

  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;

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

  CartItem toEntity() {
    return CartItem(
      externalId: externalId,
      dataPlatform: dataPlatform,
      dataProductId: dataProductId,
      subCategory: subCategory,
      cartItemId: cartItemId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity,
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

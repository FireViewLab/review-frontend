import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/cart/data/dtos/cart_item_dto.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';

abstract interface class CartRemoteDataSource {
  Future<({List<CartItemDto> items, CartSummary summary})> getCart();
  Future<void> addItem(int productId, {int quantity = 1});
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeItem(int productId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const _basePath = '/api/cart';

  @override
  Future<({List<CartItemDto> items, CartSummary summary})> getCart() async {
    final response = await _apiClient.get(_basePath);
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid cart response');
    }

    final payload = ApiResponse<Object?>.fromJson(data);
    final body = payload.requireSuccess();

    if (body is List<dynamic>) {
      final items = body
          .whereType<Map<String, dynamic>>()
          .map(CartItemDto.fromJson)
          .toList();
      return (items: items, summary: _computeSummary(items));
    }

    if (body is Map<String, dynamic>) {
      final rawItems = body['items'] ?? body['cartItems'] ?? body['data'] ?? [];
      final items = (rawItems as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(CartItemDto.fromJson)
          .toList();

      final summaryRaw = body['summary'] ?? body['total'] ?? body;
      final summary = summaryRaw is Map<String, dynamic>
          ? _parseSummary(summaryRaw, items)
          : _computeSummary(items);

      return (items: items, summary: summary);
    }

    throw const FormatException('Invalid cart response');
  }

  @override
  Future<void> addItem(int productId, {int quantity = 1}) async {
    final response = await _apiClient.post(
      '$_basePath/$productId',
      queryParameters: {'quantity': quantity},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final response = await _apiClient.put(
      '$_basePath/$productId',
      queryParameters: {'quantity': quantity},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  @override
  Future<void> removeItem(int productId) async {
    final response = await _apiClient.delete('$_basePath/$productId');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  @override
  Future<void> clearCart() async {
    final response = await _apiClient.delete(_basePath);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  CartSummary _parseSummary(
    Map<String, dynamic> json,
    List<CartItemDto> items,
  ) {
    final computed = _computeSummary(items);
    return CartSummary(
      totalProductPrice:
          _readInt(json, [
            'totalProductPrice',
            'productTotal',
            'subtotal',
            'totalPrice',
          ]) ??
          computed.totalProductPrice,
      shippingFee:
          _readInt(json, ['shippingFee', 'shipping', 'deliveryFee']) ?? 0,
      discountAmount:
          _readInt(json, ['discountAmount', 'discount', 'couponDiscount']) ?? 0,
      totalPayment:
          _readInt(json, [
            'totalPayment',
            'total',
            'finalPrice',
            'paymentAmount',
          ]) ??
          computed.totalProductPrice,
      expectedPoint: _readInt(json, ['expectedPoint', 'point', 'points']) ?? 0,
      appliedCouponName: _readNullableString(json, ['couponName', 'coupon']),
      appliedCouponDiscount:
          _readInt(json, ['couponDiscount', 'appliedCoupon']) ?? 0,
    );
  }

  CartSummary _computeSummary(List<CartItemDto> items) {
    final total = items.fold(0, (sum, i) => sum + (i.price ?? 0) * i.quantity);
    return CartSummary(
      totalProductPrice: total,
      shippingFee: 0,
      discountAmount: 0,
      totalPayment: total,
    );
  }
}

int? _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
  }
  return null;
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

import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/wishlist/data/dtos/wishlist_item_dto.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';

abstract interface class WishlistRemoteDataSource {
  Future<({List<WishlistItemDto> items, WishlistSummary summary})>
  getWishlist();
  Future<void> addWishlist(int productId);
  Future<void> removeWishlist(int productId);
  Future<bool> checkWishlist(int productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  const WishlistRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const _basePath = '/api/wishlist';

  @override
  Future<({List<WishlistItemDto> items, WishlistSummary summary})>
  getWishlist() async {
    final response = await _apiClient.get(_basePath);
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid wishlist response');
    }

    final payload = ApiResponse<Object?>.fromJson(data);
    final body = payload.requireSuccess();

    if (body is List<dynamic>) {
      final items = body
          .whereType<Map<String, dynamic>>()
          .map(WishlistItemDto.fromJson)
          .toList();
      return (items: items, summary: _computeSummary(items));
    }

    if (body is Map<String, dynamic>) {
      final rawItems = body['items'] ?? body['data'] ?? body['content'] ?? [];
      final items = (rawItems as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(WishlistItemDto.fromJson)
          .toList();

      final summaryRaw = body['summary'];
      final summary = summaryRaw is Map<String, dynamic>
          ? _parseSummary(summaryRaw, items)
          : _computeSummary(items);

      return (items: items, summary: summary);
    }

    throw const FormatException('Invalid wishlist response');
  }

  @override
  Future<void> addWishlist(int productId) async {
    final response = await _apiClient.post('$_basePath/$productId');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  @override
  Future<void> removeWishlist(int productId) async {
    final response = await _apiClient.delete('$_basePath/$productId');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }

  @override
  Future<bool> checkWishlist(int productId) async {
    final response = await _apiClient.get('$_basePath/$productId/check');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();
      if (body is bool) return body;
      if (body is Map<String, dynamic>) {
        return body['isWishlist'] == true ||
            body['wishlist'] == true ||
            body['liked'] == true;
      }
    }
    return false;
  }

  WishlistSummary _parseSummary(
    Map<String, dynamic> json,
    List<WishlistItemDto> items,
  ) {
    return WishlistSummary(
      priceDropCount:
          _readInt(json, ['priceDropCount', 'priceDrop', 'dropCount']) ??
          items.where((i) => i.isPriceDrop).length,
      newAlertCount:
          _readInt(json, ['newAlertCount', 'newAlert', 'alertCount']) ??
          items.where((i) => i.isNewAlert).length,
      totalReviewCount:
          _readInt(json, ['totalReviewCount', 'reviewCount', 'total']) ??
          items.fold(0, (sum, i) => sum + (i.reviewCount ?? 0)),
    );
  }

  WishlistSummary _computeSummary(List<WishlistItemDto> items) {
    return WishlistSummary(
      priceDropCount: items.where((i) => i.isPriceDrop).length,
      newAlertCount: items.where((i) => i.isNewAlert).length,
      totalReviewCount: items.fold(0, (sum, i) => sum + (i.reviewCount ?? 0)),
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

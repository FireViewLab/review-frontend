import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/recent_products/domain/repositories/recent_products_repository.dart';
import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

class RecentProductsRepositoryImpl implements RecentProductsRepository {
  const RecentProductsRepositoryImpl(this.client, this.config);
  final ApiClient client;
  final AppConfig config;

  @override
  Future<Result<List<SearchResultProduct>>> getRecentProducts() async {
    try {
      final response = await client.get(config.homeDashboardPath);
      final json = response.data;
      if (json is! Map<String, dynamic>) throw const FormatException();
      final body = ApiResponse<Object?>.fromJson(json).requireSuccess();
      if (body is! Map<String, dynamic> || body['recentProducts'] is! List) {
        throw const FormatException('Missing recent history');
      }
      final unique = <String>{};
      final items = <SearchResultProduct>[];
      for (final json
          in (body['recentProducts'] as List)
              .whereType<Map<String, dynamic>>()) {
        final item = SearchResultProductDto.fromJson(json).toEntity();
        if (item.name.trim().isEmpty ||
            (item.externalRef == null && item.id <= 0)) {
          continue;
        }
        if (unique.add(item.externalRef?.externalId ?? 'id:${item.id}')) {
          items.add(item);
        }
      }
      return Success(items);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '최근 본 상품을 불러오지 못했습니다.', cause: error),
      );
    }
  }
}

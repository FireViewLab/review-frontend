import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/data/datasources/search_remote_data_source.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<Result<SearchResponse>> searchProducts(SearchParams params) async {
    try {
      final dto = params.catalog
          ? await _remoteDataSource.catalogProducts(
              category: params.category,
              page: params.page,
              size: params.size,
            )
          : await _remoteDataSource.searchProducts(query: params.query);
      return Success(dto.toEntity());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '검색 결과를 불러오지 못했습니다.', cause: error),
      );
    }
  }
}

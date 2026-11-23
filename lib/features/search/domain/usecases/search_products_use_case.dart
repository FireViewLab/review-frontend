import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';

class SearchParams {
  const SearchParams({
    required this.query,
    this.catalog = false,
    this.category,
    this.page = 0,
    this.size = 40,
  });

  final String query;

  /// 키워드 검색 대신 카테고리·페이지 단위 카탈로그 목록을 조회한다.
  final bool catalog;
  final String? category;
  final int page;
  final int size;
}

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final SearchRepository _repository;

  Future<Result<SearchResponse>> call(SearchParams params) =>
      _repository.searchProducts(params);
}

import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

sealed class SearchState {
  const SearchState();

  bool get isLoading => this is SearchLoading;
  bool get isSuccess => this is SearchSuccess;
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

sealed class SearchCompleted extends SearchState {
  const SearchCompleted({required this.query});

  final String query;
}

class SearchSuccess extends SearchCompleted {
  const SearchSuccess({
    required super.query,
    required this.products,
    required this.totalCount,
  });

  final List<SearchResultProduct> products;
  final int totalCount;

  bool get isEmpty => products.isEmpty;
}

class SearchEmpty extends SearchCompleted {
  const SearchEmpty({required super.query});
}

class SearchFailure extends SearchState {
  const SearchFailure(this.failure);

  final Failure failure;
}

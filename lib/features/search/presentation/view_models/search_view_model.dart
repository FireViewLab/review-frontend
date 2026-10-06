import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';

class SearchViewModel extends Notifier<SearchState> {
  int _request = 0;
  late final SearchProductsUseCase _searchProductsUseCase;

  @override
  SearchState build() {
    _searchProductsUseCase = ref.watch(searchProductsUseCaseProvider);
    return const SearchInitial();
  }

  Future<void> search(String query, {bool allowEmpty = false}) async {
    final request = ++_request;
    if (query.trim().isEmpty && !allowEmpty) {
      state = const SearchInitial();
      return;
    }

    if (!ref.mounted) return;
    state = const SearchLoading();

    final result = await _searchProductsUseCase(
      SearchParams(query: query.trim()),
    );

    if (!ref.mounted) return;
    if (request != _request) return;
    state = result.when(
      success: (response) => response.isEmpty
          ? const SearchEmpty()
          : SearchSuccess(
              products: response.products,
              totalCount: response.totalCount,
            ),
      failure: SearchFailure.new,
    );
  }
}

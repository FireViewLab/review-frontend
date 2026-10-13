import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';

class SearchViewModel extends Notifier<SearchState> {
  static const _cacheTtl = Duration(minutes: 3);
  static const _cacheLimit = 20;

  int _request = 0;
  late final SearchProductsUseCase _searchProductsUseCase;

  /// 같은 검색어로 돌아왔을 때 바로 보여 줄 최근 결과. 오류는 담지 않는다.
  final _cache = <String, ({DateTime fetchedAt, SearchState state})>{};

  @override
  SearchState build() {
    _searchProductsUseCase = ref.watch(searchProductsUseCaseProvider);
    return const SearchInitial();
  }

  /// [refresh]가 true면 저장된 결과를 쓰지 않고 새로 받는다.
  Future<void> search(
    String query, {
    bool allowEmpty = false,
    bool refresh = false,
  }) async {
    final request = ++_request;
    final key = query.trim();
    if (key.isEmpty && !allowEmpty) {
      state = const SearchInitial();
      return;
    }

    if (!ref.mounted) return;
    final cached = _cache[key];
    if (!refresh &&
        cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _cacheTtl) {
      state = cached.state;
      return;
    }
    state = const SearchLoading();

    final result = await _searchProductsUseCase(SearchParams(query: key));

    if (!ref.mounted) return;
    final next = result.when<SearchState>(
      success: (response) => response.isEmpty
          ? const SearchEmpty()
          : SearchSuccess(
              products: response.products,
              totalCount: response.totalCount,
            ),
      failure: SearchFailure.new,
    );
    if (next is! SearchFailure) _remember(key, next);
    if (request != _request) return;
    state = next;
  }

  void _remember(String key, SearchState value) {
    _cache.remove(key);
    _cache[key] = (fetchedAt: DateTime.now(), state: value);
    while (_cache.length > _cacheLimit) {
      _cache.remove(_cache.keys.first);
    }
  }
}

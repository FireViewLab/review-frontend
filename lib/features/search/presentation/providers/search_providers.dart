import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/search/data/datasources/search_remote_data_source.dart';
import 'package:re_view_front/features/search/data/repositories/search_repository_impl.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_view_model.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(searchRemoteDataSourceProvider));
});

final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  return SearchProductsUseCase(ref.watch(searchRepositoryProvider));
});

final searchViewModelProvider = NotifierProvider<SearchViewModel, SearchState>(
  SearchViewModel.new,
);

/// 같은 검색어를 다시 제출해도 필터를 초기화하고 검색을 새로 실행한다.
final searchResubmissionProvider = NotifierProvider<SearchResubmission, int>(
  SearchResubmission.new,
);

class SearchResubmission extends Notifier<int> {
  @override
  int build() => 0;

  void submit() => state++;
}

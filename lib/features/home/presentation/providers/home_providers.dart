import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/data/datasources/home_remote_data_source.dart';
import 'package:re_view_front/features/home/data/datasources/search_autocomplete_remote_data_source.dart';
import 'package:re_view_front/features/home/data/repositories/home_repository_impl.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_view_model.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final searchAutocompleteRemoteDataSourceProvider =
    Provider<SearchAutocompleteRemoteDataSource>((ref) {
      final source = GoogleSearchAutocompleteRemoteDataSource(
        dio: Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 2),
            receiveTimeout: const Duration(seconds: 3),
            headers: const {'Accept': 'application/json'},
          ),
        ),
      );
      ref.onDispose(source.dispose);
      return source;
    });

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
});

final getHomeDashboardUseCaseProvider = Provider<GetHomeDashboardUseCase>((
  ref,
) {
  return GetHomeDashboardUseCase(ref.watch(homeRepositoryProvider));
});

final homeDashboardViewModelProvider =
    NotifierProvider<HomeDashboardViewModel, HomeDashboardState>(
      HomeDashboardViewModel.new,
    );

final refreshHomeDashboardOnEnterProvider =
    NotifierProvider<RefreshHomeDashboardOnEnter, bool>(
      RefreshHomeDashboardOnEnter.new,
    );

class RefreshHomeDashboardOnEnter extends Notifier<bool> {
  @override
  bool build() => false;

  void request() {
    state = true;
  }

  void consume() {
    state = false;
  }
}

final homeCatalogProvider = FutureProvider<List<SearchResultProduct>>((
  ref,
) async {
  final result = await ref.watch(searchProductsUseCaseProvider)(
    const SearchParams(query: ''),
  );
  return result.when(success: (v) => v.products, failure: (f) => throw f);
});

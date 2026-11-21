import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_results_body.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group(SearchResultsPage, () {
    late GoRouter router;
    late _SearchRepository repository;

    setUp(() => repository = _SearchRepository());
    tearDown(() => router.dispose());

    Future<void> pumpSearch(
      WidgetTester tester, {
      Map<String, String> filters = const {},
    }) async {
      tester.view.physicalSize = const Size(1600, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      router = GoRouter(
        initialLocation: _location(filters),
        routes: [
          GoRoute(
            path: RoutePaths.search,
            builder: (context, state) => SearchResultsPage(
              query: state.uri.queryParameters['q'] ?? '',
              filterParams: state.uri.queryParameters,
            ),
          ),
        ],
      );
      await pumpApp(
        tester,
        ProviderScope(
          overrides: [searchRepositoryProvider.overrideWithValue(repository)],
          child: localizedApp(router: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    SearchResultsBody body(WidgetTester tester) =>
        tester.widget<SearchResultsBody>(find.byType(SearchResultsBody));
    Map<String, String> params() =>
        router.routeInformationProvider.value.uri.queryParameters;

    testWidgets('writes applied filters, sort, page and view to the address', (
      tester,
    ) async {
      await pumpSearch(tester);
      body(tester).onQuickFilterSelected('RTI 80+');
      await tester.pumpAndSettle();
      body(tester).onCategoryToggled('분류 B');
      body(tester).onCategoryToggled('분류 A');
      body(tester).onBrandSelected('컬리');
      body(tester).onReviewConditionToggled('리뷰 50개 이상');
      body(tester).onAttributeToggled('가격 정보 없음만');
      body(tester).minPriceController.text = '10000';
      body(tester).maxPriceController.text = '90000';
      body(tester).onPriceChanged();
      body(tester).onSortChanged(SearchSortOption.priceHigh);
      body(tester).onPageSizeChanged(60);
      body(tester).onViewModeChanged(SearchViewMode.list);
      await tester.pumpAndSettle();
      body(tester).onPageSelected(2);
      await tester.pumpAndSettle();
      expect(params(), {
        'q': '마스크',
        'campaign': 'autumn',
        'sort': 'best',
        'order': 'priceHigh',
        'page': '2',
        'size': '60',
        'view': 'list',
        'min': '10000',
        'max': '90000',
        'rti': '80',
        'mall': '컬리',
        'qf': 'RTI 80+',
        'cat': '분류 A|분류 B',
        'review': '리뷰 50개 이상',
        'attr': '가격 정보 없음만',
      });
      expect(repository.requests, 1);
    });

    testWidgets(
      'restores address filters into the result controls on first load',
      (tester) async {
        final filters = {
          'order': 'priceLow',
          'page': '3',
          'size': '60',
          'view': 'list',
          'min': '10000',
          'max': '90000',
          'rti': '80',
          'mall': '컬리',
          'qf': 'RTI 80+',
          'cat': '분류 A|분류 B',
          'review': '리뷰 50개 이상',
          'attr': '가격 정보 없음만',
        };
        await pumpSearch(tester, filters: filters);
        final result = body(tester);
        expect(result.sortOption, SearchSortOption.priceLow);
        expect(result.currentPage, 3);
        expect(result.pageSize, 60);
        expect(result.viewMode, SearchViewMode.list);
        expect(result.minPriceController.text, '10000');
        expect(result.maxPriceController.text, '90000');
        expect(result.selectedRtiMinimum, 80);
        expect(result.state.isRtiFilterActive, isTrue);
        expect(result.selectedBrand, '컬리');
        expect(result.selectedQuickFilter, 'RTI 80+');
        expect(result.selectedCategories, {'분류 A', '분류 B'});
        expect(result.selectedReviewConditions, {'리뷰 50개 이상'});
        expect(result.selectedAttributeFilters, {'가격 정보 없음만'});
        expect(params(), containsPair('campaign', 'autumn'));
        for (final entry in filters.entries) {
          expect(params(), containsPair(entry.key, entry.value));
        }
      },
    );

    testWidgets('serializes a named price range instead of manual limits', (
      tester,
    ) async {
      await pumpSearch(tester);
      body(tester).onPriceRangeToggled('10~30만원');
      await tester.pumpAndSettle();
      expect(params()['price'], '10~30만원');
      expect(params().keys, isNot(contains('min')));
      expect(params().keys, isNot(contains('max')));
      expect(body(tester).products.map((p) => p.id), [2]);
    });

    testWidgets(
      'restores a named price range and filters the loaded products',
      (tester) async {
        await pumpSearch(tester, filters: {'price': '10~30만원'});
        expect(body(tester).selectedPriceRanges, {'10~30만원'});
        expect(body(tester).minPriceController.text, '100000');
        expect(body(tester).maxPriceController.text, '300000');
        expect(body(tester).products.map((p) => p.id), [2]);
      },
    );

    testWidgets(
      'reset removes all filter keys while preserving other query parameters',
      (tester) async {
        await pumpSearch(
          tester,
          filters: {
            'order': 'priceLow',
            'page': '3',
            'size': '60',
            'view': 'list',
            'min': '10000',
            'max': '90000',
            'rti': '80',
            'mall': '컬리',
            'qf': 'RTI 80+',
            'cat': '뷰티',
            'review': '리뷰 50개 이상',
            'attr': '가격 정보 없음만',
          },
        );
        body(tester).onResetFilters();
        await tester.pumpAndSettle();
        expect(params(), {'q': '마스크', 'campaign': 'autumn', 'sort': 'best'});
        expect(
          params().keys.toSet().intersection(searchFilterQueryKeys),
          isEmpty,
        );
        expect(body(tester).sortOption, SearchSortOption.accuracy);
        expect(body(tester).currentPage, 1);
        expect(body(tester).pageSize, 30);
        expect(body(tester).viewMode, SearchViewMode.grid);
        expect(body(tester).selectedCategories, isEmpty);
        expect(body(tester).selectedBrand, isNull);
        expect(body(tester).products, hasLength(3));
      },
    );

    testWidgets('reset also removes a named price range from the address', (
      tester,
    ) async {
      await pumpSearch(tester, filters: {'price': '1만원 이하'});
      body(tester).onResetFilters();
      await tester.pumpAndSettle();
      expect(params(), {'q': '마스크', 'campaign': 'autumn', 'sort': 'best'});
      expect(body(tester).selectedPriceRanges, isEmpty);
    });

    testWidgets(
      'restores changed URL filters on the mounted page without another search',
      (tester) async {
        await pumpSearch(tester, filters: {'rti': '80', 'view': 'list'});
        expect(body(tester).products.map((p) => p.id), [1, 2]);
        router.go(_location({'rti': '50', 'order': 'priceHigh'}));
        await tester.pumpAndSettle();
        expect(body(tester).selectedRtiMinimum, 50);
        expect(body(tester).sortOption, SearchSortOption.priceHigh);
        expect(body(tester).viewMode, SearchViewMode.grid);
        expect(body(tester).products.map((p) => p.id), [2, 3, 1]);
        expect(repository.requests, 1);
        router.go(_location({}));
        await tester.pumpAndSettle();
        expect(body(tester).state.isRtiFilterActive, isFalse);
        expect(
          params().keys.toSet().intersection(searchFilterQueryKeys),
          isEmpty,
        );
      },
    );

    testWidgets(
      'ignores invalid paging values and clamps an out-of-range RTI',
      (tester) async {
        await pumpSearch(
          tester,
          filters: {
            'page': '-1',
            'size': 'invalid',
            'view': 'unknown',
            'order': 'unknown',
            'rti': '200',
          },
        );
        expect(body(tester).currentPage, 1);
        expect(body(tester).pageSize, 30);
        expect(body(tester).viewMode, SearchViewMode.grid);
        expect(body(tester).sortOption, SearchSortOption.accuracy);
        expect(body(tester).selectedRtiMinimum, 100);
        expect(params(), {
          'q': '마스크',
          'campaign': 'autumn',
          'sort': 'best',
          'rti': '100',
        });
      },
    );
  });
}

String _location(Map<String, String> filters) => Uri(
  path: RoutePaths.search,
  queryParameters: {
    'q': '마스크',
    'campaign': 'autumn',
    'sort': 'best',
    ...filters,
  },
).toString();

class _SearchRepository implements SearchRepository {
  int requests = 0;

  @override
  Future<Result<SearchResponse>> searchProducts(SearchParams params) async {
    requests++;
    final products = [
      for (final (id, price, rti) in [
        (1, 10000, 90),
        (2, 150000, 85),
        (3, 40000, 60),
      ])
        SearchResultProductDto.fromJson({
          'id': id,
          'name': '마스크 $id',
          'price': price,
          'avgRti': rti,
          'category': 'BEAUTY',
          'categoryDisplayName': '뷰티',
          'platform': '컬리',
          'reviewCount': 60,
        }).toEntity(),
    ];
    return Success(
      SearchResponse(products: products, totalCount: products.length),
    );
  }
}

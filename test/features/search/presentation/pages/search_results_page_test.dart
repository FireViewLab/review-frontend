import 'package:re_view_front/app/router/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_results_body.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late GoRouter router;
  late _FakeSearchRepository repository;

  Widget buildSubject(String query) {
    repository = _FakeSearchRepository();
    router = GoRouter(
      initialLocation: Uri(
        path: RoutePaths.search,
        queryParameters: {'q': query},
      ).toString(),
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppShell(uri: state.uri, child: child),
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) =>
                  const Scaffold(body: Text('home page')),
            ),
            GoRoute(
              path: RoutePaths.search,
              name: RouteNames.search,
              builder: (context, state) => SearchResultsPage(
                query: state.uri.queryParameters['q'] ?? '',
              ),
            ),
          ],
        ),
      ],
    );

    return ProviderScope(
      overrides: [searchRepositoryProvider.overrideWithValue(repository)],
      child: localizedApp(
        theme: AppTheme.light.copyWith(splashFactory: NoSplash.splashFactory),
        router: router,
      ),
    );
  }

  testWidgets('renders mock search results for a matching query', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    expect(find.text('이어폰'), findsWidgets);
    expect(find.text('AeroFit ANC 무선 블루투스 이어폰'), findsOneWidget);
    expect(find.text('추천순'), findsOneWidget);
    expect(find.textContaining('RTI 80+'), findsOneWidget);
  });

  testWidgets('renders empty state when mock search has no match', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('없는상품'));
    await tester.pumpAndSettle();

    expect(find.text('검색 결과가 없어요'), findsOneWidget);
    expect(find.text('다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.'), findsOneWidget);
  });

  testWidgets('updates route when searching again from results page', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '가전');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.search);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['q'],
      '가전',
    );
    expect(find.text('가전'), findsWidgets);
  });

  testWidgets('submitting the same query resets filters and fetches again', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();
    final filter = find.textContaining('RTI 80+');
    await tester.ensureVisible(filter);
    await tester.tap(filter);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<SearchResultsBody>(find.byType(SearchResultsBody))
          .selectedQuickFilter,
      'RTI 80+',
    );
    final requests = repository.requests;
    await tester.enterText(find.byType(TextField).first, '이어폰');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(repository.requests, requests + 1);
    expect(
      tester
          .widget<SearchResultsBody>(find.byType(SearchResultsBody))
          .selectedQuickFilter,
      '전체',
    );
  });

  testWidgets('changes visible page size from the result toolbar dropdown', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('30개씩 보기'),
      800,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('30개씩 보기'), findsOneWidget);

    await tester.tap(find.text('30개씩 보기'));
    await tester.pumpAndSettle();

    expect(find.text('60개씩 보기'), findsOneWidget);

    await tester.tap(find.text('60개씩 보기').last);
    await tester.pumpAndSettle();

    expect(find.text('60개씩 보기'), findsOneWidget);
  });

  testWidgets('renders price histogram bars behind the price range control', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject('이어폰'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('price-histogram-bars')), findsOneWidget);
  });
}

class _FakeSearchRepository implements SearchRepository {
  int requests = 0;
  @override
  Future<Result<SearchResponse>> searchProducts(SearchParams params) async {
    requests++;
    final query = params.query.trim();
    final products = switch (query) {
      '이어폰' => _products('AeroFit ANC 무선 블루투스 이어폰'),
      '가전' => _products('프리미엄 가전 상품'),
      _ => const <SearchResultProduct>[],
    };
    return Success(
      SearchResponse(products: products, totalCount: products.length),
    );
  }
}

List<SearchResultProduct> _products(String firstName) {
  return List.generate(36, (index) {
    return SearchResultProduct(
      id: index + 1,
      name: index == 0 ? firstName : '$firstName ${index + 1}',
      imageUrl: 'https://example.com/product-${index + 1}.png',
      price: 10000 + index * 1000,
      category: 'ELECTRONICS',
      categoryDisplayName: '이어폰',
      avgRti: index == 0 ? 83 : 72,
      rtiGrade: 'A',
      rtiColor: '#16A34A',
      reviewCount: 50 + index,
      avgRating: 4.5,
      platform: 'NAVER',
    );
  });
}

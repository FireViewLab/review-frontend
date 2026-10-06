import 'package:re_view_front/app/router/app_shell.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/shared/widgets/product_card_skeleton.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late GoRouter router;

  Widget buildSubject({
    Result<DashboardSummary> result = const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    ),
    bool pending = false,
  }) {
    router = GoRouter(
      initialLocation: RoutePaths.home,
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppShell(uri: state.uri, child: child),
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: RoutePaths.login,
              builder: (context, state) =>
                  const Scaffold(body: Text('login page')),
            ),
            GoRoute(
              path: RoutePaths.signup,
              builder: (context, state) =>
                  const Scaffold(body: Text('signup page')),
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
    addTearDown(router.dispose);

    return ProviderScope(
      overrides: [
        searchRepositoryProvider.overrideWithValue(_SearchRepositoryFake()),
        getHomeDashboardUseCaseProvider.overrideWithValue(
          GetHomeDashboardUseCase(_HomeRepositoryFake(result, pending)),
        ),
      ],
      child: localizedApp(router: router),
    );
  }

  testWidgets('renders home hero and RTI sections', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(HomeLogo), findsOneWidget);
    expect(find.byType(HeroBannerCarousel), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.text('Re:view가 더 믿을 수 있는 이유'), findsOneWidget);
    expect(find.text('추천 상품 API 연결 대기 중'), findsOneWidget);
    expect(find.text('지금 많이 찾는 키워드'), findsOneWidget);
    expect(find.text('표시할 키워드가 없습니다.'), findsOneWidget);
    expect(find.text('92% 신뢰도'), findsNothing);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('renders loading state before dashboard resolves', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(pending: true));

    expect(find.byType(ProductCardGridSkeleton), findsNWidgets(2));
  });

  testWidgets('renders retry UI when dashboard load fails', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        result: const FailureResult<DashboardSummary>(
          Failure(message: 'network failed'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('network failed'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });

  testWidgets('moves to login from benefit CTA', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
    await tester.pumpAndSettle();

    final benefitCta = find.text('혜택 받기').first;
    await tester.ensureVisible(benefitCta);
    await tester.pumpAndSettle();
    await tester.tap(benefitCta);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('login page'), findsOneWidget);
  });

  testWidgets('moves to login from header CTA', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('로그인'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('login page'), findsOneWidget);
  });

  testWidgets('moves to search results from header search', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '크림');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.search);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['q'],
      '크림',
    );
    expect(find.text('크림'), findsWidgets);
    expect(find.byType(SearchResultsPage), findsOneWidget);
    expect(find.text('검색 결과가 없어요'), findsOneWidget);
  });

  testWidgets('shows RTI search panel with two dashboard products on focus', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildSubject(
        result: const Success(
          DashboardSummary(
            recommendedProducts: [
              DashboardProduct(
                id: '1',
                name: '애플 에어팟 프로 2세대',
                storeName: '애플',
                price: 279000,
                imageUrl: '',
                rating: 4.7,
                reviewCount: 3842,
                rtiScore: 92,
              ),
              DashboardProduct(
                id: '2',
                name: '다이슨 V15 디텍트 컴플리트',
                storeName: '다이슨',
                price: 830000,
                imageUrl: '',
                rating: 4.6,
                reviewCount: 1256,
                rtiScore: 88,
              ),
              DashboardProduct(
                id: '3',
                name: '추가 상품',
                storeName: '스토어',
                price: 12000,
                imageUrl: '',
                rtiScore: 82,
              ),
            ],
            trendingKeywords: [],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();

    final firstSuggestion = find.byKey(
      const ValueKey('search-suggestion-product-0'),
    );
    final secondSuggestion = find.byKey(
      const ValueKey('search-suggestion-product-1'),
    );

    expect(find.text('인기 검색'), findsWidgets);
    expect(find.text('추천 상품'), findsOneWidget);
    expect(firstSuggestion, findsOneWidget);
    expect(secondSuggestion, findsOneWidget);
    expect(
      find.descendant(
        of: firstSuggestion,
        matching: find.text('애플 에어팟 프로 2세대'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: secondSuggestion,
        matching: find.text('다이슨 V15 디텍트 컴플리트'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstSuggestion, matching: find.text('RTI 92')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: secondSuggestion, matching: find.text('RTI 88')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('search-suggestion-product-2')),
      findsNothing,
    );
  });

  testWidgets('renders on mobile width without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(HeroBannerCarousel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake(this.result, this.pending);

  final Result<DashboardSummary> result;
  final bool pending;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    if (pending) {
      return Completer<Result<DashboardSummary>>().future;
    }

    return result;
  }
}

class _SearchRepositoryFake implements SearchRepository {
  @override
  Future<Result<SearchResponse>> searchProducts(SearchParams params) async {
    return const Success(SearchResponse(products: [], totalCount: 0));
  }
}

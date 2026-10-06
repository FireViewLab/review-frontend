import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/app_shell.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_navigation.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_shell.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/features/product_detail/presentation/pages/analysis_report_page.dart';
import 'package:re_view_front/features/external_product/presentation/pages/external_product_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Freesentation');
    for (final name in [
      '4Regular',
      '5Medium',
      '6SemiBold',
      '7Bold',
      '8ExtraBold',
      '9Black',
    ]) {
      loader.addFont(rootBundle.load('assets/fonts/Freesentation-$name.ttf'));
    }
    await loader.load();
  });

  Future<(ProviderContainer, GoRouter)> mount(
    WidgetTester tester, {
    Size size = const Size(1280, 900),
    bool loggedIn = true,
    String location = RoutePaths.home,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWith((ref) {
          final client = ApiClient(ref.read(appConfigProvider));
          client.dio.interceptors.clear();
          client.dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) => handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'data': {
                      'id': 1,
                      'email': 'user@example.com',
                      'nickname': '사용자',
                      'role': 'USER',
                      'onboardingCompleted': true,
                      'items': <dynamic>[],
                      'content': <dynamic>[],
                      'recommendedProducts': <dynamic>[],
                      'trendingKeywords': <dynamic>[],
                    },
                  },
                ),
              ),
            ),
          );
          ref.onDispose(() => client.dio.close(force: true));
          return client;
        }),
      ],
    );
    addTearDown(container.dispose);
    container.read(authTokenStoreProvider.notifier).clear();
    addTearDown(() => container.read(authTokenStoreProvider.notifier).clear());
    if (loggedIn) {
      container
          .read(authTokenStoreProvider.notifier)
          .save(
            accessToken: 'test-token',
            tokenType: 'Bearer',
            onboardingCompleted: true,
            nickname: '사용자',
          );
    }
    final router = container.read(appRouterProvider);
    router.go(location);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(router: router),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    return (container, router);
  }

  Future<void> navigate(
    WidgetTester tester,
    GoRouter router,
    String path,
  ) async {
    router.go(path);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeHeader), findsOneWidget);
  }

  testWidgets(
    'real router preserves header across shopping and account routes',
    (tester) async {
      final (_, router) = await mount(tester);
      expect(tester.takeException(), isNull);
      final header = tester.element(find.byType(HomeHeader));
      final search = tester.state(find.byType(home.SearchBar));
      for (final path in [
        '/search?q=이어폰',
        '/product/1',
        '/product/1/analysis',
        '/product/coupang/123',
        RoutePaths.wishlist,
        RoutePaths.cart,
        RoutePaths.notifications,
        RoutePaths.myPage,
        RoutePaths.plan,
        RoutePaths.feedbackHistory,
        RoutePaths.settings,
        RoutePaths.home,
      ]) {
        await navigate(tester, router, path);
        expect(tester.element(find.byType(HomeHeader)), same(header));
        expect(tester.state(find.byType(home.SearchBar)), same(search));
        if (path == '/product/1/analysis') {
          expect(find.byType(AnalysisReportPage), findsOneWidget);
          expect(find.byType(ExternalProductPage), findsNothing);
        }
        if (path == '/product/coupang/123') {
          expect(find.byType(ExternalProductPage), findsOneWidget);
        }
      }
    },
  );

  testWidgets('nested routes keep header and account menus accessible', (
    tester,
  ) async {
      final handle = tester.ensureSemantics();
      try {
        await mount(tester, location: RoutePaths.settings);
        expect(find.bySemanticsLabel('장바구니'), findsWidgets);
        expect(find.bySemanticsLabel('계정 설정'), findsWidgets);
      } finally {
        handle.dispose();
      }
  });

  testWidgets(
    'URL changes update search text while navigation preserves a draft',
    (tester) async {
      final (_, router) = await mount(tester, location: '/search?q=이어폰');
      final field = find.descendant(
        of: find.byType(home.SearchBar),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(field).controller!.text, '이어폰');
      await navigate(tester, router, '/search?q=가전');
      expect(tester.widget<TextField>(field).controller!.text, '가전');
      await navigate(tester, router, '/search?categoryId=beauty&category=뷰티');
      expect(tester.widget<TextField>(field).controller!.text, '뷰티');
      await tester.enterText(field, '입력 중인 검색어');
      await navigate(tester, router, RoutePaths.cart);
      expect(tester.widget<TextField>(field).controller!.text, '입력 중인 검색어');
    },
  );

  for (final width in [320.0, 800.0, 1280.0]) {
    testWidgets(
      'account Navigator is bounded and content scrolls at width $width',
      (tester) async {
        final (_, router) = await mount(
          tester,
          size: Size(width, 800),
          location: RoutePaths.settings,
        );
        expect(tester.takeException(), isNull);
        final shell = tester.element(find.byType(AccountShell));
        final header = tester.element(find.byType(HomeHeader));
        expect(
          find.byType(width >= 980 ? AccountSideNav : AccountTabBar),
          findsOneWidget,
        );
        final scroll = find.descendant(
          of: find.byType(AccountContent),
          matching: find.byType(SingleChildScrollView),
        );
        await tester.drag(scroll, const Offset(0, -400));
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        await navigate(tester, router, RoutePaths.plan);
        expect(tester.element(find.byType(AccountShell)), same(shell));
        expect(tester.element(find.byType(HomeHeader)), same(header));
      },
    );
  }

  testWidgets(
    'protected route returns through login and logout exits the shell',
    (tester) async {
      final (container, router) = await mount(
        tester,
        loggedIn: false,
        location: RoutePaths.cart,
      );
      expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
      expect(
        router.routeInformationProvider.value.uri.queryParameters['from'],
        RoutePaths.cart,
      );
      container
          .read(authTokenStoreProvider.notifier)
          .save(
            accessToken: 'test-token',
            tokenType: 'Bearer',
            onboardingCompleted: true,
          );
      await navigate(tester, router, RoutePaths.cart);
      container.read(authTokenStoreProvider.notifier).clear();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
      await navigate(tester, router, RoutePaths.home);
      router.go(RoutePaths.landing);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AppShell), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_navigation.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../helpers/pump_app.dart';

/// 공통 틀의 메뉴와 내용 교체만 본다. 헤더는 다른 테스트가 다룬다.
class _Frame extends StatelessWidget {
  const _Frame({required this.location, required this.child, this.wide = true});

  final String location;
  final Widget child;
  final bool wide;

  static int builds = 0;

  @override
  Widget build(BuildContext context) {
    builds++;
    return Scaffold(
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 260,
                  child: AccountSideNav(
                    location: location,
                    profile: const UserProfile(
                      id: 1,
                      email: 'user@example.com',
                      nickname: '사용자',
                      role: 'USER',
                      createdAt: null,
                      onboardingCompleted: true,
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            )
          : Column(
              children: [
                AccountTabBar(location: location),
                Expanded(child: child),
              ],
            ),
    );
  }
}

void main() {
  Future<GoRouter> pumpShell(
    WidgetTester tester, {
    Size size = const Size(1280, 900),
    bool wide = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = GoRouter(
      initialLocation: RoutePaths.myPage,
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              _Frame(location: state.uri.path, wide: wide, child: child),
          routes: [
            for (final path in [
              RoutePaths.myPage,
              RoutePaths.plan,
              RoutePaths.feedbackHistory,
              RoutePaths.settings,
            ])
              GoRoute(
                path: path,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: Text('content $path')),
              ),
          ],
        ),
        GoRoute(
          path: RoutePaths.wishlist,
          builder: (context, state) => const Scaffold(body: Text('wishlist')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await pumpApp(tester, ProviderScope(child: localizedApp(router: router)));
    await tester.pumpAndSettle();
    return router;
  }

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(_Frame)));

  testWidgets('switching menus replaces only the content', (tester) async {
    final router = await pumpShell(tester);
    final l10n = l10nOf(tester);
    final frame = tester.element(find.byType(_Frame));
    expect(find.text('content ${RoutePaths.myPage}'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);

    await tester.tap(find.text(l10n.sideNavAccountSettings));
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      RoutePaths.settings,
    );
    expect(find.text('content ${RoutePaths.settings}'), findsOneWidget);
    expect(find.text('content ${RoutePaths.myPage}'), findsNothing);
    // 틀은 새로 만들어지지 않고 같은 것이 그대로 남는다.
    expect(tester.element(find.byType(_Frame)), same(frame));
    expect(find.text('user@example.com'), findsOneWidget);
  });

  testWidgets('marks the current menu and reaches every section', (
    tester,
  ) async {
    final router = await pumpShell(tester);
    final l10n = l10nOf(tester);
    for (final (label, path) in [
      (l10n.myPageSideNavPlan, RoutePaths.plan),
      (l10n.sideNavFeedbackHistory, RoutePaths.feedbackHistory),
      (l10n.sideNavAccountSettings, RoutePaths.settings),
      (l10n.myPageSideNavMyPage, RoutePaths.myPage),
    ]) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.uri.path, path);
      expect(find.text('content $path'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text(label),
          matching: find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.selected == true,
          ),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('wishlist leaves the account area', (tester) async {
    final router = await pumpShell(tester);
    await tester.tap(find.text(l10nOf(tester).myPageSideNavWishlist));
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      RoutePaths.wishlist,
    );
    expect(find.byType(_Frame), findsNothing);
  });

  testWidgets('shows horizontal tabs on a narrow screen', (tester) async {
    final router = await pumpShell(
      tester,
      size: const Size(360, 800),
      wide: false,
    );
    final l10n = l10nOf(tester);
    expect(find.byType(AccountSideNav), findsNothing);

    await tester.tap(find.text(l10n.myPageSideNavPlan));
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      RoutePaths.plan,
    );
    expect(tester.takeException(), isNull);
  });
}

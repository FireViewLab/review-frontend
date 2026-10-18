import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  Future<GoRouter> pumpHeaderButton(
    WidgetTester tester, {
    required bool admin,
  }) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: Align(
              alignment: Alignment.topRight,
              child: HeaderUserProfileButton(nickname: '관리자'),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.admin,
          builder: (_, _) => const Scaffold(body: Text('admin page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [isAdminProvider.overrideWithValue(admin)],
        child: localizedApp(router: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(HeaderUserProfileButton));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('admins can open the admin screen from the profile menu', (
    tester,
  ) async {
    await pumpHeaderButton(tester, admin: true);

    final adminItem = find.text('관리자').last;
    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    await tester.tap(adminItem);
    await tester.pumpAndSettle();

    expect(find.text('admin page'), findsOneWidget);
  });

  testWidgets('regular users do not see the admin item', (tester) async {
    await pumpHeaderButton(tester, admin: false);

    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsNothing);
  });
}

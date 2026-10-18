import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/app_shell.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';
import 'package:re_view_front/features/auth/domain/usecases/login_use_case.dart';
import 'package:re_view_front/features/auth/presentation/pages/login_page.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_value_panel.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';

import '../../../../helpers/pump_app.dart';

class _UnusedAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Layout verification must not authenticate');
}

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

  Future<void> pumpLogin(
    WidgetTester tester,
    Size size, {
    double scale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final router = GoRouter(
      initialLocation: RoutePaths.login,
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppShell(uri: state.uri, child: child),
          routes: [
            GoRoute(
              path: RoutePaths.login,
              builder: (_, _) => const LoginPage(),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginUseCaseProvider.overrideWithValue(
            LoginUseCase(_UnusedAuthRepository()),
          ),
          featuredProductProvider.overrideWithValue(const AsyncData(null)),
        ],
        child: localizedApp(router: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder getInput(String hint) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.hintText == hint,
  );

  testWidgets(
    'mobile prioritizes form and reaches both social buttons by scrolling',
    (tester) async {
      await pumpLogin(tester, const Size(390, 850));
      expect(
        tester.widget<LoginValuePanel>(find.byType(LoginValuePanel)).compact,
        isTrue,
      );
      final email = getInput('이메일을 입력하세요');
      final password = getInput('비밀번호를 입력하세요');
      expect(tester.getBottomRight(password).dy, lessThan(650));
      await tester.tap(email);
      await tester.enterText(email, 'invalid');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(password).textInputAction,
        TextInputAction.done,
      );
      for (final label in ['네이버 계정으로 계속하기', 'Google 계정으로 계속하기']) {
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(label).hitTestable(), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'narrow enlarged text keeps focused password reachable above keyboard and validation visible',
    (tester) async {
      await pumpLogin(tester, const Size(320, 700), scale: 1.5);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      final password = getInput('비밀번호를 입력하세요');
      await tester.ensureVisible(password);
      await tester.tap(password);
      await tester.pumpAndSettle();
      await tester.ensureVisible(password);
      await tester.pumpAndSettle();
      expect(tester.getBottomRight(password).dy, lessThanOrEqualTo(400));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('이메일을 입력해주세요.'), findsOneWidget);
      expect(find.text('비밀번호를 입력해주세요.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('desktop retains full introduction beside the form', (
    tester,
  ) async {
    await pumpLogin(tester, const Size(1280, 900));
    expect(
      tester.widget<LoginValuePanel>(find.byType(LoginValuePanel)).compact,
      isFalse,
    );
    expect(
      tester.getTopLeft(find.byType(LoginCard)).dx,
      greaterThan(tester.getTopLeft(find.byType(LoginValuePanel)).dx),
    );
    expect(tester.takeException(), isNull);
  });
}

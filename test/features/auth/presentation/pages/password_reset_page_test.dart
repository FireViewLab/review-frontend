import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset_card.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import '../../../../helpers/pump_app.dart';

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

  for (final path in ['/reset-password', '/password-reset']) {
    testWidgets('$path accepts the email token without login redirect', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = ProviderContainer(
        overrides: [
          isLoggedInProvider.overrideWithValue(false),
          apiClientProvider.overrideWith(
            (ref) => throw StateError('Unexpected API access'),
          ),
        ],
      );
      addTearDown(container.dispose);
      final router = container.read(appRouterProvider);
      router.go('$path?token=email%2Btoken');
      await pumpApp(
        tester,
        UncontrolledProviderScope(
          container: container,
          child: localizedApp(router: router),
        ),
      );
      await tester.pumpAndSettle();
      final state = tester
          .widget<PasswordResetCard>(find.byType(PasswordResetCard))
          .state;
      expect(state.step, PasswordResetStep.newPassword);
      expect(state.resetToken, 'email+token');
      expect(router.routeInformationProvider.value.uri.path, path);
      expect(find.text('새 비밀번호'), findsWidgets);
      expect(tester.takeException(), isNull);
      tester
              .widget<PasswordResetCard>(find.byType(PasswordResetCard))
              .newPasswordController
              .text =
          'Password123!';
      router.go('$path?token=second-token');
      await tester.pumpAndSettle();
      final updated = tester.widget<PasswordResetCard>(
        find.byType(PasswordResetCard),
      );
      expect(updated.state.resetToken, 'second-token');
      expect(updated.newPasswordController.text, isEmpty);
      expect(updated.state.newPassword, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('old route without token retains the email entry step', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        isLoggedInProvider.overrideWithValue(false),
        apiClientProvider.overrideWith(
          (ref) => throw StateError('Unexpected API access'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider)..go('/password-reset');
    await pumpApp(
      tester,
      UncontrolledProviderScope(
        container: container,
        child: localizedApp(router: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<PasswordResetCard>(find.byType(PasswordResetCard))
          .state
          .step,
      PasswordResetStep.email,
    );
    expect(tester.takeException(), isNull);
  });
}

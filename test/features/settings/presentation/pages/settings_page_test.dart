import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_view_model.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_view_model.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/domain/repositories/settings_repository.dart';
import 'package:re_view_front/features/settings/presentation/pages/settings_page.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late _FakeSettingsRepository repository;

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

  setUp(() => repository = _FakeSettingsRepository());

  Widget subject({bool loggedIn = true}) {
    final router = GoRouter(
      initialLocation: RoutePaths.settings,
      routes: [
        GoRoute(
          path: RoutePaths.settings,
          // 실제 앱에서는 계정 영역의 공통 틀이 감싼다.
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(child: SettingsPage()),
          ),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (_, _) => const Scaffold(body: Text('login page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    return ProviderScope(
      overrides: [
        isLoggedInProvider.overrideWithValue(loggedIn),
        apiClientProvider.overrideWith(
          (ref) => throw StateError('Unexpected API access'),
        ),
        settingsRepositoryProvider.overrideWithValue(repository),
        homeDashboardViewModelProvider.overrideWith(_HomeViewModel.new),
        myPageViewModelProvider.overrideWith(_ProfileViewModel.new),
        userNicknameProvider.overrideWith((ref) async => '사용자'),
        cartItemCountProvider.overrideWith((ref) async => 0),
        wishlistItemCountProvider.overrideWith((ref) async => 0),
      ],
      child: localizedApp(router: router),
    );
  }

  testWidgets('shows loading then server settings without unsupported fields', (
    tester,
  ) async {
    final pending = Completer<Result<SettingsData>>();
    repository.onGet = () => pending.future;
    await pumpApp(tester, subject());
    expect(find.text('설정을 불러오는 중입니다.'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    pending.complete(const Success(SettingsData(rtiThreshold: 73)));
    await tester.pumpAndSettle();
    expect(find.byType(Switch), findsNWidgets(9));
    expect(tester.widget<Slider>(find.byType(Slider)).value, 73);
    expect(find.text('리뷰 표시'), findsOneWidget);
    expect(find.text('개인정보'), findsOneWidget);
    expect(find.text('이메일 알림'), findsNothing);
    expect(find.text('최소 리뷰 수'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shows the sign-in method and hides password change for social accounts',
    (tester) async {
      repository.loginMethod = 'GOOGLE';
      await pumpApp(tester, subject());
      await tester.pumpAndSettle();

      expect(find.text('로그인 방식'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('비밀번호 변경'), findsNothing);
    },
  );

  testWidgets('keeps password change for email accounts', (tester) async {
    await pumpApp(tester, subject());
    await tester.pumpAndSettle();

    expect(find.text('이메일'), findsWidgets);
    expect(find.text('비밀번호 변경'), findsOneWidget);
  });

  testWidgets('shows load failure and retries', (tester) async {
    repository.getResult = const FailureResult(Failure(message: '조회 오류'));
    await pumpApp(tester, subject());
    expect(find.text('설정을 불러오지 못했습니다.'), findsOneWidget);
    expect(find.text('조회 오류'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    repository.getResult = const Success(SettingsData());
    await tester.ensureVisible(find.text('다시 시도'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.byType(Switch), findsNWidgets(9));
  });

  testWidgets('shows save failure, retains draft, and retries successfully', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpApp(tester, subject());
    await tester.ensureVisible(find.byType(Switch).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    repository.updateResult = const FailureResult(Failure(message: '저장 오류'));
    await tester.ensureVisible(find.text('저장'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    expect(repository.saved!.notifyRiskyProduct, isFalse);
    expect(find.text('설정을 저장하지 못했습니다.'), findsOneWidget);
    expect(find.text('저장 오류'), findsOneWidget);
    repository.updateResult = null;
    await tester.ensureVisible(find.text('다시 시도'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.text('저장됐어요'), findsOneWidget);
    expect(repository.saved!.notifyRiskyProduct, isFalse);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 800.0, 1280.0]) {
    testWidgets('settings layout fits width $width', (tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpApp(tester, subject());
      await tester.ensureVisible(find.text('상품 카드 밀도'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('logged out entry offers login and makes no settings request', (
    tester,
  ) async {
    await pumpApp(tester, subject(loggedIn: false));
    expect(find.text('로그인'), findsOneWidget);
    expect(repository.getCalls, 0);
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();
    expect(find.text('login page'), findsOneWidget);
    expect(repository.getCalls, 0);
  });
}

class _HomeViewModel extends HomeDashboardViewModel {
  @override
  HomeDashboardState build() => const HomeDashboardEmpty();
}

class _ProfileViewModel extends MyPageViewModel {
  @override
  MyPageState build() => const MyPageLoading();
  @override
  Future<void> load() async {}
}

class _FakeSettingsRepository implements SettingsRepository {
  int getCalls = 0;
  SettingsData? saved;
  Result<SettingsData> getResult = const Success(SettingsData(theme: 'DARK'));
  Result<SettingsData>? updateResult;
  Future<Result<SettingsData>> Function()? onGet;

  @override
  Future<Result<SettingsData>> getSettings() async {
    ++getCalls;
    return onGet == null ? getResult : await onGet!();
  }

  @override
  Future<Result<SettingsData>> updateSettings(SettingsData settings) async {
    saved = settings;
    return updateResult ?? Success(settings);
  }

  String loginMethod = 'LOCAL';

  @override
  Future<Result<String>> getLoginMethod() async => Success(loginMethod);
}

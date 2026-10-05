import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/plan/domain/entities/plan_option.dart';
import 'package:re_view_front/features/plan/presentation/pages/plan_page.dart';
import 'package:re_view_front/features/plan/presentation/providers/plan_providers.dart';
import 'package:re_view_front/features/plan/presentation/widgets/plan_cards.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../../helpers/pump_app.dart';
import 'plan_test_fakes.dart';

void main() {
  Future<({FakePlanRepository plans, FakeQuotaRepository chat})> pumpPlan(
    WidgetTester tester, {
    Size size = const Size(1280, 1000),
    FakePlanRepository? plans,
    FakeQuotaRepository? chat,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final planRepository = plans ?? FakePlanRepository();
    final chatRepository = chat ?? FakeQuotaRepository();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          // 헤더는 따로 검증하므로 본문만 올린다.
          builder: (context, state) =>
              const Scaffold(body: SingleChildScrollView(child: PlanContent())),
        ),
      ],
    );
    addTearDown(router.dispose);
    await pumpApp(
      tester,
      ProviderScope(
        overrides: [
          planRepositoryProvider.overrideWithValue(planRepository),
          chatRepositoryProvider.overrideWithValue(chatRepository),
          isLoggedInProvider.overrideWithValue(true),
          userNicknameProvider.overrideWith((ref) async => '테스터'),
        ],
        child: localizedApp(router: router),
      ),
    );
    await tester.pumpAndSettle();
    return (plans: planRepository, chat: chatRepository);
  }

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(PlanContent)));

  testWidgets('shows the current plan, today\'s usage and three plans', (
    tester,
  ) async {
    await pumpPlan(tester);
    final l10n = l10nOf(tester);

    expect(find.text(l10n.planUsageToday(2, 5)), findsOneWidget);
    expect(find.byType(PlanOptionCard), findsNWidgets(3));
    // 현재 요금제는 바꿀 수 없고 나머지 둘만 고를 수 있다.
    expect(find.text(l10n.planSelect), findsNWidgets(2));
    // 한도를 받은 현재 요금제에만 숫자가 나온다.
    expect(find.text(l10n.planDailyQuestions(5)), findsOneWidget);
    expect(find.text(l10n.planFeaturePro), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows server limits for every plan when they are provided', (
    tester,
  ) async {
    await pumpPlan(
      tester,
      plans: FakePlanRepository()
        ..plans = const Success([
          PlanOption(code: 'FREE', dailyLimit: 5, proAvailable: false),
          PlanOption(code: 'PLUS', dailyLimit: 100, proAvailable: false),
          PlanOption(code: 'PRO', dailyLimit: 300, proAvailable: true),
        ]),
    );
    final l10n = l10nOf(tester);
    expect(find.text(l10n.planDailyQuestions(100)), findsOneWidget);
    expect(find.text(l10n.planDailyQuestions(300)), findsOneWidget);
  });

  testWidgets('changes the plan after confirming', (tester) async {
    final subject = await pumpPlan(tester);
    final l10n = l10nOf(tester);
    subject.plans.onChange = (code) => subject.chat.quota = Success(
      quotaOf(plan: code, limit: 300, pro: true),
    );

    await tester.tap(find.text(l10n.planSelect).last);
    await tester.pumpAndSettle();
    expect(find.text(l10n.planConfirmTitle(l10n.chatPlanPro)), findsOneWidget);
    expect(subject.plans.changes, isEmpty);

    await tester.tap(find.text(l10n.planConfirmAction));
    await tester.pumpAndSettle();
    expect(subject.plans.changes, ['PRO']);
    expect(find.text(l10n.planChanged(l10n.chatPlanPro)), findsOneWidget);
    expect(find.text(l10n.planUsageToday(2, 300)), findsOneWidget);
  });

  testWidgets('cancelling keeps the plan', (tester) async {
    final subject = await pumpPlan(tester);
    final l10n = l10nOf(tester);
    await tester.tap(find.text(l10n.planSelect).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.planCancel));
    await tester.pumpAndSettle();
    expect(subject.plans.changes, isEmpty);
  });

  testWidgets('says changing is not ready when the server lacks it', (
    tester,
  ) async {
    final subject = await pumpPlan(tester);
    final l10n = l10nOf(tester);
    subject.plans.change = const FailureResult(
      Failure(message: 'Not Found', statusCode: 404),
    );
    await tester.tap(find.text(l10n.planSelect).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.planConfirmAction));
    await tester.pumpAndSettle();
    expect(find.text(l10n.planChangeUnavailable), findsOneWidget);
    expect(find.text(l10n.planUsageToday(2, 5)), findsOneWidget);
  });

  testWidgets('offers a retry when the plan cannot be loaded', (tester) async {
    final chat = FakeQuotaRepository()
      ..quota = const FailureResult(Failure(message: '오류'));
    await pumpPlan(tester, chat: chat);
    final l10n = l10nOf(tester);
    expect(find.text(l10n.planLoadFailed), findsOneWidget);
    expect(find.byType(PlanOptionCard), findsNothing);
  });

  for (final width in [320.0, 800.0, 1400.0]) {
    testWidgets('fits a ${width.toInt()}px screen', (tester) async {
      await pumpPlan(tester, size: Size(width, 900));
      expect(find.byType(PlanOptionCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }
}

import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/plan/presentation/providers/plan_providers.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_state.dart';

import 'plan_test_fakes.dart';

void main() {
  late FakePlanRepository plans;
  late FakeQuotaRepository chat;
  late ProviderContainer container;

  setUp(() {
    plans = FakePlanRepository();
    chat = FakeQuotaRepository();
    container = ProviderContainer(
      overrides: [
        planRepositoryProvider.overrideWithValue(plans),
        chatRepositoryProvider.overrideWithValue(chat),
        isLoggedInProvider.overrideWithValue(true),
      ],
    );
    container.listen(planViewModelProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  Future<void> settle() async {
    await Future<void>.delayed(Duration.zero);
    await container.pump();
  }

  test('shows the current plan and the three plans', () async {
    await settle();
    final state = container.read(planViewModelProvider);
    expect(state.status, PlanStatus.ready);
    expect(state.quota?.planCode, 'FREE');
    expect(state.options.map((o) => o.code), ['FREE', 'PLUS', 'PRO']);
  });

  test('uses the expiry the server provides', () async {
    plans.expiry = Success(DateTime.utc(2026, 11, 1));
    await container.read(planViewModelProvider.notifier).load();
    final state = container.read(planViewModelProvider);
    expect(state.expiresAt, DateTime.utc(2026, 11, 1));
  });

  test('fails when the current plan cannot be loaded', () async {
    chat.quota = const FailureResult(Failure(message: '오류'));
    await container.read(planViewModelProvider.notifier).load();
    expect(container.read(planViewModelProvider).status, PlanStatus.failure);
  });

  test('changes the plan, reloads it and tells the assistant', () async {
    await settle();
    plans.onChange = (code) => chat.quota = Success(quotaOf(plan: code));
    final before = chat.quotaRequests;
    await container.read(planViewModelProvider.notifier).change('PRO');
    await settle();

    final state = container.read(planViewModelProvider);
    expect(plans.changes, ['PRO']);
    expect(state.quota?.planCode, 'PRO');
    expect(state.notice, PlanNotice.changed);
    expect(state.isChanging, isFalse);
    // One confirmed server quota updates both screens.
    expect(chat.quotaRequests, before + 1);
  });

  test('does not announce success when refreshed quota disagrees', () async {
    await settle();
    await container.read(planViewModelProvider.notifier).change('PLUS');
    final state = container.read(planViewModelProvider);
    expect(state.notice, PlanNotice.refreshFailed);
    expect(state.status, PlanStatus.failure);
    expect(state.isChanging, isFalse);
    expect(container.read(chatViewModelProvider).quota, isNull);
  });

  test('does not announce success when quota refresh fails', () async {
    await settle();
    plans.onChange = (_) =>
        chat.quota = const FailureResult(Failure(message: 'quota unavailable'));
    await container.read(planViewModelProvider.notifier).change('PLUS');
    expect(
      container.read(planViewModelProvider).notice,
      PlanNotice.refreshFailed,
    );
    expect(container.read(chatViewModelProvider).quota, isNull);
  });

  test('requires current-user response as well as quota', () async {
    await settle();
    plans.expiry = const FailureResult(Failure(message: 'profile unavailable'));
    await container.read(planViewModelProvider.notifier).load();
    expect(container.read(planViewModelProvider).status, PlanStatus.failure);
  });

  test(
    'updates an open chat and removes pro permission on downgrade',
    () async {
      await settle();
      final vm = container.read(planViewModelProvider.notifier);
      plans.onChange = (code) => chat.quota = Success(
        quotaOf(plan: code, limit: code == 'PRO' ? 80 : 5, pro: code == 'PRO'),
      );
      await vm.change('PRO');
      final chatVm = container.read(chatViewModelProvider.notifier);
      chatVm.open();
      await settle();
      chatVm.setMode(ChatMode.pro);
      expect(container.read(chatViewModelProvider).canUsePro, isTrue);
      await vm.change('FREE');
      expect(container.read(chatViewModelProvider).isOpen, isTrue);
      expect(container.read(chatViewModelProvider).quota?.planCode, 'FREE');
      expect(container.read(chatViewModelProvider).canUsePro, isFalse);
      expect(container.read(chatViewModelProvider).mode, ChatMode.standard);
    },
  );

  test(
    'reports that changing is not available when the server lacks it',
    () async {
      await settle();
      plans.change = const FailureResult(
        Failure(message: 'Not Found', statusCode: 404),
      );
      await container.read(planViewModelProvider.notifier).change('PLUS');
      final state = container.read(planViewModelProvider);
      expect(state.notice, PlanNotice.unavailable);
      expect(state.quota?.planCode, 'FREE');
      expect(state.isChanging, isFalse);
    },
  );

  test('reports other failures as failures', () async {
    await settle();
    plans.change = const FailureResult(
      Failure(message: '서버 오류', statusCode: 500),
    );
    await container.read(planViewModelProvider.notifier).change('PLUS');
    expect(container.read(planViewModelProvider).notice, PlanNotice.failed);
  });

  test(
    'ignores the current plan and a second change while one is running',
    () async {
      await settle();
      final vm = container.read(planViewModelProvider.notifier);
      await vm.change('FREE');
      expect(plans.changes, isEmpty);

      plans.pendingChange = Completer();
      final first = vm.change('PLUS');
      await vm.change('PRO');
      expect(plans.changes, ['PLUS']);
      plans.pendingChange!.complete(const Success(null));
      await first;
    },
  );
}

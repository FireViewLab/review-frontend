import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/plan/presentation/providers/plan_providers.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_state.dart';

class PlanViewModel extends Notifier<PlanState> {
  /// 다시 불러올 때마다 올린다. 늦게 온 이전 응답이 새 값을 덮지 않게 한다.
  int _request = 0;
  int _changeRequest = 0;

  @override
  PlanState build() {
    Future.microtask(load);
    return const PlanState();
  }

  Future<void> load() async {
    final request = ++_request;
    if (state.quota == null) {
      state = state.copyWith(status: PlanStatus.loading);
    }
    final planRepository = ref.read(planRepositoryProvider);
    final (quota, expiry) = await (
      ref.read(chatRepositoryProvider).getQuota(),
      planRepository.getMyPlan(),
    ).wait;
    if (!ref.mounted || request != _request) return;

    final account = expiry.when(success: (v) => v, failure: (_) => null);
    final currentQuota = quota.when(success: (v) => v, failure: (_) => null);
    if (account == null ||
        currentQuota == null ||
        account.code != currentQuota.planCode.toUpperCase()) {
      state = state.copyWith(status: PlanStatus.failure);
      ref.read(chatViewModelProvider.notifier).invalidateQuota();
      return;
    }
    ref.read(chatViewModelProvider.notifier).applyQuota(currentQuota);
    final expiresAt = account.expiresAt;
    quota.when(
      success: (value) => state = state.copyWith(
        status: PlanStatus.ready,
        quota: value,
        expiresAt: expiresAt,
        clearExpiresAt: expiresAt == null,
      ),
      // 현재 요금제를 모르면 무엇을 고를 수 있는지도 보여 줄 수 없다.
      failure: (_) => state = state.copyWith(status: PlanStatus.failure),
    );
  }

  Future<void> change(String code) async {
    if (state.isChanging || state.quota?.planCode.toUpperCase() == code) return;
    final changeRequest = ++_changeRequest;
    state = state.copyWith(changingCode: code, clearNotice: true);

    final result = await ref.read(planRepositoryProvider).changeMyPlan(code);
    if (!ref.mounted || changeRequest != _changeRequest) return;

    await result.when(
      success: (_) async {
        await load();
        if (!ref.mounted || changeRequest != _changeRequest) return;
        final confirmed =
            state.status == PlanStatus.ready &&
            state.quota?.planCode.toUpperCase() == code.toUpperCase();
        state = state.copyWith(
          clearChanging: true,
          notice: confirmed ? PlanNotice.changed : PlanNotice.refreshFailed,
          noticeCode: code,
        );
        // 열려 있는 어시스턴트의 남은 횟수와 모드도 새 요금제로 맞춘다.
        if (!confirmed) {
          ref.read(chatViewModelProvider.notifier).invalidateQuota();
        }
      },
      failure: (failure) async {
        // A response/connection failure can occur after the server applied a change.
        await load();
        if (!ref.mounted || changeRequest != _changeRequest) return;
        state = state.copyWith(
          clearChanging: true,
          notice: _isUnavailable(failure)
              ? PlanNotice.unavailable
              : PlanNotice.failed,
          noticeCode: code,
        );
      },
    );
  }

  void clearNotice() => state = state.copyWith(clearNotice: true);

  /// 서버에 아직 없는 기능인지. 경로나 메서드가 없으면 이 상태 코드가 온다.
  bool _isUnavailable(Failure failure) =>
      const {404, 405, 501}.contains(failure.statusCode);
}

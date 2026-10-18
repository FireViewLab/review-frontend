import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_dashboard_repository.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_user_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_dashboard_providers.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_user_providers.dart';

void main() {
  group('AdminUserViewModel', () {
    test('keeps the current page when another page fails to load', () async {
      final repository = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final sub = container.listen(adminUserViewModelProvider, (_, _) {});
      addTearDown(sub.close);
      await pumpEventQueue();

      expect(container.read(adminUserViewModelProvider).items.single.userId, 0);

      repository.failPages.add(1);
      container.read(adminUserViewModelProvider.notifier).changePage(1);
      await pumpEventQueue();

      final state = container.read(adminUserViewModelProvider);
      expect(state.page, 0);
      expect(state.items.single.userId, 0);
      expect(state.errorMessage, '불러오기 실패');
    });

    test('ignores an older page response that arrives late', () async {
      final repository = _FakeUserRepository();
      final container = ProviderContainer(
        overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final sub = container.listen(adminUserViewModelProvider, (_, _) {});
      addTearDown(sub.close);
      await pumpEventQueue();

      final slow = Completer<void>();
      repository.delays[1] = slow.future;
      final vm = container.read(adminUserViewModelProvider.notifier);
      vm.changePage(1);
      vm.changePage(2);
      await pumpEventQueue();
      slow.complete();
      await pumpEventQueue();

      final state = container.read(adminUserViewModelProvider);
      expect(state.page, 2);
      expect(state.items.single.userId, 2);
    });
  });

  group('AdminDashboardViewModel', () {
    test('ignores a summary response from an earlier refresh', () async {
      final repository = _FakeDashboardRepository();
      final container = ProviderContainer(
        overrides: [
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(adminDashboardViewModelProvider, (_, _) {});
      addTearDown(sub.close);
      await pumpEventQueue();

      final slow = Completer<Result<AdminDashboardSummary>>();
      repository.nextSummary = slow;
      final vm = container.read(adminDashboardViewModelProvider.notifier);
      final first = vm.refresh();
      repository.nextSummary = null;
      repository.totalUsers = 99;
      await vm.refresh();
      slow.complete(const FailureResult(Failure(message: '이전 요청 실패')));
      await first;

      final summary = container.read(adminDashboardViewModelProvider).summary;
      expect(summary.value?.totalUsers, 99);
    });
  });
}

class _FakeUserRepository implements AdminUserRepository {
  @override
  Future<Result<AdminUser>> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  }) => throw UnimplementedError();

  final Set<int> failPages = {};
  final Map<int, Future<void>> delays = {};

  @override
  Future<Result<AdminPage<AdminUser>>> getUsers({
    required int page,
    required int size,
  }) async {
    await delays[page];
    if (failPages.contains(page)) {
      return const FailureResult(Failure(message: '불러오기 실패'));
    }
    return Success(
      AdminPage(
        items: [
          AdminUser(
            userId: page,
            email: 'user$page@example.com',
            nickname: 'user$page',
            role: 'USER',
            provider: 'LOCAL',
            atiScore: null,
            createdAt: null,
          ),
        ],
        totalElements: 3,
        totalPages: 3,
        page: page,
      ),
    );
  }
}

class _FakeDashboardRepository implements AdminDashboardRepository {
  Completer<Result<AdminDashboardSummary>>? nextSummary;
  int totalUsers = 1;

  @override
  Future<Result<AdminDashboardSummary>> getSummary() {
    final pending = nextSummary;
    if (pending != null) return pending.future;
    return Future.value(
      Success(
        AdminDashboardSummary(
          totalReviews: 0,
          pendingReports: 0,
          pendingAnalysisFeedbacks: 0,
          totalUsers: totalUsers,
          suspiciousReviewCount: 0,
          dangerReviewCount: 0,
        ),
      ),
    );
  }

  @override
  Future<Result<AdminModelPerformance>> getModelPerformance({
    required int days,
  }) async {
    return const FailureResult(Failure(message: 'not needed'));
  }
}

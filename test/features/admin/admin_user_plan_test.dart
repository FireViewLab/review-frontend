import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_user_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_user_dto.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_user_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_user_repository.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_users_page.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_user_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_user_plan_dialog.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

const _user = AdminUser(
  userId: 1,
  email: 'user@example.com',
  nickname: 'user',
  role: 'USER',
  provider: 'LOCAL',
  atiScore: null,
  createdAt: null,
  planTier: 'FREE',
);
final _other = AdminUser(
  userId: 2,
  email: 'other@example.com',
  nickname: 'other',
  role: 'USER',
  provider: 'LOCAL',
  atiScore: null,
  createdAt: null,
  planTier: 'PLUS',
  planExpiresAt: DateTime(2020),
);

class _Client extends Mock implements ApiClient {}

class _Repository implements AdminUserRepository {
  int updates = 0;
  int lists = 0;
  Completer<Result<AdminUser>>? pending;
  Result<AdminUser>? failure;
  AdminPlanTier? savedPlan;
  DateTime? savedExpiry;

  @override
  Future<Result<AdminPage<AdminUser>>> getUsers({
    required int page,
    required int size,
  }) async {
    lists++;
    return Success(
      AdminPage(
        items: [_user, _other],
        totalElements: 2,
        totalPages: 1,
        page: 0,
      ),
    );
  }

  @override
  Future<Result<AdminUser>> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  }) async {
    updates++;
    savedPlan = planTier;
    savedExpiry = expiresAt;
    return pending != null
        ? pending!.future
        : failure ?? Success(updated(planTier, expiresAt));
  }

  AdminUser updated(AdminPlanTier plan, DateTime? expiry) => AdminUser(
    userId: 1,
    email: _user.email,
    nickname: _user.nickname,
    role: _user.role,
    provider: _user.provider,
    atiScore: null,
    createdAt: null,
    planTier: plan.name.toUpperCase(),
    planExpiresAt: expiry,
  );
}

Future<ProviderContainer> _container(_Repository repository) async {
  final container = ProviderContainer(
    overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
  );
  final sub = container.listen(adminUserViewModelProvider, (_, _) {});
  addTearDown(() {
    sub.close();
    container.dispose();
  });
  await pumpEventQueue();
  return container;
}

void main() {
  test('parses missing and unknown plan codes without inventing a plan', () {
    expect(AdminUserDto(const {}).toEntity().planTier, isNull);
    final user = AdminUserDto(const {
      'planTier': 'FUTURE_PLAN',
      'planExpiresAt': '2026-09-01T10:30:00',
    }).toEntity();
    expect(user.planTier, 'FUTURE_PLAN');
    expect(user.planExpiresAt, DateTime(2026, 9, 1, 10, 30));
    expect(user.isPlanExpiredAt(DateTime(2026, 10)), isTrue);
    expect(
      AdminUserDto(const {
        'planTier': 'FREE',
        'planExpiresAt': '2020-01-01T00:00:00',
      }).toEntity().isPlanExpiredAt(DateTime(2026)),
      isFalse,
    );
  });

  test(
    'PATCH sends a local date-time and uses the server user response',
    () async {
      final client = _Client();
      final date = DateTime(2026, 12, 1, 23, 59, 59);
      when(() => client.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/admin/users/1/plan'),
          data: {
            'success': true,
            'data': {
              'userId': 1,
              'planTier': 'PRO',
              'planExpiresAt': date.toIso8601String(),
            },
          },
        ),
      );
      final source = AdminUserRemoteDataSourceImpl(
        apiClient: client,
        config: AppConfig.fromEnvironment(),
      );
      final user = await source.updatePlan(
        userId: 1,
        planTier: AdminPlanTier.pro,
        expiresAt: date,
      );
      expect(user.planTier, 'PRO');
      expect(user.planExpiresAt, date);
      verify(
        () => client.patch(
          '/api/admin/users/1/plan',
          data: {'planTier': 'PRO', 'expiresAt': date.toIso8601String()},
        ),
      ).called(1);
      await source.updatePlan(
        userId: 1,
        planTier: AdminPlanTier.free,
        expiresAt: date,
      );
      verify(
        () =>
            client.patch('/api/admin/users/1/plan', data: {'planTier': 'FREE'}),
      ).called(1);
      await source.updatePlan(userId: 1, planTier: AdminPlanTier.plus);
      verify(
        () =>
            client.patch('/api/admin/users/1/plan', data: {'planTier': 'PLUS'}),
      ).called(1);
    },
  );

  test('preserves server failure code and message', () async {
    final client = _Client();
    when(() => client.patch(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/admin/users/1/plan'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/admin/users/1/plan'),
          statusCode: 404,
          data: {'message': 'missing user', 'errorCode': 'USER_NOT_FOUND'},
        ),
      ),
    );
    final repository = AdminUserRepositoryImpl(
      AdminUserRemoteDataSourceImpl(
        apiClient: client,
        config: AppConfig.fromEnvironment(),
      ),
    );
    final result = await repository.updatePlan(
      userId: 1,
      planTier: AdminPlanTier.free,
    );
    result.when(
      success: (_) => fail('Expected failure'),
      failure: (f) {
        expect(f.message, 'missing user');
        expect(f.code, 'USER_NOT_FOUND');
      },
    );
  });

  test('updates only the saved row without reloading the list', () async {
    final repo = _Repository();
    final container = await _container(repo);
    final vm = container.read(adminUserViewModelProvider.notifier);
    await vm.updatePlan(userId: 1, planTier: AdminPlanTier.pro);
    final state = container.read(adminUserViewModelProvider);
    expect(state.items.first.planTier, 'PRO');
    expect(identical(state.items.last, _other), isTrue);
    expect(repo.lists, 1);
    expect(state.updatingUserIds, isEmpty);
  });

  test('failed save preserves rows and returns the failure', () async {
    final repo = _Repository()
      ..failure = const FailureResult(Failure(message: 'save failed'));
    final container = await _container(repo);
    final vm = container.read(adminUserViewModelProvider.notifier);
    final result = await vm.updatePlan(userId: 1, planTier: AdminPlanTier.pro);
    expect(result, isA<FailureResult<AdminUser>>());
    expect(
      identical(container.read(adminUserViewModelProvider).items.first, _user),
      isTrue,
    );
  });

  test('blocks duplicates and list queries during a save', () async {
    final repo = _Repository()..pending = Completer();
    final container = await _container(repo);
    final vm = container.read(adminUserViewModelProvider.notifier);
    final saving = vm.updatePlan(userId: 1, planTier: AdminPlanTier.pro);
    expect(
      await vm.updatePlan(userId: 1, planTier: AdminPlanTier.plus),
      isNull,
    );
    await vm.loadList(page: 1);
    expect(repo.updates, 1);
    expect(repo.lists, 1);
    repo.pending!.complete(Success(repo.updated(AdminPlanTier.pro, null)));
    await saving;
  });

  test('ignores a late response from a disposed view model', () async {
    final repo = _Repository()..pending = Completer();
    final container = await _container(repo);
    final vm = container.read(adminUserViewModelProvider.notifier);
    final saving = vm.updatePlan(userId: 1, planTier: AdminPlanTier.pro);
    container.invalidate(adminUserViewModelProvider);
    await pumpEventQueue();
    repo.pending!.complete(Success(repo.updated(AdminPlanTier.pro, null)));
    expect(await saving, isNull);
    expect(
      container.read(adminUserViewModelProvider).items.first.planTier,
      'FREE',
    );
  });

  for (final width in [320.0, 800.0, 1400.0]) {
    for (final lang in ['ko', 'en', 'ja', 'zh']) {
      testWidgets('plan column and dialog save fit $width/$lang', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = _Repository();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [adminUserRepositoryProvider.overrideWithValue(repo)],
            child: MaterialApp(
              theme: AppTheme.light,
              locale: Locale(lang),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const Scaffold(body: AdminUsersPage()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(AdminUsersPage)),
        );
        expect(find.text(l10n.adminUserPlanColumn), findsOneWidget);
        expect(find.text(l10n.chatPlanFree), findsOneWidget);
        expect(find.text(l10n.adminUserPlanExpired), findsOneWidget);
        await tester.ensureVisible(
          find.widgetWithText(TextButton, l10n.adminUserPlanChange).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(TextButton, l10n.adminUserPlanChange).first,
        );
        await tester.pumpAndSettle();
        expect(find.byType(AdminUserPlanDialog), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('admin-plan-tier')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.chatPlanPro).last);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.adminUserPlanSave));
        await tester.pumpAndSettle();
        expect(repo.savedPlan, AdminPlanTier.pro);
        expect(repo.savedExpiry, isNull);
        expect(find.byType(AdminUserPlanDialog), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('dialog retains selection and error after a failed save', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: AdminUserPlanDialog(
            user: _user,
            onSave: (_, _) async =>
                const FailureResult(Failure(message: 'save failed')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('save failed'), findsOneWidget);
    expect(find.byType(AdminUserPlanDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('30-day expiry and free plan clearing', (tester) async {
    DateTime? saved;
    AdminPlanTier? plan;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: AdminUserPlanDialog(
            user: _other,
            onSave: (tier, expiry) async {
              plan = tier;
              saved = expiry;
              return const FailureResult(Failure(message: 'keep open'));
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('30 days').last);
    await tester.pumpAndSettle();
    final before = DateTime.now();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(plan, AdminPlanTier.plus);
    expect(saved!.difference(before).inDays, 30);
    await tester.tap(find.byKey(const ValueKey('admin-plan-tier')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Free').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(plan, AdminPlanTier.free);
    expect(saved, isNull);
  });

  testWidgets(
    'custom date requires a date and saves the end of the selected day',
    (tester) async {
      DateTime? saved;
      final repo = _Repository();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: AdminUserPlanDialog(
              user: _user,
              onSave: (plan, date) async {
                saved = date;
                return Success(repo.updated(plan, date));
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('admin-plan-tier')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Plus').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('No expiration'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose a date').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        find.text('Choose an expiration date from today onward.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Select date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(saved, isNotNull);
      expect(saved!.hour, 23);
      expect(saved!.minute, 59);
      expect(saved!.second, 59);
    },
  );

  testWidgets('disables save and cancellation while a save is pending', (
    tester,
  ) async {
    final pending = Completer<Result<AdminUser>>();
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: AdminUserPlanDialog(
            user: _user,
            onSave: (_, _) {
              calls++;
              return pending.future;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Saving'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'))
          .onPressed,
      isNull,
    );
    expect(calls, 1);
    pending.complete(const FailureResult(Failure(message: 'failed')));
    await tester.pumpAndSettle();
    expect(find.text('failed'), findsOneWidget);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';
import 'package:re_view_front/features/notifications/presentation/notification_target.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';

void main() {
  group('notificationRoute', () {
    test('maps server target paths to app routes', () {
      expect(notificationRoute('/products/12'), '/product/12');
      expect(notificationRoute('/reports/me/4'), RoutePaths.feedbackHistory);
      expect(notificationRoute('/feedback/me/9'), RoutePaths.feedbackHistory);
      expect(notificationRoute('/unknown/1'), isNull);
      expect(notificationRoute(null), isNull);
    });
  });

  group('NotificationListViewModel', () {
    late _FakeRepository repository;
    late ProviderContainer container;

    setUp(() async {
      repository = _FakeRepository();
      container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
          isLoggedInProvider.overrideWithValue(true),
        ],
      );
      container.listen(notificationListViewModelProvider, (_, _) {});
      await pumpEventQueue();
    });

    tearDown(() => container.dispose());

    test('marks a notification as read', () async {
      await container
          .read(notificationListViewModelProvider.notifier)
          .markRead(1);

      final items = container.read(notificationListViewModelProvider).items;
      expect(items.firstWhere((n) => n.id == 1).isRead, isTrue);
      expect(repository.readIds, [1]);
    });

    test('restores the unread state when the server rejects it', () async {
      repository.failMarkRead = true;
      await container
          .read(notificationListViewModelProvider.notifier)
          .markRead(1);

      final state = container.read(notificationListViewModelProvider);
      expect(state.items.firstWhere((n) => n.id == 1).isRead, isFalse);
      expect(state.errorMessage, '실패');
    });

    test('keeps the badge in sync after leaving the list', () async {
      await container.read(unreadNotificationCountProvider.future);
      final sending = container
          .read(notificationListViewModelProvider.notifier)
          .markRead(1);
      // 읽음 요청 직후 화면을 벗어나 목록 뷰모델이 사라져도 배지는 줄어든다.
      container.invalidate(notificationListViewModelProvider);
      await sending;

      expect(container.read(unreadNotificationCountProvider).value, 1);
    });

    test('rolls back only the failed notification', () async {
      repository.failMarkRead = true;
      final vm = container.read(notificationListViewModelProvider.notifier);
      final failing = vm.markRead(1);
      repository.failMarkRead = false;
      await vm.markRead(2);
      await failing;

      final items = container.read(notificationListViewModelProvider).items;
      expect(items.firstWhere((n) => n.id == 1).isRead, isFalse);
      expect(items.firstWhere((n) => n.id == 2).isRead, isTrue);
    });

    test('marks every notification as read', () async {
      await container
          .read(notificationListViewModelProvider.notifier)
          .markAllRead();

      final state = container.read(notificationListViewModelProvider);
      expect(state.hasUnread, isFalse);
      expect(repository.markedAll, isTrue);
    });
  });
}

class _FakeRepository implements NotificationRepository {
  bool failMarkRead = false;
  bool markedAll = false;
  final List<int> readIds = [];

  @override
  Future<Result<NotificationPage>> getNotifications({
    required int page,
    required int size,
  }) async {
    return Success(
      NotificationPage(
        items: [
          for (final id in [1, 2])
            AppNotification(
              id: id,
              type: 'SYSTEM',
              typeDescription: '',
              title: '알림 $id',
              message: '',
              isRead: false,
              targetUrl: null,
              createdAt: null,
            ),
        ],
        page: page,
        isLast: true,
      ),
    );
  }

  @override
  Future<Result<int>> getUnreadCount() async => const Success(2);

  @override
  Future<Result<void>> markRead(int id) async {
    if (failMarkRead) return const FailureResult(Failure(message: '실패'));
    readIds.add(id);
    return const Success(null);
  }

  @override
  Future<Result<void>> markAllRead() async {
    markedAll = true;
    return const Success(null);
  }
}

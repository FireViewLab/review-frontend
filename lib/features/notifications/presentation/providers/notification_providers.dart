import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:re_view_front/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';
import 'package:re_view_front/features/notifications/presentation/view_models/notification_list_state.dart';
import 'package:re_view_front/features/notifications/presentation/view_models/notification_list_view_model.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSourceImpl(
        apiClient: ref.watch(apiClientProvider),
        config: ref.watch(appConfigProvider),
      );
    });

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
  );
});

/// 읽지 않은 알림 수. 로그아웃 상태면 0이고, 로그인하면 다시 불러온다.
///
/// 목록 화면이 사라져도 배지가 맞도록 읽음 처리 때 이 값을 직접 조정한다.
final unreadNotificationCountProvider =
    AsyncNotifierProvider<UnreadNotificationCount, int>(
      UnreadNotificationCount.new,
    );

class UnreadNotificationCount extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    if (!ref.watch(isLoggedInProvider)) return 0;
    final result = await ref
        .read(notificationRepositoryProvider)
        .getUnreadCount();
    // Failure is distinct from a confirmed zero unread count.
    return result.when(
      success: (count) => count,
      failure: (failure) => throw failure,
    );
  }

  void adjust(int delta) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData((current + delta).clamp(0, 1 << 30));
  }

  void clear() => state = const AsyncData(0);

  void synchronize() {
    if (ref.mounted) ref.invalidateSelf();
  }
}

final notificationListViewModelProvider =
    NotifierProvider.autoDispose<
      NotificationListViewModel,
      NotificationListState
    >(NotificationListViewModel.new);

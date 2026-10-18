import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/features/notifications/presentation/view_models/notification_list_state.dart';

class NotificationListViewModel extends Notifier<NotificationListState> {
  static const _pageSize = 20;
  int _generation = 0;
  final Set<int> _readIds = {};

  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  @override
  NotificationListState build() {
    _generation++;
    _readIds.clear();
    final loggedIn = ref.watch(authSessionProvider).isLoggedIn;
    if (!loggedIn) return const NotificationListState(isLast: true);
    Future.microtask(() {
      if (ref.mounted) refresh();
    });
    return const NotificationListState(isLoading: true);
  }

  Future<void> refresh() async {
    if (!ref.mounted || !ref.read(isLoggedInProvider) || state.isMutating) {
      return;
    }
    final generation = ++_generation;
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      failedPage: false,
    );
    final result = await _repository.getNotifications(page: 0, size: _pageSize);
    if (!ref.mounted || generation != _generation) return;
    result.when(
      success: (page) => state = NotificationListState(
        items: _merge(page.items),
        page: 0,
        isLast: page.isLast,
      ),
      failure: (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
    ref.invalidate(unreadNotificationCountProvider);
  }

  Future<void> loadMore() async {
    if (state.isLast ||
        state.isLoading ||
        state.isLoadingMore ||
        state.isMutating ||
        state.errorMessage != null) {
      return;
    }
    final generation = _generation;
    state = state.copyWith(isLoadingMore: true);
    final next = state.page + 1;
    final result = await _repository.getNotifications(
      page: next,
      size: _pageSize,
    );
    if (!ref.mounted || generation != _generation) return;
    result.when(
      success: (page) => state = state.copyWith(
        items: _merge([...state.items, ...page.items]),
        page: next,
        isLast: page.isLast,
        isLoadingMore: false,
        clearError: true,
        failedPage: false,
      ),
      failure: (f) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: f.message,
        failedPage: true,
      ),
    );
  }

  UnreadNotificationCount get _unreadCount =>
      ref.read(unreadNotificationCountProvider.notifier);

  Future<void> retryMore() async {
    if (!state.failedPage) return;
    state = state.copyWith(clearError: true, failedPage: false);
    await loadMore();
  }

  List<AppNotification> _merge(List<AppNotification> items) {
    final unique = <int, AppNotification>{};
    for (final item in items) {
      unique[item.id] = _readIds.contains(item.id) ? item.withRead(true) : item;
    }
    return unique.values.toList();
  }

  Future<void> markRead(int id) async {
    if (state.isMarkingAll ||
        state.readingIds.contains(id) ||
        !state.items.any((n) => n.id == id && !n.isRead)) {
      return;
    }
    final generation = _generation;
    final count = _unreadCount;
    _readIds.add(id);
    _setRead({id}, read: true);
    state = state.copyWith(
      readingIds: {...state.readingIds, id},
      clearError: true,
    );
    final result = await _repository.markRead(id);
    // The persistent badge refreshes even when navigation disposed this list.
    count.synchronize();
    if (!ref.mounted || generation != _generation) return;
    state = state.copyWith(readingIds: state.readingIds.difference({id}));
    result.when(
      success: (_) {},
      failure: (f) {
        _readIds.remove(id);
        _setRead({id}, read: false);
        state = state.copyWith(errorMessage: f.message, failedPage: false);
      },
    );
  }

  Future<void> markAllRead() async {
    if (state.isMutating ||
        state.isLoading ||
        state.isLoadingMore ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    final generation = _generation;
    final count = _unreadCount;
    final unreadIds = {
      for (final n in state.items)
        if (!n.isRead) n.id,
    };
    _setRead(unreadIds, read: true);
    state = state.copyWith(isMarkingAll: true, clearError: true);
    final result = await _repository.markAllRead();
    count.synchronize();
    if (!ref.mounted || generation != _generation) return;
    state = state.copyWith(isMarkingAll: false);
    result.when(
      success: (_) => _readIds.addAll(unreadIds),
      failure: (f) {
        _setRead(unreadIds, read: false);
        state = state.copyWith(errorMessage: f.message, failedPage: false);
      },
    );
  }

  /// [ids]에 해당하는 알림만 읽음 상태를 바꾼다. 그 사이 불러온 항목은 그대로 둔다.
  void _setRead(Set<int> ids, {required bool read}) {
    state = state.copyWith(
      items: [
        for (final n in state.items)
          if (ids.contains(n.id)) n.withRead(read) else n,
      ],
    );
  }
}

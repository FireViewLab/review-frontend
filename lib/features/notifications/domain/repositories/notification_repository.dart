import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';

abstract interface class NotificationRepository {
  Future<Result<NotificationPage>> getNotifications({
    required int page,
    required int size,
  });

  Future<Result<int>> getUnreadCount();

  Future<Result<void>> markRead(int id);

  Future<Result<void>> markAllRead();
}

import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';

class AppNotificationDto {
  const AppNotificationDto(this._json);

  final Map<String, dynamic> _json;

  AppNotification toEntity() {
    final targetUrl = _json['targetUrl']?.toString();
    return AppNotification(
      id: (_json['notificationId'] as num?)?.toInt() ?? 0,
      type: _json['type']?.toString() ?? 'SYSTEM',
      typeDescription: _json['typeDescription']?.toString() ?? '',
      title: _json['title']?.toString() ?? '',
      message: _json['message']?.toString() ?? '',
      isRead: _json['isRead'] == true,
      targetUrl: targetUrl == null || targetUrl.isEmpty ? null : targetUrl,
      createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
    );
  }
}

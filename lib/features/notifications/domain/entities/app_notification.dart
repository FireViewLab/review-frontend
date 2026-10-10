/// 사용자 알림.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.typeDescription,
    required this.title,
    required this.message,
    required this.isRead,
    required this.targetUrl,
    required this.createdAt,
  });

  final int id;

  /// REPORT_ACCEPTED, ANALYSIS_COMPLETE, RISKY_PRODUCT_DETECTED 등 서버 코드.
  final String type;
  final String typeDescription;
  final String title;
  final String message;
  final bool isRead;

  /// 서버 기준 경로(예: /products/12). 앱 라우트로 바꿔서 쓴다.
  final String? targetUrl;
  final DateTime? createdAt;

  AppNotification withRead(bool read) => AppNotification(
    id: id,
    type: type,
    typeDescription: typeDescription,
    title: title,
    message: message,
    isRead: read,
    targetUrl: targetUrl,
    createdAt: createdAt,
  );
}

/// 알림 목록 한 페이지.
class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.page,
    required this.isLast,
  });

  final List<AppNotification> items;
  final int page;
  final bool isLast;
}

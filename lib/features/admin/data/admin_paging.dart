import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';

/// 서버의 페이징 응답(`data` 객체)을 [AdminPage]로 변환한다.
///
/// `data = { content: [...], totalElements, totalPages }` 형태를 기대하며,
/// [mapItem]으로 각 항목을 도메인 엔티티로 매핑한다. [page]는 요청한 페이지 번호.
AdminPage<T> parseAdminPage<T>(
  Map<String, dynamic> data, {
  required T Function(Map<String, dynamic> json) mapItem,
  required int page,
}) {
  final rawContent = data['content'];
  final items = <T>[
    if (rawContent is List)
      for (final item in rawContent)
        if (item is Map<String, dynamic>) mapItem(item),
  ];

  return AdminPage<T>(
    items: items,
    totalElements: (data['totalElements'] as num?)?.toInt() ?? items.length,
    totalPages: (data['totalPages'] as num?)?.toInt() ?? 0,
    page: page,
  );
}

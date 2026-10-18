/// 관리자 목록 API 공통 페이지네이션 결과.
///
/// 서버 응답의 `{ content, totalElements, totalPages }` 구조를 표현한다.
/// [page]는 0부터 시작하는 현재 페이지 번호.
class AdminPage<T> {
  const AdminPage({
    required this.items,
    required this.totalElements,
    required this.totalPages,
    required this.page,
  });

  const AdminPage.empty()
      : items = const <Never>[],
        totalElements = 0,
        totalPages = 0,
        page = 0;

  final List<T> items;
  final int totalElements;
  final int totalPages;
  final int page;

  bool get isEmpty => items.isEmpty;
}

/// 마이페이지 최근 활동 항목.
class UserActivity {
  const UserActivity({
    required this.type,
    required this.description,
    required this.targetId,
    required this.createdAt,
  });

  /// WISHLIST_ADD(대상: 상품 ID) / FEEDBACK_SUBMIT(대상: 리뷰 ID)
  final String type;
  final String description;
  final String? targetId;
  final DateTime? createdAt;
}

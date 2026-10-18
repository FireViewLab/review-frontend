import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';

class AdminSuspiciousReviewState {
  const AdminSuspiciousReviewState({
    this.maxRti = 50,
    this.items = const [],
    this.page = 0,
    this.totalPages = 0,
    this.totalElements = 0,
    this.pageSize = 20,
    this.isLoading = false,
    this.errorMessage,
    this.selected,
  });

  /// RTI 점수 상한 필터 (이 값 미만 리뷰만 조회).
  final int maxRti;
  final List<AdminSuspiciousReview> items;
  final int page;
  final int totalPages;
  final int totalElements;
  final int pageSize;
  final bool isLoading;
  final String? errorMessage;
  final AdminSuspiciousReview? selected;

  AdminSuspiciousReviewState copyWith({
    int? maxRti,
    List<AdminSuspiciousReview>? items,
    int? page,
    int? totalPages,
    int? totalElements,
    int? pageSize,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    AdminSuspiciousReview? selected,
    bool clearSelected = false,
  }) {
    return AdminSuspiciousReviewState(
      maxRti: maxRti ?? this.maxRti,
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selected: clearSelected ? null : (selected ?? this.selected),
    );
  }
}

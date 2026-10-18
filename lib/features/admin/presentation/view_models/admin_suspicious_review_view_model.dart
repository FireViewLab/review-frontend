import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_suspicious_review_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_suspicious_review_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_state.dart';

class AdminSuspiciousReviewViewModel
    extends Notifier<AdminSuspiciousReviewState> {
  AdminSuspiciousReviewRepository get _repository =>
      ref.read(adminSuspiciousReviewRepositoryProvider);

  @override
  AdminSuspiciousReviewState build() {
    Future.microtask(loadList);
    return const AdminSuspiciousReviewState(isLoading: true);
  }

  Future<void> loadList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getReviews(
      maxRti: state.maxRti,
      page: state.page,
      size: state.pageSize,
    );
    result.when(
      success: (page) => state = state.copyWith(
        items: page.items,
        totalPages: page.totalPages,
        totalElements: page.totalElements,
        isLoading: false,
      ),
      failure: (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
  }

  void setMaxRti(int maxRti) {
    state = state.copyWith(maxRti: maxRti, page: 0);
    loadList();
  }

  void changePage(int page) {
    state = state.copyWith(page: page);
    loadList();
  }

  void selectItem(AdminSuspiciousReview review) {
    state = state.copyWith(selected: review);
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true);
  }

  void refresh() => loadList();
}

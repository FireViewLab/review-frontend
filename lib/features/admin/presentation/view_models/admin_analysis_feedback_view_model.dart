import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_analysis_feedback_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_analysis_feedback_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_state.dart';

class AdminAnalysisFeedbackViewModel
    extends Notifier<AdminAnalysisFeedbackState> {
  AdminAnalysisFeedbackRepository get _repository =>
      ref.read(adminAnalysisFeedbackRepositoryProvider);

  @override
  AdminAnalysisFeedbackState build() {
    Future.microtask(() {
      loadList();
      loadCounts();
    });
    return const AdminAnalysisFeedbackState(isLoading: true);
  }

  Future<void> loadList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getFeedbacks(
      status: state.statusFilter,
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
      failure: (f) => state = state.copyWith(
        isLoading: false,
        errorMessage: f.message,
      ),
    );
  }

  Future<void> loadCounts() async {
    final targets = <AnalysisFeedbackStatus?>[null, ...AnalysisFeedbackStatus.values];
    final results = await Future.wait(targets.map(_repository.countByStatus));

    final counts = <String, int>{};
    for (var i = 0; i < targets.length; i++) {
      final key =
          targets[i]?.code ?? AdminAnalysisFeedbackState.allCountKey;
      results[i].when(
        success: (count) {
          counts[key] = count;
        },
        failure: (_) {},
      );
    }
    state = state.copyWith(counts: counts);
  }

  void selectStatus(AnalysisFeedbackStatus? status) {
    state = status == null
        ? state.copyWith(resetStatusFilter: true, page: 0)
        : state.copyWith(statusFilter: status, page: 0);
    loadList();
  }

  void changePage(int page) {
    state = state.copyWith(page: page);
    loadList();
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, page: 0);
    loadList();
  }

  void selectItem(AdminAnalysisFeedback feedback) {
    state = state.copyWith(selected: feedback);
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true);
  }

  void refresh() {
    loadList();
    loadCounts();
  }

  /// 상태 변경 저장. 성공 시 true 반환.
  Future<bool> updateStatus({
    required int feedbackId,
    required AnalysisFeedbackStatus status,
    String? adminComment,
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true);
    final result = await _repository.updateStatus(
      feedbackId: feedbackId,
      status: status,
      adminComment: adminComment,
    );
    return result.when(
      success: (_) {
        AdminAnalysisFeedback merge(AdminAnalysisFeedback f) => f.copyWith(
          status: status,
          statusDescription: status.code,
          updatedAt: DateTime.now(),
        );
        final items = [
          for (final item in state.items)
            if (item.feedbackId == feedbackId) merge(item) else item,
        ];
        final selected = state.selected?.feedbackId == feedbackId
            ? merge(state.selected!)
            : state.selected;
        state = state.copyWith(
          items: items,
          selected: selected,
          isUpdating: false,
        );
        loadCounts();
        return true;
      },
      failure: (f) {
        state = state.copyWith(isUpdating: false, errorMessage: f.message);
        return false;
      },
    );
  }
}

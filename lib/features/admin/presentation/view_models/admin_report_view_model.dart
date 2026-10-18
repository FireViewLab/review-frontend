import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_report_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_report_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_state.dart';

class AdminReportViewModel extends Notifier<AdminReportState> {
  AdminReportRepository get _repository =>
      ref.read(adminReportRepositoryProvider);

  @override
  AdminReportState build() {
    Future.microtask(() {
      loadList();
      loadCounts();
    });
    return const AdminReportState(isLoading: true);
  }

  Future<void> loadList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getReports(
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
        selectedIds: const {},
      ),
      failure: (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
  }

  Future<void> loadCounts() async {
    final targets = <ReportStatus?>[null, ...ReportStatus.values];
    final results = await Future.wait(targets.map(_repository.countByStatus));

    final counts = <String, int>{};
    for (var i = 0; i < targets.length; i++) {
      final key = targets[i]?.code ?? AdminReportState.allCountKey;
      results[i].when(
        success: (count) {
          counts[key] = count;
        },
        failure: (_) {},
      );
    }
    state = state.copyWith(counts: counts);
  }

  void selectStatus(ReportStatus? status) {
    state = status == null
        ? state.copyWith(resetStatusFilter: true, page: 0)
        : state.copyWith(statusFilter: status, page: 0);
    loadList();
  }

  void changePage(int page) {
    state = state.copyWith(page: page);
    loadList();
  }

  void selectItem(AdminReport report) {
    state = state.copyWith(selected: report);
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true);
  }

  void toggleRow(int reportId, bool selected) {
    final next = {...state.selectedIds};
    if (selected) {
      next.add(reportId);
    } else {
      next.remove(reportId);
    }
    state = state.copyWith(selectedIds: next);
  }

  void toggleAll(bool selected) {
    state = state.copyWith(
      selectedIds:
          selected ? state.items.map((r) => r.reportId).toSet() : const {},
    );
  }

  void refresh() {
    loadList();
    loadCounts();
  }

  /// [comment]가 null이면 메모 유지, 빈 문자열이면 메모 삭제.
  AdminReport _merge(AdminReport r, ReportStatus status, String? comment) =>
      r.copyWith(
        status: status,
        statusDescription: status.code,
        adminComment: comment,
        clearAdminComment: comment != null && comment.isEmpty,
        updatedAt: DateTime.now(),
      );

  /// 단건 상태 변경. 성공 시 true.
  Future<bool> updateStatus({
    required int reportId,
    required ReportStatus status,
    String? adminComment,
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true);
    final result = await _repository.updateStatus(
      reportId: reportId,
      status: status,
      adminComment: adminComment,
    );
    return result.when(
      success: (_) {
        final items = [
          for (final item in state.items)
            if (item.reportId == reportId)
              _merge(item, status, adminComment)
            else
              item,
        ];
        final selected = state.selected?.reportId == reportId
            ? _merge(state.selected!, status, adminComment)
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

  /// 선택된 신고들을 [status]로 일괄 변경. 일괄 PATCH 엔드포인트가 없어 순차 호출한다.
  /// 실패 건수를 반환하고, 실패한 항목은 재시도할 수 있도록 선택 상태로 남긴다.
  Future<int> bulkUpdateStatus(ReportStatus status) async {
    final ids = state.selectedIds.toList();
    if (ids.isEmpty) return 0;
    state = state.copyWith(isUpdating: true, clearError: true);

    final failedIds = <int>{};
    for (final id in ids) {
      final result = await _repository.updateStatus(
        reportId: id,
        status: status,
      );
      result.when(
        success: (_) {},
        failure: (_) => failedIds.add(id),
      );
    }

    state = state.copyWith(isUpdating: false);
    await loadList();
    await loadCounts();
    // loadList가 선택을 비우므로, 재조회 후 목록에 남아 있는 실패 항목만 다시 선택한다.
    final visibleIds = {for (final item in state.items) item.reportId};
    state = state.copyWith(
      selectedIds: failedIds.intersection(visibleIds),
    );
    return failedIds.length;
  }
}

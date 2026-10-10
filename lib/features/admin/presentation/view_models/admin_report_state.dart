import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';

class AdminReportState {
  const AdminReportState({
    this.statusFilter,
    this.items = const [],
    this.page = 0,
    this.totalPages = 0,
    this.totalElements = 0,
    this.pageSize = 20,
    this.isLoading = false,
    this.errorMessage,
    this.selected,
    this.selectedIds = const {},
    this.counts = const {},
    this.isUpdating = false,
  });

  /// 현재 상태 필터. null이면 전체.
  final ReportStatus? statusFilter;
  final List<AdminReport> items;
  final int page;
  final int totalPages;
  final int totalElements;
  final int pageSize;
  final bool isLoading;
  final String? errorMessage;
  final AdminReport? selected;

  /// 일괄 처리용 선택된 신고 ID 집합.
  final Set<int> selectedIds;

  /// 상태별 건수. 키는 status.code, 전체는 'ALL'.
  final Map<String, int> counts;
  final bool isUpdating;

  static const allCountKey = 'ALL';

  int? countFor(ReportStatus? status) => counts[status?.code ?? allCountKey];

  AdminReportState copyWith({
    ReportStatus? statusFilter,
    bool resetStatusFilter = false,
    List<AdminReport>? items,
    int? page,
    int? totalPages,
    int? totalElements,
    int? pageSize,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    AdminReport? selected,
    bool clearSelected = false,
    Set<int>? selectedIds,
    Map<String, int>? counts,
    bool? isUpdating,
  }) {
    return AdminReportState(
      statusFilter:
          resetStatusFilter ? null : (statusFilter ?? this.statusFilter),
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selected: clearSelected ? null : (selected ?? this.selected),
      selectedIds: selectedIds ?? this.selectedIds,
      counts: counts ?? this.counts,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

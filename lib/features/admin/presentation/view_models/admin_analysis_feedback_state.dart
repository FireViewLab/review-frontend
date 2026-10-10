import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';

class AdminAnalysisFeedbackState {
  const AdminAnalysisFeedbackState({
    this.statusFilter,
    this.items = const [],
    this.page = 0,
    this.totalPages = 0,
    this.totalElements = 0,
    this.pageSize = 20,
    this.isLoading = false,
    this.errorMessage,
    this.selected,
    this.counts = const {},
    this.isUpdating = false,
  });

  /// 현재 탭 필터. null이면 전체.
  final AnalysisFeedbackStatus? statusFilter;
  final List<AdminAnalysisFeedback> items;
  final int page;
  final int totalPages;
  final int totalElements;
  final int pageSize;
  final bool isLoading;
  final String? errorMessage;
  final AdminAnalysisFeedback? selected;

  /// 상태별 건수. 키는 status.code, 전체는 'ALL'.
  final Map<String, int> counts;
  final bool isUpdating;

  static const allCountKey = 'ALL';

  int? countFor(AnalysisFeedbackStatus? status) =>
      counts[status?.code ?? allCountKey];

  AdminAnalysisFeedbackState copyWith({
    AnalysisFeedbackStatus? statusFilter,
    bool resetStatusFilter = false,
    List<AdminAnalysisFeedback>? items,
    int? page,
    int? totalPages,
    int? totalElements,
    int? pageSize,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    AdminAnalysisFeedback? selected,
    bool clearSelected = false,
    Map<String, int>? counts,
    bool? isUpdating,
  }) {
    return AdminAnalysisFeedbackState(
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
      counts: counts ?? this.counts,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';

class AdminDashboardState {
  const AdminDashboardState({
    this.summary = const AsyncLoading(),
    this.performance = const AsyncLoading(),
    this.days = 7,
  });

  final AsyncValue<AdminDashboardSummary> summary;
  final AsyncValue<AdminModelPerformance> performance;

  /// 모델 성능 집계 기간(일). 서버 허용 범위는 1~90.
  final int days;

  AdminDashboardState copyWith({
    AsyncValue<AdminDashboardSummary>? summary,
    AsyncValue<AdminModelPerformance>? performance,
    int? days,
  }) {
    return AdminDashboardState(
      summary: summary ?? this.summary,
      performance: performance ?? this.performance,
      days: days ?? this.days,
    );
  }
}

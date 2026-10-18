import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';

abstract interface class AdminDashboardRepository {
  Future<Result<AdminDashboardSummary>> getSummary();

  /// 최근 [days]일(1~90) 기준 모델 성능.
  Future<Result<AdminModelPerformance>> getModelPerformance({required int days});
}

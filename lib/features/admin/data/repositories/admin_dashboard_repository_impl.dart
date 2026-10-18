import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/data/admin_failure.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_dashboard_remote_data_source.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_dashboard_repository.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  const AdminDashboardRepositoryImpl(this._dataSource);

  final AdminDashboardRemoteDataSource _dataSource;

  @override
  Future<Result<AdminDashboardSummary>> getSummary() async {
    try {
      return Success(await _dataSource.getSummary());
    } catch (e) {
      return FailureResult(adminFailureFrom(e));
    }
  }

  @override
  Future<Result<AdminModelPerformance>> getModelPerformance({
    required int days,
  }) async {
    try {
      return Success(await _dataSource.getModelPerformance(days: days));
    } catch (e) {
      return FailureResult(adminFailureFrom(e));
    }
  }
}

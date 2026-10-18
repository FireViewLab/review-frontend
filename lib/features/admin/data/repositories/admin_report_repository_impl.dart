import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_report_remote_data_source.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_report_repository.dart';

class AdminReportRepositoryImpl implements AdminReportRepository {
  const AdminReportRepositoryImpl(this._dataSource);

  final AdminReportRemoteDataSource _dataSource;

  @override
  Future<Result<AdminPage<AdminReport>>> getReports({
    ReportStatus? status,
    required int page,
    required int size,
  }) async {
    try {
      final result = await _dataSource.getReports(
        status: status?.code,
        page: page,
        size: size,
      );
      return Success(result);
    } catch (e) {
      return FailureResult(_toFailure(e));
    }
  }

  @override
  Future<Result<int>> countByStatus(ReportStatus? status) async {
    try {
      final result = await _dataSource.getReports(
        status: status?.code,
        page: 0,
        size: 1,
      );
      return Success(result.totalElements);
    } catch (e) {
      return FailureResult(_toFailure(e));
    }
  }

  @override
  Future<Result<bool>> updateStatus({
    required int reportId,
    required ReportStatus status,
    String? adminComment,
  }) async {
    try {
      await _dataSource.updateStatus(
        reportId: reportId,
        status: status.code,
        adminComment: adminComment,
      );
      return const Success(true);
    } catch (e) {
      return FailureResult(_toFailure(e));
    }
  }

  Failure _toFailure(Object e) {
    if (e is DioException && e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      return Failure(
        message: data['message']?.toString() ?? e.toString(),
        code: data['errorCode']?.toString(),
        statusCode: e.response?.statusCode,
      );
    }
    return Failure(message: e.toString());
  }
}

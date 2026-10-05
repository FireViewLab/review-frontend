import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/plan/data/datasources/plan_remote_data_source.dart';
import 'package:re_view_front/features/plan/domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  const PlanRepositoryImpl(this._dataSource);

  final PlanRemoteDataSource _dataSource;

  @override
  Future<Result<DateTime?>> getMyPlanExpiry() =>
      _guard(_dataSource.getMyPlanExpiry);

  @override
  Future<Result<void>> changeMyPlan(String code) =>
      _guard(() => _dataSource.changeMyPlan(code));

  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Success(await request());
    } on DioException catch (e) {
      final data = e.response?.data;
      return FailureResult(
        Failure(
          message: data is Map<String, dynamic>
              ? data['message']?.toString() ?? e.message ?? ''
              : e.message ?? '',
          code: data is Map<String, dynamic>
              ? data['errorCode']?.toString()
              : null,
          statusCode: e.response?.statusCode,
          cause: e,
        ),
      );
    } on ApiResponseException catch (e) {
      return FailureResult(Failure(message: e.message, code: e.code, cause: e));
    } catch (e) {
      return FailureResult(Failure(message: e.toString(), cause: e));
    }
  }
}

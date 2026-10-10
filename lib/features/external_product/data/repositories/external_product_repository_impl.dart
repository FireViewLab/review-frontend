import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_product_remote_data_source.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_product_repository.dart';

class ExternalProductRepositoryImpl implements ExternalProductRepository {
  const ExternalProductRepositoryImpl(this._dataSource);

  final ExternalProductRemoteDataSource _dataSource;

  @override
  Future<Result<ExternalProductSnapshot>> getProduct(
    ExternalProductRef ref, {
    String? cursor,
  }) => _guard(() => _dataSource.getProduct(ref, cursor: cursor));

  @override
  Future<Result<CollectionJob>> getJob(int jobId) =>
      _guard(() => _dataSource.getJob(jobId));

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

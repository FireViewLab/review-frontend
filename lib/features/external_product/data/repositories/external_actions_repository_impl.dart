import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_actions_remote_data_source.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_actions_repository.dart';

class ExternalActionsRepositoryImpl implements ExternalActionsRepository {
  ExternalActionsRepositoryImpl(this.remote);
  final ExternalActionsRemoteDataSource remote;
  final Map<ExternalProductRef, Future<Result<int>>> _tags = {};

  Future<Result<T>> _run<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object catch (e) {
      return FailureResult(
        Failure(message: 'External action failed', cause: e),
      );
    }
  }

  @override
  Future<Result<int>> tag(ExternalProductRef product) =>
      _tags.putIfAbsent(product, () async {
        final result = await _run(() => remote.tag(product));
        if (result is FailureResult<int>) _tags.remove(product);
        return result;
      });

  @override
  Future<Result<void>> feedback(
    ExternalProductRef product,
    String reviewId,
    String type,
  ) => _run(() => remote.feedback(product, reviewId, type));

  @override
  Future<Result<void>> report(
    ExternalProductRef product,
    String reviewId, {
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) => _run(
    () => remote.report(
      product,
      reviewId,
      reason: reason,
      detail: detail,
      includeAiEvidence: includeAiEvidence,
      attachmentUrl: attachmentUrl,
    ),
  );
}

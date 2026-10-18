import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/feedback_history/data/datasources/feedback_history_remote_data_source.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';
import 'package:re_view_front/features/feedback_history/domain/repositories/feedback_history_repository.dart';

class FeedbackHistoryRepositoryImpl implements FeedbackHistoryRepository {
  const FeedbackHistoryRepositoryImpl(this._dataSource);

  final FeedbackHistoryRemoteDataSource _dataSource;

  @override
  Future<Result<List<FeedbackItem>>> getFeedbackHistory() async {
    try {
      final dtos = await _dataSource.getFeedbackHistory();
      return Success(dtos.map((dto) => dto.toEntity()).toList());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '피드백 내역을 불러오지 못했습니다.', cause: error),
      );
    }
  }
}

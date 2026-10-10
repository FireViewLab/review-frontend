import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_activity.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/my_page/domain/repositories/my_page_repository.dart';

class MyPageRepositoryImpl implements MyPageRepository {
  const MyPageRepositoryImpl(this._remoteDataSource);

  final MyPageRemoteDataSource _remoteDataSource;

  @override
  Future<Result<UserProfile>> getMyProfile() async {
    try {
      final profile = await _remoteDataSource.getMyProfile();
      return Success(profile.toEntity());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '사용자 정보를 불러오지 못했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<List<UserActivity>>> getMyActivities() async {
    try {
      return Success(await _remoteDataSource.getMyActivities());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '최근 활동을 불러오지 못했습니다.', cause: error),
      );
    }
  }
}

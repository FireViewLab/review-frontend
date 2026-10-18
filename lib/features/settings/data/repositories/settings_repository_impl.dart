import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:re_view_front/features/settings/data/dtos/settings_dto.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dataSource);

  final SettingsRemoteDataSource _dataSource;

  @override
  Future<Result<SettingsData>> getSettings() =>
      _request(_dataSource.getSettings);

  @override
  Future<Result<SettingsData>> updateSettings(SettingsData settings) =>
      _request(() => _dataSource.updateSettings(settings));

  @override
  Future<Result<String>> getLoginMethod() async {
    try {
      return Success(await _dataSource.getLoginMethod());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: 'Invalid security response', cause: error),
      );
    }
  }

  Future<Result<SettingsData>> _request(
    Future<SettingsDto> Function() request,
  ) async {
    try {
      return Success((await request()).toEntity());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: 'Invalid settings response', cause: error),
      );
    }
  }
}

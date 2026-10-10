import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._dataSource);

  final NotificationRemoteDataSource _dataSource;

  @override
  Future<Result<NotificationPage>> getNotifications({
    required int page,
    required int size,
  }) => _guard(() => _dataSource.getNotifications(page: page, size: size));

  @override
  Future<Result<int>> getUnreadCount() => _guard(_dataSource.getUnreadCount);

  @override
  Future<Result<void>> markRead(int id) =>
      _guard(() => _dataSource.markRead(id));

  @override
  Future<Result<void>> markAllRead() => _guard(_dataSource.markAllRead);

  Future<Result<T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Success(await run());
    } on DioException catch (e) {
      final data = e.response?.data;
      return FailureResult(
        Failure(
          message: data is Map<String, dynamic>
              ? data['message']?.toString() ?? e.message ?? ''
              : e.message ?? '',
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

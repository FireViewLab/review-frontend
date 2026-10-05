import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
    ChatMode mode = ChatMode.standard,
  }) => _guard(
    () => _dataSource.ask(
      question: question,
      sessionId: sessionId,
      productId: productId,
      mode: mode,
    ),
  );

  @override
  Future<Result<ChatQuota>> getQuota() => _guard(_dataSource.getQuota);

  @override
  Future<Result<ChatSessionPage>> getSessions({
    required int page,
    required int size,
  }) => _guard(() => _dataSource.getSessions(page: page, size: size));

  @override
  Future<Result<List<ChatMessage>>> getSessionMessages(int sessionId) =>
      _guard(() => _dataSource.getSessionMessages(sessionId));

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

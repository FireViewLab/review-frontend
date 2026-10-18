import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_message_dto.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_quota_dto.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_reply_dto.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_session_dto.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatSessionPage> getSessions({required int page, required int size});
  Future<List<ChatMessage>> getSessionMessages(int sessionId);

  Future<ChatReply> ask({
    required String question,
    int? sessionId,
    String? productId,
    ChatMode mode = ChatMode.standard,
  });

  Future<ChatQuota> getQuota();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<ChatSessionPage> getSessions({
    required int page,
    required int size,
  }) async {
    final response = await _apiClient.get(
      '${_config.chatBasePath}/sessions',
      queryParameters: {'page': page, 'size': size},
    );
    final body = _requireData(response.data);
    if (body is! Map<String, dynamic> || body['content'] is! List) {
      throw const FormatException('Invalid chat session page');
    }
    return ChatSessionPage(
      items: [
        for (final item in body['content'] as List)
          ChatSessionDto(item as Map<String, dynamic>).toEntity(),
      ],
      page: (body['number'] as num?)?.toInt() ?? page,
      isLast: body['last'] as bool,
    );
  }

  @override
  Future<List<ChatMessage>> getSessionMessages(int sessionId) async {
    final response = await _apiClient.get(
      '${_config.chatBasePath}/sessions/$sessionId/messages',
    );
    final body = _requireData(response.data);
    if (body is! List) throw const FormatException('Invalid chat message list');
    return [
      for (final item in body)
        ChatMessageDto(item as Map<String, dynamic>).toEntity(),
    ];
  }

  Object? _requireData(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
    throw const FormatException('Invalid chat response');
  }

  @override
  Future<ChatReply> ask({
    required String question,
    int? sessionId,
    String? productId,
    ChatMode mode = ChatMode.standard,
  }) async {
    final response = await _apiClient.post(
      mode == ChatMode.pro
          ? '${_config.chatBasePath}/pro/messages'
          : '${_config.chatBasePath}/messages',
      data: <String, dynamic>{
        'question': question,
        'sessionId': ?sessionId,
        'productId': ?productId,
      },
      options: Options(receiveTimeout: _config.chatReceiveTimeout),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return ChatReplyDto(body).toEntity();
      }
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<ChatQuota> getQuota() async {
    final response = await _apiClient.get('${_config.chatBasePath}/quota');
    final body = _requireData(response.data);
    final quota = body is Map<String, dynamic>
        ? ChatQuotaDto(body).toEntity()
        : null;
    if (quota == null) throw const FormatException('Invalid chat quota');
    return quota;
  }
}

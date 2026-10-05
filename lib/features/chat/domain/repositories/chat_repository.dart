import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

abstract interface class ChatRepository {
  Future<Result<ChatSessionPage>> getSessions({
    required int page,
    required int size,
  });
  Future<Result<List<ChatMessage>>> getSessionMessages(int sessionId);

  /// [sessionId]가 null이면 새 대화를 시작한다. [productId]는 새 대화일 때만 반영된다.
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
    ChatMode mode = ChatMode.standard,
  });

  /// 오늘 남은 사용량과 요금제. 질문 횟수를 쓰지 않는다.
  Future<Result<ChatQuota>> getQuota();
}

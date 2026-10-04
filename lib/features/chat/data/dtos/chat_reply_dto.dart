import 'package:re_view_front/features/chat/data/dtos/chat_quota_dto.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';

class ChatReplyDto {
  const ChatReplyDto(this._json);

  final Map<String, dynamic> _json;

  ChatReply toEntity() {
    final quota = _json['quota'];
    return ChatReply(
      sessionId: (_json['sessionId'] as num?)?.toInt() ?? 0,
      answer: _json['answer']?.toString() ?? '',
      blocked: _json['blocked'] == true,
      blockReason: _json['blockReason']?.toString(),
      quota: quota is Map<String, dynamic>
          ? ChatQuotaDto(quota).toEntity()
          : null,
    );
  }
}

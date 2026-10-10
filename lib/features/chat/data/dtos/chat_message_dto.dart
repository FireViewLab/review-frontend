import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';

class ChatMessageDto {
  const ChatMessageDto(this._json);
  final Map<String, dynamic> _json;

  ChatMessage toEntity() => ChatMessage(
    id: (_json['id'] as num).toInt(),
    role: switch (_json['role']) {
      'USER' => ChatRole.user,
      'ASSISTANT' => ChatRole.assistant,
      _ => throw const FormatException('Invalid chat message role'),
    },
    content: _json['content'] as String,
    blocked: _json['blocked'] == true,
    blockReason: _json['blockReason'] as String?,
    createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
  );
}

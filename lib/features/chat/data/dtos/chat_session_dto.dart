import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

class ChatSessionDto {
  const ChatSessionDto(this._json);
  final Map<String, dynamic> _json;

  ChatSession toEntity() => ChatSession(
    id: (_json['id'] as num).toInt(),
    productId: _json['productId']?.toString(),
    title: _json['title'] as String? ?? '',
    createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
    lastMessageAt: DateTime.tryParse(_json['lastMessageAt']?.toString() ?? ''),
  );
}

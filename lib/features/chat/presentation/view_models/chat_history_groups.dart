import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

class ChatHistoryGroup {
  ChatHistoryGroup(this.productId, this.sessions);
  final String productId;
  final List<ChatSession> sessions;

  List<List<ChatSession>> get conversations {
    final titles = <String, List<ChatSession>>{};
    for (final session in sessions) {
      titles.putIfAbsent(session.title.trim(), () => []).add(session);
    }
    return titles.values.toList();
  }

  static List<ChatHistoryGroup> fromSessions(List<ChatSession> sessions) {
    final sorted = [...sessions]
      ..sort(
        (a, b) => (b.lastMessageAt ?? b.createdAt ?? DateTime(1970)).compareTo(
          a.lastMessageAt ?? a.createdAt ?? DateTime(1970),
        ),
      );
    final groups = <String, List<ChatSession>>{};
    for (final session in sorted) {
      groups
          .putIfAbsent(session.productId?.trim() ?? '', () => [])
          .add(session);
    }
    return [
      for (final entry in groups.entries)
        ChatHistoryGroup(entry.key, List.unmodifiable(entry.value)),
    ];
  }
}

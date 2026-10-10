class ChatSession {
  const ChatSession({
    required this.id,
    required this.title,
    this.productId,
    this.createdAt,
    this.lastMessageAt,
  });
  final int id;
  final String? productId;
  final String title;
  final DateTime? createdAt;
  final DateTime? lastMessageAt;
}

class ChatSessionPage {
  const ChatSessionPage({
    required this.items,
    required this.page,
    required this.isLast,
  });
  final List<ChatSession> items;
  final int page;
  final bool isLast;
}

import 'dart:convert';
import 'package:re_view_front/core/storage/app_storage.dart';

class ChatHistoryRepository {
  Set<int> hiddenSessionIds(String owner) {
    final value = AppStorage.read('chat_hidden_sessions_$owner');
    if (value == null) return {};
    try {
      return (jsonDecode(value) as List)
          .whereType<num>()
          .map((id) => id.toInt())
          .toSet();
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  // Replace local hiding here when DELETE /api/chat/sessions/{id} is available.
  Future<void> hideSessions(String owner, Iterable<int> sessionIds) async {
    final hidden = hiddenSessionIds(owner)..addAll(sessionIds);
    AppStorage.write(
      'chat_hidden_sessions_$owner',
      jsonEncode(hidden.toList()),
    );
  }
}

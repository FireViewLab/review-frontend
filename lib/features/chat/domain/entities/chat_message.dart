enum ChatRole { user, assistant }

/// 전송 실패 종류. 화면에서 문구로 바꿔 보여 준다.
enum ChatErrorKind {
  unavailable,
  timeout,
  network,

  /// 오늘 한도를 모두 썼다 (429 CHAT_QUOTA_EXCEEDED).
  quotaExceeded,

  /// 요금제가 맞지 않아 프로 모드를 쓸 수 없다 (403 CHAT_PLAN_REQUIRED).
  planRequired,
  unknown,
}

/// 챗봇 대화의 한 메시지.
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.id,
    this.createdAt,
    this.blocked = false,
    this.blockReason,
    this.error,
  });

  final ChatRole role;
  final String content;
  final int? id;
  final DateTime? createdAt;

  /// 서버 세이프가드에 걸려 안내 문구로 대체된 답변인지.
  final bool blocked;

  /// 차단 사유 코드 (INJECTION / OFF_TOPIC / UNGROUNDED_SCORE 등).
  final String? blockReason;

  /// 전송 실패를 알리는 로컬 메시지면 실패 종류. 서버에는 저장되지 않는다.
  final ChatErrorKind? error;
}

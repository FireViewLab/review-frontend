import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';

class ChatState {
  const ChatState({
    this.isOpen = false,
    this.messages = const [],
    this.sessionId,
    this.sessionProductId,
    this.hasBoundContext = false,
    this.conversationRevision = 0,
    this.isHistoryConversation = false,
    this.isLoadingQuota = false,
    this.quotaLoadFailed = false,
    this.isSending = false,
    this.lastFailedQuestion,
    this.isHistoryOpen = false,
    this.sessions = const [],
    this.sessionsPage = 0,
    this.isLastSessionPage = true,
    this.isLoadingSessions = false,
    this.isLoadingMessages = false,
    this.historyError,
    this.quota,
    this.mode = ChatMode.standard,
    this.sendStartedAt,
    this.limitReached = false,
    this.proDenied = false,
  });

  final bool isOpen;
  final List<ChatMessage> messages;

  /// 서버 대화 세션. null이면 다음 질문이 새 대화를 시작한다.
  final int? sessionId;

  /// 현재 세션이 다루는 상품. 상품 없이 시작한 대화면 null.
  final String? sessionProductId;

  /// An explicitly selected general conversation also binds its null context.
  final bool hasBoundContext;

  /// Reset input, focus and scroll state when selecting a different conversation.
  final int conversationRevision;
  final bool isHistoryConversation;
  final bool isLoadingQuota;
  final bool quotaLoadFailed;
  final bool isSending;

  /// 마지막으로 전송에 실패한 질문. 다시 시도할 때 쓴다.
  final String? lastFailedQuestion;

  final bool isHistoryOpen;
  final List<ChatSession> sessions;
  final int sessionsPage;
  final bool isLastSessionPage;
  final bool isLoadingSessions;
  final bool isLoadingMessages;
  final String? historyError;

  /// 서버에서 확인한 오늘 사용량. 아직 모르면 null이고, 그때는 숫자를 보여 주지 않는다.
  final ChatQuota? quota;
  final ChatMode mode;

  /// 지금 보내는 질문을 시작한 시각. 대기 안내 문구를 고르는 데 쓴다.
  final DateTime? sendStartedAt;

  /// 서버가 한도 초과(429)로 거절했다. 사용량을 다시 확인할 때까지 보내지 않는다.
  /// 남은 횟수를 0으로 지어내지 않으려고 숫자와 따로 둔다.
  final bool limitReached;

  /// 서버가 프로 모드를 거절(403)했다. 다시 확인할 때까지 프로를 고를 수 없다.
  final bool proDenied;

  /// 지금 프로 모드를 고를 수 있는지.
  bool get canUsePro => quota?.proAvailable == true && !proDenied;

  /// 오늘 더 보낼 수 없다고 확인된 상태인지.
  bool isExhaustedAt(DateTime now) =>
      limitReached || (quota?.isExhaustedAt(now) ?? false);

  /// 대화만 비운 상태. 패널 열림 여부와 사용량·모드는 그대로 둔다.
  ChatState cleared({String? sessionProductId}) => ChatState(
    isOpen: isOpen,
    quota: quota,
    mode: mode,
    limitReached: limitReached,
    proDenied: proDenied,
    sessionProductId: sessionProductId,
    hasBoundContext: true,
    conversationRevision: conversationRevision + 1,
    isLoadingQuota: isLoadingQuota,
    quotaLoadFailed: quotaLoadFailed,
  );

  bool get hasConversation => messages.isNotEmpty;

  ChatState copyWith({
    bool? isOpen,
    List<ChatMessage>? messages,
    int? sessionId,
    bool clearSession = false,
    String? sessionProductId,
    bool? hasBoundContext,
    bool? isHistoryConversation,
    bool? isLoadingQuota,
    bool? quotaLoadFailed,
    bool? isSending,
    String? lastFailedQuestion,
    bool clearLastFailedQuestion = false,
    bool? isHistoryOpen,
    List<ChatSession>? sessions,
    int? sessionsPage,
    bool? isLastSessionPage,
    bool? isLoadingSessions,
    bool? isLoadingMessages,
    String? historyError,
    bool clearHistoryError = false,
    ChatQuota? quota,
    bool clearQuota = false,
    ChatMode? mode,
    DateTime? sendStartedAt,
    bool? limitReached,
    bool? proDenied,
  }) {
    return ChatState(
      isOpen: isOpen ?? this.isOpen,
      isHistoryOpen: isHistoryOpen ?? this.isHistoryOpen,
      sessions: sessions ?? this.sessions,
      sessionsPage: sessionsPage ?? this.sessionsPage,
      isLastSessionPage: isLastSessionPage ?? this.isLastSessionPage,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      historyError: clearHistoryError
          ? null
          : historyError ?? this.historyError,
      messages: messages ?? this.messages,
      sessionId: clearSession ? null : (sessionId ?? this.sessionId),
      sessionProductId: clearSession
          ? sessionProductId
          : (sessionProductId ?? this.sessionProductId),
      hasBoundContext: hasBoundContext ?? this.hasBoundContext,
      conversationRevision: conversationRevision,
      isHistoryConversation:
          isHistoryConversation ?? this.isHistoryConversation,
      isLoadingQuota: isLoadingQuota ?? this.isLoadingQuota,
      quotaLoadFailed: quotaLoadFailed ?? this.quotaLoadFailed,
      isSending: isSending ?? this.isSending,
      lastFailedQuestion: clearLastFailedQuestion
          ? null
          : (lastFailedQuestion ?? this.lastFailedQuestion),
      quota: clearQuota ? null : (quota ?? this.quota),
      limitReached: limitReached ?? this.limitReached,
      proDenied: proDenied ?? this.proDenied,
      mode: mode ?? this.mode,
      // 보내는 중이 아니면 시작 시각은 의미가 없다.
      sendStartedAt: (isSending ?? this.isSending)
          ? (sendStartedAt ?? this.sendStartedAt)
          : null,
    );
  }
}

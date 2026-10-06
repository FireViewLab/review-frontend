import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';

class ChatViewModel extends Notifier<ChatState> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  /// 대화를 초기화할 때마다 올린다. 응답이 늦게 와도 이미 지운 대화에 붙지 않게 한다.
  int _generation = 0;
  int _historyRequest = 0;
  int _quotaRequest = 0;

  @override
  ChatState build() {
    // 로그아웃하거나 토큰이 만료되면 이전 계정의 대화를 지운다.
    ref.listen(isLoggedInProvider, (previous, next) {
      if (previous == true && !next) {
        _generation++;
        _quotaRequest++;
        state = ChatState(isOpen: state.isOpen);
      } else if (next && state.isOpen) {
        refreshQuota();
      }
    });
    return const ChatState();
  }

  void open() {
    if (state.isOpen) return;
    state = state.copyWith(isOpen: true);
    refreshQuota();
  }

  void close() => state = state.copyWith(isOpen: false);

  void toggle() => state.isOpen ? close() : open();

  /// Apply a confirmed server quota and discard older in-flight reads.
  void applyQuota(ChatQuota quota) => state = _withQuota(state, quota);

  void invalidateQuota() {
    _quotaRequest++;
    state = state.copyWith(clearQuota: true, mode: ChatMode.standard);
  }

  /// 요금제와 오늘 남은 질문 수를 다시 받아 온다. 실패하면 이전 값을 그대로 둔다.
  Future<void> refreshQuota() async {
    if (!ref.read(isLoggedInProvider)) return;
    final request = ++_quotaRequest;
    final result = await _repository.getQuota();
    if (!ref.mounted ||
        request != _quotaRequest ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (quota) => state = _withQuota(state, quota),
      failure: (_) {},
    );
  }

  /// 서버가 준 사용량으로 바꾼다. 조회 응답과 전송 응답이 같은 규칙을 쓴다.
  ChatState _withQuota(ChatState base, ChatQuota quota) {
    // 이보다 먼저 시작한 조회가 늦게 도착해 이 값을 덮지 않게 한다.
    _quotaRequest++;
    return base.copyWith(
      quota: quota,
      limitReached: false,
      proDenied: false,
      // 프로를 쓸 수 없게 됐으면 기본 모드로 되돌린다.
      mode: quota.proAvailable ? null : ChatMode.standard,
    );
  }

  /// 프로 모드는 서버가 쓸 수 있다고 확인해 준 경우에만 고를 수 있다.
  void setMode(ChatMode mode) {
    if (state.isSending) return;
    if (mode == ChatMode.pro && !state.canUsePro) return;
    state = state.copyWith(mode: mode);
  }

  /// 대화를 비우고, 다음 질문부터 [productId] 기준의 새 세션을 시작한다.
  void startNew({String? productId}) {
    if (state.isSending) return;
    _generation++;
    state = state.cleared(sessionProductId: productId);
  }

  /// [productId]는 새 대화를 시작할 때만 서버에 반영된다.
  Future<void> send(String question, {String? productId}) async {
    final text = question.trim();
    if (text.isEmpty ||
        state.isSending ||
        state.isHistoryOpen ||
        state.isLoadingMessages ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    if (state.isExhaustedAt(DateTime.now())) return;

    final isNewSession = state.sessionId == null;
    final generation = _generation;
    final questionMessage = ChatMessage(role: ChatRole.user, content: text);
    state = state.copyWith(
      messages: [
        ...state.messages.where((m) => m.error == null),
        questionMessage,
      ],
      isSending: true,
      sendStartedAt: DateTime.now(),
      sessionProductId: isNewSession ? productId : null,
      clearLastFailedQuestion: true,
    );

    final result = await _repository.ask(
      question: text,
      sessionId: state.sessionId,
      productId: isNewSession ? productId : null,
      mode: state.mode,
    );
    // 로그아웃 알림이 응답보다 늦게 올 수 있어 로그인 상태를 직접 확인한다.
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider)) {
      return;
    }

    result.when(
      success: (reply) {
        final quota = reply.quota;
        state = (quota == null ? state : _withQuota(state, quota)).copyWith(
          sessionId: reply.sessionId,
          isSending: false,
          messages: [
            ...state.messages,
            ChatMessage(
              role: ChatRole.assistant,
              content: reply.answer,
              blocked: reply.blocked,
              blockReason: reply.blockReason,
            ),
          ],
        );
      },
      failure: (failure) {
        final kind = _errorKindOf(failure);
        state = state.copyWith(
          isSending: false,
          lastFailedQuestion: text,
          // 서버가 거절한 사실은 다시 확인하기 전까지 그대로 따른다.
          // 요금제 문제로 막혔으면 다시 물을 때는 기본 모드로 보낸다.
          mode: kind == ChatErrorKind.planRequired ? ChatMode.standard : null,
          proDenied: kind == ChatErrorKind.planRequired ? true : null,
          limitReached: kind == ChatErrorKind.quotaExceeded ? true : null,
          messages: [
            // 실패한 질문은 다시 시도할 때 새로 붙이므로 목록에서 뺀다.
            ...state.messages.where((m) => !identical(m, questionMessage)),
            ChatMessage(
              role: ChatRole.assistant,
              content: failure.message,
              error: kind,
            ),
          ],
        );
        // 한도·요금제는 서버 값이 바뀐 것이므로 다시 확인한다.
        // 503은 서버가 차감을 되돌리므로 함께 확인한다.
        if (kind == ChatErrorKind.quotaExceeded ||
            kind == ChatErrorKind.planRequired ||
            kind == ChatErrorKind.unavailable) {
          refreshQuota();
        }
      },
    );
  }

  Future<void> showHistory() async {
    if (!ref.read(isLoggedInProvider) ||
        state.isSending ||
        state.isLoadingMessages ||
        state.isLoadingSessions) {
      return;
    }
    state = state.copyWith(
      isHistoryOpen: true,
      sessions: [],
      sessionsPage: 0,
      isLastSessionPage: true,
      clearHistoryError: true,
    );
    await _loadSessions(0);
  }

  Future<void> loadMoreSessions() async {
    if (!state.isHistoryOpen ||
        state.isLastSessionPage ||
        state.isLoadingSessions ||
        state.isLoadingMessages ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    await _loadSessions(state.sessionsPage + 1);
  }

  Future<void> _loadSessions(int page) async {
    final generation = _generation;
    final request = ++_historyRequest;
    state = state.copyWith(isLoadingSessions: true, clearHistoryError: true);
    final result = await _repository.getSessions(page: page, size: 20);
    if (!ref.mounted ||
        generation != _generation ||
        request != _historyRequest ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (loaded) {
        final items = page == 0
            ? loaded.items
            : [...state.sessions, ...loaded.items];
        final seen = <int>{};
        state = state.copyWith(
          sessions: [
            for (final session in items)
              if (seen.add(session.id)) session,
          ],
          sessionsPage: loaded.page,
          isLastSessionPage: loaded.isLast,
          isLoadingSessions: false,
        );
      },
      failure: (failure) => state = state.copyWith(
        isLoadingSessions: false,
        historyError: failure.message,
      ),
    );
  }

  void closeHistory() {
    ++_historyRequest;
    if (state.isLoadingMessages) ++_generation;
    state = state.copyWith(
      isHistoryOpen: false,
      isLoadingSessions: false,
      isLoadingMessages: false,
      clearHistoryError: true,
    );
  }

  Future<void> resumeSession(ChatSession session) async {
    if (!ref.read(isLoggedInProvider) || state.isSending) return;
    final generation = ++_generation;
    state = state.copyWith(
      isHistoryOpen: true,
      isLoadingMessages: true,
      isLoadingSessions: false,
      clearHistoryError: true,
    );
    final result = await _repository.getSessionMessages(session.id);
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (messages) => state = state
          .cleared(sessionProductId: _productIdOf(session))
          .copyWith(sessionId: session.id, messages: messages),
      failure: (failure) => state = state.copyWith(
        isLoadingMessages: false,
        historyError: failure.message,
      ),
    );
  }

  /// 상품 없이 시작한 대화는 서버가 빈 값으로 줄 수 있어 null로 맞춘다.
  String? _productIdOf(ChatSession session) {
    final id = session.productId;
    return id == null || id.isEmpty ? null : id;
  }

  Future<void> retry({String? productId}) async {
    final question = state.lastFailedQuestion;
    if (question == null) return;
    await send(question, productId: productId);
  }

  ChatErrorKind _errorKindOf(Failure failure) {
    // 403은 다른 이유로도 오므로 상태 코드가 아니라 오류 코드로 구분한다.
    if (failure.code == 'CHAT_QUOTA_EXCEEDED') {
      return ChatErrorKind.quotaExceeded;
    }
    if (failure.code == 'CHAT_PLAN_REQUIRED') return ChatErrorKind.planRequired;
    if (failure.statusCode == 503) return ChatErrorKind.unavailable;
    final cause = failure.cause;
    if (cause is DioException) {
      return switch (cause.type) {
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => ChatErrorKind.timeout,
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError => ChatErrorKind.network,
        _ => ChatErrorKind.unknown,
      };
    }
    return ChatErrorKind.unknown;
  }
}

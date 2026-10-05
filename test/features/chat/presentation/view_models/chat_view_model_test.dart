import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_view_model.dart';

void main() {
  late _FakeChatRepository repository;
  late _TestAuthTokenStore tokenStore;
  late ProviderContainer container;
  late ChatViewModel viewModel;

  setUp(() {
    repository = _FakeChatRepository();
    tokenStore = _TestAuthTokenStore();
    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(repository),
        authTokenStoreProvider.overrideWith(() => tokenStore),
        apiClientProvider.overrideWith((ref) {
          throw StateError('Unexpected API access in chat test');
        }),
      ],
    );
    container.listen(chatViewModelProvider, (previous, next) {});
    viewModel = container.read(chatViewModelProvider.notifier);
  });

  tearDown(() => container.dispose());

  const firstSession = ChatSession(
    id: 12,
    title: '상품 리뷰',
    productId: 'kurly-1',
  );
  const secondSession = ChatSession(id: 13, title: '일반 질문');
  const historyMessages = [
    ChatMessage(id: 21, role: ChatRole.user, content: '이전 질문'),
    ChatMessage(
      id: 22,
      role: ChatRole.assistant,
      content: '이전 답변',
      blocked: true,
      blockReason: '차단 이유',
    ),
  ];

  test('loads history pages once and stops at the last page', () async {
    repository.sessions = const Success(
      ChatSessionPage(items: [firstSession], page: 0, isLast: false),
    );
    await viewModel.showHistory();
    expect(container.read(chatViewModelProvider).isHistoryOpen, isTrue);
    final pending = Completer<Result<ChatSessionPage>>();
    repository.pendingSessions = pending;
    final loading = viewModel.loadMoreSessions();
    await viewModel.loadMoreSessions();
    expect(repository.pages, [0, 1]);
    pending.complete(
      const Success(
        ChatSessionPage(
          items: [firstSession, secondSession],
          page: 1,
          isLast: true,
        ),
      ),
    );
    await loading;
    await viewModel.loadMoreSessions();
    final state = container.read(chatViewModelProvider);
    expect(state.sessions.map((s) => s.id), [12, 13]);
    expect(state.sessionsPage, 1);
    expect(state.isLastSessionPage, isTrue);
    expect(repository.pages, [0, 1]);
  });

  test('reports history failures and allows retry', () async {
    repository.sessions = const FailureResult(Failure(message: '목록 오류'));
    await viewModel.showHistory();
    expect(container.read(chatViewModelProvider).historyError, '목록 오류');
    expect(container.read(chatViewModelProvider).isLoadingSessions, isFalse);
    repository.sessions = const Success(
      ChatSessionPage(items: [firstSession], page: 0, isLast: true),
    );
    await viewModel.showHistory();
    expect(container.read(chatViewModelProvider).historyError, isNull);
    expect(container.read(chatViewModelProvider).sessions, [firstSession]);
  });

  test(
    'resumes messages and sends the next question to the same session',
    () async {
      viewModel.open();
      repository.messages = const Success(historyMessages);
      await viewModel.resumeSession(firstSession);
      final restored = container.read(chatViewModelProvider);
      expect(restored.isOpen, isTrue);
      expect(restored.isHistoryOpen, isFalse);
      expect(restored.sessionId, 12);
      expect(restored.sessionProductId, 'kurly-1');
      expect(restored.messages, historyMessages);
      expect(restored.messages.last.blocked, isTrue);
      expect(restored.messages.last.blockReason, '차단 이유');
      await viewModel.send('후속 질문', productId: 'kurly-2');
      expect(repository.requests.single, (
        question: '후속 질문',
        sessionId: 12,
        productId: null,
      ));
    },
  );

  test(
    'general history clears the previous product and failed question',
    () async {
      await viewModel.send('실패 질문', productId: 'kurly-1');
      repository.result = const FailureResult(Failure(message: '실패'));
      await viewModel.send('다시 질문');
      await viewModel.resumeSession(secondSession);
      final state = container.read(chatViewModelProvider);
      expect(state.sessionId, 13);
      expect(state.sessionProductId, isNull);
      expect(state.lastFailedQuestion, isNull);
      expect(state.messages, isEmpty);
    },
  );

  test('failed restoration preserves the current conversation', () async {
    await viewModel.send('현재 질문', productId: 'kurly-1');
    repository.messages = const FailureResult(Failure(message: '복원 오류'));
    await viewModel.resumeSession(secondSession);
    final state = container.read(chatViewModelProvider);
    expect(state.sessionId, 7);
    expect(state.messages, hasLength(2));
    expect(state.historyError, '복원 오류');
    expect(state.isLoadingMessages, isFalse);
    viewModel.closeHistory();
    expect(container.read(chatViewModelProvider).historyError, isNull);
  });

  test('logout clears history and ignores a late session list', () async {
    repository.pendingSessions = Completer<Result<ChatSessionPage>>();
    final loading = viewModel.showHistory();
    tokenStore.setLoggedIn(false);
    await container.pump();
    repository.pendingSessions!.complete(
      const Success(
        ChatSessionPage(items: [firstSession], page: 0, isLast: true),
      ),
    );
    await loading;
    expect(container.read(chatViewModelProvider).sessions, isEmpty);
    expect(container.read(chatViewModelProvider).isHistoryOpen, isFalse);
    await viewModel.showHistory();
    expect(repository.pages, [0]);
  });

  test('logout ignores messages completing after logging in again', () async {
    repository.pendingMessages = Completer<Result<List<ChatMessage>>>();
    final restoring = viewModel.resumeSession(firstSession);
    tokenStore.setLoggedIn(false);
    await container.pump();
    tokenStore.setLoggedIn(true);
    await container.pump();
    repository.pendingMessages!.complete(const Success(historyMessages));
    await restoring;
    expect(container.read(chatViewModelProvider).messages, isEmpty);
    expect(container.read(chatViewModelProvider).sessionId, isNull);
  });

  test('latest selected session wins over an older restoration', () async {
    final pending = Completer<Result<List<ChatMessage>>>();
    repository.pendingMessages = pending;
    final first = viewModel.resumeSession(firstSession);
    repository.pendingMessages = null;
    await viewModel.resumeSession(secondSession);
    pending.complete(const Success(historyMessages));
    await first;
    expect(container.read(chatViewModelProvider).sessionId, 13);
    expect(container.read(chatViewModelProvider).messages, isEmpty);
  });

  for (final action in ['back', 'new']) {
    test('$action cancels an in-flight restoration', () async {
      repository.pendingMessages = Completer<Result<List<ChatMessage>>>();
      final restoring = viewModel.resumeSession(firstSession);
      if (action == 'back') {
        viewModel.closeHistory();
      } else {
        viewModel.startNew(productId: 'kurly-2');
      }
      repository.pendingMessages!.complete(const Success(historyMessages));
      await restoring;
      expect(container.read(chatViewModelProvider).sessionId, isNull);
      expect(container.read(chatViewModelProvider).messages, isEmpty);
      expect(container.read(chatViewModelProvider).isHistoryOpen, isFalse);
    });
  }

  test('does not send while history is open or browse while sending', () async {
    await viewModel.showHistory();
    await viewModel.send('목록 중 질문');
    expect(repository.requests, isEmpty);
    viewModel.closeHistory();
    repository.pending = Completer<Result<ChatReply>>();
    final sending = viewModel.send('전송 질문');
    await viewModel.showHistory();
    await viewModel.resumeSession(firstSession);
    expect(repository.pages, [0]);
    expect(repository.messageRequests, isEmpty);
    repository.pending!.complete(_reply);
    await sending;
  });

  test('stores user and assistant messages and session on success', () async {
    await viewModel.send('  리뷰를 설명해 주세요  ', productId: 'kurly-1');

    final state = container.read(chatViewModelProvider);
    expect(state.sessionId, 7);
    expect(state.sessionProductId, 'kurly-1');
    expect(state.isSending, isFalse);
    expect(state.lastFailedQuestion, isNull);
    expect(state.messages.map((message) => message.role), [
      ChatRole.user,
      ChatRole.assistant,
    ]);
    expect(state.messages.map((message) => message.content), [
      '리뷰를 설명해 주세요',
      '리뷰 분석 답변',
    ]);
    expect(repository.requests.single, (
      question: '리뷰를 설명해 주세요',
      sessionId: null,
      productId: 'kurly-1',
    ));
  });

  test('passes product only for a new session and keeps its context', () async {
    await viewModel.send('첫 질문', productId: 'kurly-1');
    await viewModel.send('두 번째 질문', productId: 'kurly-2');

    expect(repository.requests.last, (
      question: '두 번째 질문',
      sessionId: 7,
      productId: null,
    ));
    final state = container.read(chatViewModelProvider);
    expect(state.sessionProductId, 'kurly-1');
    expect(state.messages, hasLength(4));
  });

  test(
    'removes only the failed question and stores an error and retry text',
    () async {
      await viewModel.send('첫 질문', productId: 'kurly-1');
      repository.result = const FailureResult(Failure(message: '전송 실패'));

      await viewModel.send('실패 질문', productId: 'kurly-2');

      final state = container.read(chatViewModelProvider);
      expect(state.messages.map((message) => message.content), [
        '첫 질문',
        '리뷰 분석 답변',
        '전송 실패',
      ]);
      expect(state.messages.last.role, ChatRole.assistant);
      expect(state.messages.last.error, ChatErrorKind.unknown);
      expect(state.lastFailedQuestion, '실패 질문');
      expect(state.isSending, isFalse);
      expect(state.sessionId, 7);
      expect(state.sessionProductId, 'kurly-1');
    },
  );

  test(
    'retries a failed new-session question without keeping the error',
    () async {
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('다시 질문', productId: 'kurly-1');
      repository.result = _reply;

      await viewModel.retry(productId: 'kurly-1');

      expect(repository.requests, hasLength(2));
      expect(repository.requests.last, repository.requests.first);
      final state = container.read(chatViewModelProvider);
      expect(state.messages.map((message) => message.content), [
        '다시 질문',
        '리뷰 분석 답변',
      ]);
      expect(state.messages.every((message) => message.error == null), isTrue);
      expect(state.lastFailedQuestion, isNull);
      expect(state.sessionId, 7);
      expect(state.sessionProductId, 'kurly-1');
    },
  );

  test(
    'retries within an existing session without passing another product',
    () async {
      await viewModel.send('첫 질문', productId: 'kurly-1');
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('추가 질문', productId: 'kurly-2');
      repository.result = _reply;

      await viewModel.retry(productId: 'kurly-2');

      expect(repository.requests.last, (
        question: '추가 질문',
        sessionId: 7,
        productId: null,
      ));
      expect(container.read(chatViewModelProvider).messages, hasLength(4));
      expect(container.read(chatViewModelProvider).sessionProductId, 'kurly-1');
      expect(container.read(chatViewModelProvider).lastFailedQuestion, isNull);
    },
  );

  test('does not retry without a failed question', () async {
    await viewModel.retry(productId: 'kurly-1');
    expect(repository.requests, isEmpty);
  });

  final errorCases = <({String name, Failure failure, ChatErrorKind kind})>[
    (
      name: '503',
      failure: const Failure(message: 'unavailable', statusCode: 503),
      kind: ChatErrorKind.unavailable,
    ),
    (
      name: 'receiveTimeout',
      failure: Failure(
        message: 'timeout',
        cause: DioException(
          requestOptions: RequestOptions(path: '/api/chat/messages'),
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      kind: ChatErrorKind.timeout,
    ),
    (
      name: 'connectionError',
      failure: Failure(
        message: 'network',
        cause: DioException(
          requestOptions: RequestOptions(path: '/api/chat/messages'),
          type: DioExceptionType.connectionError,
        ),
      ),
      kind: ChatErrorKind.network,
    ),
  ];

  for (final errorCase in errorCases) {
    test('maps ${errorCase.name} to its error kind', () async {
      repository.result = FailureResult(errorCase.failure);
      await viewModel.send('질문');

      final state = container.read(chatViewModelProvider);
      expect(state.messages, hasLength(1));
      expect(state.messages.single.role, ChatRole.assistant);
      expect(state.messages.single.error, errorCase.kind);
      expect(state.messages.single.content, errorCase.failure.message);
      expect(state.lastFailedQuestion, '질문');
      expect(state.isSending, isFalse);
    });
  }

  test(
    'stores a blocked reply and its reason without a transport error',
    () async {
      repository.result = const Success(
        ChatReply(
          sessionId: 9,
          answer: '리뷰에 관한 질문을 해 주세요',
          blocked: true,
          blockReason: 'OFF_TOPIC',
        ),
      );
      await viewModel.send('차단 질문');

      final state = container.read(chatViewModelProvider);
      expect(state.sessionId, 9);
      expect(state.messages.last.content, '리뷰에 관한 질문을 해 주세요');
      expect(state.messages.last.blocked, isTrue);
      expect(state.messages.last.blockReason, 'OFF_TOPIC');
      expect(state.messages.last.error, isNull);
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);
    },
  );

  test(
    'starts a new conversation and clears session, messages and failure',
    () async {
      viewModel.open();
      await viewModel.send('첫 질문', productId: 'kurly-1');
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('실패 질문');

      viewModel.startNew(productId: 'kurly-2');

      final state = container.read(chatViewModelProvider);
      expect(state.isOpen, isTrue);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, 'kurly-2');
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);

      repository.result = _reply;
      await viewModel.send('새 질문', productId: 'kurly-2');
      expect(repository.requests.last.sessionId, isNull);
      expect(repository.requests.last.productId, 'kurly-2');
      viewModel.startNew();
      expect(container.read(chatViewModelProvider).sessionProductId, isNull);
    },
  );

  test(
    'ignores a duplicate send and a new conversation while sending',
    () async {
      final pending = Completer<Result<ChatReply>>();
      repository.pending = pending;
      final sending = viewModel.send('첫 질문', productId: 'kurly-1');

      expect(container.read(chatViewModelProvider).isSending, isTrue);
      await viewModel.send('중복 질문', productId: 'kurly-2');
      viewModel.startNew(productId: 'kurly-2');
      expect(repository.requests, hasLength(1));
      expect(
        container.read(chatViewModelProvider).messages.single.content,
        '첫 질문',
      );
      expect(container.read(chatViewModelProvider).sessionProductId, 'kurly-1');

      pending.complete(_reply);
      await sending;
      expect(container.read(chatViewModelProvider).messages, hasLength(2));
      expect(container.read(chatViewModelProvider).isSending, isFalse);
    },
  );

  test('ignores an empty question', () async {
    await viewModel.send('  \n  ', productId: 'kurly-1');
    expect(repository.requests, isEmpty);
    expect(container.read(chatViewModelProvider).messages, isEmpty);
  });

  test(
    'clears the conversation on logout and preserves the open panel',
    () async {
      viewModel.open();
      await viewModel.send('첫 질문', productId: 'kurly-1');
      repository.result = const FailureResult(Failure(message: '전송 실패'));
      await viewModel.send('실패 질문');

      tokenStore.setLoggedIn(false);
      await container.pump();

      final state = container.read(chatViewModelProvider);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, isNull);
      expect(state.lastFailedQuestion, isNull);
      expect(state.isSending, isFalse);
      expect(state.isOpen, isTrue);
    },
  );

  test(
    'does not restore a previous conversation when a reply arrives after logout',
    () async {
      final pending = Completer<Result<ChatReply>>();
      repository.pending = pending;
      final sending = viewModel.send('로그아웃 전 질문', productId: 'kurly-1');
      tokenStore.setLoggedIn(false);
      await container.pump();
      expect(container.read(chatViewModelProvider).messages, isEmpty);

      pending.complete(_reply);
      await sending;

      final state = container.read(chatViewModelProvider);
      expect(state.messages, isEmpty);
      expect(state.sessionId, isNull);
      expect(state.sessionProductId, isNull);
    },
  );

  ChatQuota quotaOf({
    String plan = 'FREE',
    int limit = 5,
    int remaining = 3,
    bool pro = false,
    DateTime? resetAt,
  }) => ChatQuota(
    planCode: plan,
    dailyLimit: limit,
    usedToday: limit - remaining,
    remaining: remaining,
    proAvailable: pro,
    resetAt: resetAt ?? DateTime.now().add(const Duration(hours: 3)),
  );

  test(
    'loads the quota when the panel opens and keeps it across a new chat',
    () async {
      repository.quota = Success(quotaOf());
      viewModel.open();
      await container.pump();
      expect(repository.quotaRequests, 1);
      expect(container.read(chatViewModelProvider).quota?.remaining, 3);

      viewModel.startNew(productId: 'kurly-2');
      expect(container.read(chatViewModelProvider).quota?.remaining, 3);
    },
  );

  test('leaves the quota unknown when it cannot be loaded', () async {
    viewModel.open();
    await container.pump();
    expect(container.read(chatViewModelProvider).quota, isNull);

    await viewModel.send('질문');
    expect(repository.requests, hasLength(1));
  });

  test('replaces the quota with the one returned by a reply', () async {
    repository.quota = Success(quotaOf(remaining: 3));
    await viewModel.refreshQuota();
    repository.pending = Completer()
      ..complete(
        Success(
          ChatReply(
            sessionId: 7,
            answer: '답변',
            blocked: false,
            quota: quotaOf(remaining: 2),
          ),
        ),
      );
    await viewModel.send('질문');
    expect(container.read(chatViewModelProvider).quota?.remaining, 2);
  });

  test('does not send once the daily quota is used up', () async {
    repository.quota = Success(quotaOf(remaining: 0));
    await viewModel.refreshQuota();
    await viewModel.send('질문');
    expect(repository.requests, isEmpty);
  });

  test('sends again after the reset time has passed', () async {
    repository.quota = Success(
      quotaOf(
        remaining: 0,
        resetAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    );
    await viewModel.refreshQuota();
    await viewModel.send('질문');
    expect(repository.requests, hasLength(1));
  });

  test('treats -1 as unlimited', () async {
    repository.quota = Success(quotaOf(limit: -1, remaining: -1));
    await viewModel.refreshQuota();
    await viewModel.send('질문');
    expect(repository.requests, hasLength(1));
  });

  test('selects pro mode only when the server allows it', () async {
    repository.quota = Success(quotaOf());
    await viewModel.refreshQuota();
    viewModel.setMode(ChatMode.pro);
    expect(container.read(chatViewModelProvider).mode, ChatMode.standard);

    repository.quota = Success(quotaOf(plan: 'PRO', limit: 300, pro: true));
    await viewModel.refreshQuota();
    viewModel.setMode(ChatMode.pro);
    await viewModel.send('질문');
    expect(repository.modes.single, ChatMode.pro);
  });

  test(
    'falls back to standard mode when the plan no longer allows pro',
    () async {
      repository.quota = Success(quotaOf(plan: 'PRO', limit: 300, pro: true));
      await viewModel.refreshQuota();
      viewModel.setMode(ChatMode.pro);
      repository.pending = Completer()
        ..complete(
          const FailureResult(
            Failure(
              message: '프로 요금제 필요',
              code: 'CHAT_PLAN_REQUIRED',
              statusCode: 403,
            ),
          ),
        );
      repository.quota = Success(quotaOf());
      await viewModel.send('질문');
      await container.pump();

      final state = container.read(chatViewModelProvider);
      expect(state.messages.single.error, ChatErrorKind.planRequired);
      expect(state.mode, ChatMode.standard);
      expect(state.quota?.proAvailable, isFalse);
      expect(state.lastFailedQuestion, '질문');
    },
  );

  test('maps a quota error by its code and refreshes the quota', () async {
    repository.pending = Completer()
      ..complete(
        const FailureResult(
          Failure(
            message: '한도 초과',
            code: 'CHAT_QUOTA_EXCEEDED',
            statusCode: 429,
          ),
        ),
      );
    repository.quota = Success(quotaOf(remaining: 0));
    await viewModel.send('질문');
    await container.pump();

    final state = container.read(chatViewModelProvider);
    expect(state.messages.single.error, ChatErrorKind.quotaExceeded);
    expect(state.quota?.remaining, 0);
  });

  test('does not treat another 403 as a plan restriction', () async {
    repository.pending = Completer()
      ..complete(
        const FailureResult(
          Failure(message: '권한 없음', code: 'UNAUTHORIZED', statusCode: 403),
        ),
      );
    await viewModel.send('질문');
    expect(
      container.read(chatViewModelProvider).messages.single.error,
      ChatErrorKind.unknown,
    );
  });

  test('a late quota lookup does not overwrite the one from a reply', () async {
    final lookup = Completer<Result<ChatQuota>>();
    repository.pendingQuota = lookup;
    final refreshing = viewModel.refreshQuota();

    repository.pending = Completer()
      ..complete(
        Success(
          ChatReply(
            sessionId: 7,
            answer: '답변',
            blocked: false,
            quota: quotaOf(remaining: 0),
          ),
        ),
      );
    await viewModel.send('마지막 질문');
    lookup.complete(Success(quotaOf(remaining: 1)));
    await refreshing;

    expect(container.read(chatViewModelProvider).quota?.remaining, 0);
  });

  test(
    'stops sending after a 429 even when the quota cannot be reloaded',
    () async {
      repository.quota = Success(quotaOf(remaining: 1));
      await viewModel.refreshQuota();
      repository.quota = const FailureResult(Failure(message: '네트워크 오류'));
      repository.pending = Completer()
        ..complete(
          const FailureResult(
            Failure(message: '', code: 'CHAT_QUOTA_EXCEEDED', statusCode: 429),
          ),
        );
      await viewModel.send('질문');
      await container.pump();
      await viewModel.send('다시 질문');

      final state = container.read(chatViewModelProvider);
      expect(repository.requests, hasLength(1));
      expect(state.limitReached, isTrue);
      // 남은 횟수는 서버가 알려 준 값 그대로 두고 지어내지 않는다.
      expect(state.quota?.remaining, 1);

      repository.quota = Success(quotaOf(remaining: 5));
      await viewModel.refreshQuota();
      expect(container.read(chatViewModelProvider).limitReached, isFalse);
    },
  );

  test(
    'keeps pro locked after a 403 until the quota is confirmed again',
    () async {
      repository.quota = Success(quotaOf(plan: 'PRO', limit: 300, pro: true));
      await viewModel.refreshQuota();
      viewModel.setMode(ChatMode.pro);
      repository.quota = const FailureResult(Failure(message: '네트워크 오류'));
      repository.pending = Completer()
        ..complete(
          const FailureResult(
            Failure(message: '', code: 'CHAT_PLAN_REQUIRED', statusCode: 403),
          ),
        );
      await viewModel.send('질문');
      await container.pump();

      viewModel.setMode(ChatMode.pro);
      expect(container.read(chatViewModelProvider).mode, ChatMode.standard);
      expect(container.read(chatViewModelProvider).canUsePro, isFalse);

      repository.pending = null;
      await viewModel.retry();
      expect(repository.modes, [ChatMode.pro, ChatMode.standard]);
    },
  );

  test('clears the quota on logout', () async {
    repository.quota = Success(quotaOf());
    await viewModel.refreshQuota();
    tokenStore.setLoggedIn(false);
    await container.pump();
    expect(container.read(chatViewModelProvider).quota, isNull);
  });

  test('ignores a failed request that completes after logout', () async {
    final pending = Completer<Result<ChatReply>>();
    repository.pending = pending;
    final sending = viewModel.send('로그아웃 전 질문', productId: 'kurly-1');
    tokenStore.setLoggedIn(false);
    await container.pump();

    pending.complete(const FailureResult(Failure(message: '전송 실패')));
    await sending;

    final state = container.read(chatViewModelProvider);
    expect(state.messages, isEmpty);
    expect(state.lastFailedQuestion, isNull);
    expect(state.isSending, isFalse);
  });
}

const _reply = Success(
  ChatReply(sessionId: 7, answer: '리뷰 분석 답변', blocked: false),
);

typedef _Request = ({String question, int? sessionId, String? productId});

class _FakeChatRepository implements ChatRepository {
  Result<ChatQuota> quota = const FailureResult(Failure(message: 'no quota'));
  final List<ChatMode> modes = [];
  int quotaRequests = 0;

  Completer<Result<ChatQuota>>? pendingQuota;

  @override
  Future<Result<ChatQuota>> getQuota() async {
    quotaRequests++;
    return pendingQuota == null ? quota : await pendingQuota!.future;
  }

  Result<ChatSessionPage> sessions = const Success(
    ChatSessionPage(items: [], page: 0, isLast: true),
  );
  Result<List<ChatMessage>> messages = const Success([]);
  Completer<Result<ChatSessionPage>>? pendingSessions;
  Completer<Result<List<ChatMessage>>>? pendingMessages;
  final List<int> pages = [];
  final List<int> messageRequests = [];

  @override
  Future<Result<ChatSessionPage>> getSessions({
    required int page,
    required int size,
  }) async {
    pages.add(page);
    return pendingSessions == null ? sessions : await pendingSessions!.future;
  }

  @override
  Future<Result<List<ChatMessage>>> getSessionMessages(int sessionId) async {
    messageRequests.add(sessionId);
    return pendingMessages == null ? messages : await pendingMessages!.future;
  }

  Result<ChatReply> result = _reply;
  Completer<Result<ChatReply>>? pending;
  final List<_Request> requests = [];

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    String? productId,
    ChatMode mode = ChatMode.standard,
  }) async {
    modes.add(mode);
    requests.add((
      question: question,
      sessionId: sessionId,
      productId: productId,
    ));
    return pending == null ? result : await pending!.future;
  }
}

class _TestAuthTokenStore extends AuthTokenStore {
  @override
  bool build() => true;

  void setLoggedIn(bool value) => state = value;
}

import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_ask_button.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_overlay.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_panel.dart';
import 'package:re_view_front/features/chat/presentation/widgets/popup_route_tracker.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../../../helpers/pump_app.dart';
import '../../../external_product/external_product_fakes.dart';
import 'package:re_view_front/features/external_product/presentation/pages/external_product_page.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';

void main() {
  testWidgets('retries failed history and loads the next page', (tester) async {
    final repository = _FakeChatRepository()
      ..sessions = const FailureResult(Failure(message: '목록 오류'));
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryLoadError), findsOneWidget);
    repository.sessions = const Success(
      ChatSessionPage(
        items: [ChatSession(id: 12, title: '첫 대화')],
        page: 0,
        isLast: false,
      ),
    );
    await tester.tap(find.text(l10n.chatRetry));
    await tester.pumpAndSettle();
    expect(find.text('첫 대화'), findsOneWidget);
    expect(find.text(l10n.chatHistoryLoadError), findsNothing);
    repository.sessions = const Success(
      ChatSessionPage(
        items: [ChatSession(id: 13, title: '두 번째 대화')],
        page: 1,
        isLast: true,
      ),
    );
    await tester.tap(find.text(l10n.chatHistoryLoadMore));
    await tester.pumpAndSettle();
    expect(find.text('첫 대화'), findsOneWidget);
    expect(find.text('두 번째 대화'), findsOneWidget);
    expect(find.text(l10n.chatHistoryLoadMore), findsNothing);
    expect(repository.pages, [0, 0, 1]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history fits a narrow mobile panel', (tester) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryEmpty), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('browses history, restores a conversation and resumes sending', (
    tester,
  ) async {
    final repository = _FakeChatRepository()
      ..sessions = const Success(
        ChatSessionPage(
          items: [ChatSession(id: 12, title: '이전 상품 대화', productId: 'kurly-2')],
          page: 0,
          isLast: true,
        ),
      )
      ..messages = const Success([
        ChatMessage(role: ChatRole.user, content: '예전 질문'),
        ChatMessage(role: ChatRole.assistant, content: '예전 답변'),
      ]);
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/1',
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text('이전 상품 대화'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(repository.pages, [0]);
    await tester.tap(find.text('이전 상품 대화'));
    await tester.pumpAndSettle();
    expect(find.text('예전 질문'), findsOneWidget);
    expect(find.text('예전 답변'), findsOneWidget);
    expect(find.text(l10n.chatOtherProductNotice), findsOneWidget);
    expect(subject.container.read(chatViewModelProvider).sessionId, 12);
    await tester.enterText(find.byType(TextField), '이어 질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(repository.requests.single, (
      question: '이어 질문',
      sessionId: 12,
      productId: null,
    ));
    expect(find.text('리뷰 분석 답변'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty history and returns to the conversation', (
    tester,
  ) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryEmpty), findsOneWidget);
    await tester.tap(find.byTooltip(l10n.chatBackToConversation));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final path in [
    RoutePaths.landing,
    RoutePaths.login,
    RoutePaths.admin,
    RoutePaths.resetPassword,
    RoutePaths.passwordReset,
  ]) {
    testWidgets('hides the launcher on $path', (tester) async {
      await _pumpOverlay(tester, path: path);

      final l10n = _localizations(tester);
      expect(find.byTooltip(l10n.chatLauncherTooltip), findsNothing);
      expect(find.byType(ChatPanel), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final path in [RoutePaths.home, '/product/kurly/1']) {
    testWidgets('shows the launcher on $path', (tester) async {
      await _pumpOverlay(tester, path: path);

      final l10n = _localizations(tester);
      expect(
        find.byTooltip(l10n.chatLauncherTooltip).hitTestable(),
        findsOneWidget,
      );
      expect(find.byType(ChatPanel), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hides the launcher while a dialog is open', (tester) async {
    final subject = await _pumpOverlay(tester, path: RoutePaths.home);
    final l10n = _localizations(tester);
    final launcher = find.byTooltip(l10n.chatLauncherTooltip);
    expect(launcher, findsOneWidget);

    unawaited(
      showDialog<void>(
        context: subject.router.routerDelegate.navigatorKey.currentContext!,
        builder: (_) => const AlertDialog(content: Text('dialog')),
      ),
    );
    await tester.pumpAndSettle();
    expect(launcher, findsNothing);

    subject.router.routerDelegate.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(launcher, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a login prompt when opened while logged out', (
    tester,
  ) async {
    final subject = await _pumpOverlay(tester, path: RoutePaths.home);
    final l10n = _localizations(tester);

    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatLoginTitle), findsOneWidget);
    expect(find.text(l10n.chatLoginBody), findsOneWidget);
    expect(find.text(l10n.chatLoginButton), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(subject.repository.requests, isEmpty);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(l10n.chatLoginButton));
    await tester.pumpAndSettle();
    expect(
      subject.router.routeInformationProvider.value.uri.path,
      RoutePaths.login,
    );
    expect(subject.container.read(chatViewModelProvider).isOpen, isFalse);
    expect(find.byType(ChatPanel), findsNothing);
  });

  testWidgets('shows product question chips when logged in on a product page', (
    tester,
  ) async {
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/1',
      isLoggedIn: true,
    );
    final l10n = _localizations(tester);

    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatProductContext), findsOneWidget);
    expect(find.text(l10n.chatSuggestProduct1), findsOneWidget);
    expect(find.text(l10n.chatSuggestProduct2), findsOneWidget);
    expect(find.text(l10n.chatSuggestProduct3), findsOneWidget);
    expect(find.text(l10n.chatSuggestGeneral1), findsNothing);
    expect(find.text(l10n.chatLoginTitle), findsNothing);
    expect(subject.repository.requests, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the supplied external identifier alongside its v2 route', (
    tester,
  ) async {
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/route-id',
      isLoggedIn: true,
    );
    subject.router.go(
      '/product/kurly/route-id',
      extra: const ProductRouteContext(chatProductId: 'kurly-original-id'),
    );
    await tester.pumpAndSettle();
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.chatSuggestProduct1));
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(subject.repository.requests.single.productId, 'kurly-original-id');
  });

  testWidgets('decodes an escaped external product ID before sending', (
    tester,
  ) async {
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/a-b%2Fc%20%25',
      isLoggedIn: true,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.chatSuggestProduct1));
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(subject.repository.requests.single.productId, 'kurly-a-b/c %');
  });

  testWidgets('sends a product chip question and displays the reply', (
    tester,
  ) async {
    final pending = Completer<Result<ChatReply>>();
    final repository = _FakeChatRepository()..pending = pending;
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/1',
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    // 추천 질문은 입력창에 채워지고, 보내기를 눌러야 전송된다.
    await tester.tap(find.text(l10n.chatSuggestProduct1));
    await tester.pump();
    expect(repository.requests, isEmpty);
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pump();

    expect(repository.requests.single, (
      question: l10n.chatSuggestProduct1,
      sessionId: null,
      productId: 'kurly-1',
    ));
    expect(subject.container.read(chatViewModelProvider).isSending, isTrue);
    expect(find.text(l10n.chatThinking), findsOneWidget);
    expect(find.text(l10n.chatSuggestProduct1), findsOneWidget);

    pending.complete(_reply);
    await tester.pumpAndSettle();

    expect(find.text('리뷰 분석 답변'), findsOneWidget);
    expect(find.text(l10n.chatThinking), findsNothing);
    expect(subject.container.read(chatViewModelProvider).sessionId, 7);
    expect(subject.container.read(chatViewModelProvider).isSending, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the plan and remaining questions from the server', (
    tester,
  ) async {
    final repository = _FakeChatRepository()..quota = Success(_quota());
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatPlanFree), findsOneWidget);
    expect(find.text(l10n.chatQuotaRemaining(3, 5)), findsOneWidget);
    // 보내기 버튼은 입력 상자 오른쪽 끝에 붙는다.
    expect(
      tester.getTopRight(find.byType(TextField)).dx -
          tester.getTopRight(find.byTooltip(l10n.chatSend)).dx,
      lessThan(4),
    );
    expect(find.text(l10n.chatModeStandard), findsOneWidget);

    // 무료 요금제는 프로 모드를 고를 수 없고 안내만 본다.
    await tester.tap(find.text(l10n.chatModePro));
    await tester.pump();
    expect(find.text(l10n.chatModeProLocked), findsOneWidget);
    await tester.enterText(find.byType(TextField), '질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(repository.modes.single, ChatMode.standard);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hides plan and quota when the server has not answered', (
    tester,
  ) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatPlanFree), findsNothing);
    expect(find.text(l10n.chatModePro), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('sends through pro mode on a pro plan', (tester) async {
    final repository = _FakeChatRepository()
      ..quota = Success(
        _quota(plan: 'PRO', limit: 300, remaining: 280, pro: true),
      );
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    // 헤더 배지와 모드 선택에 한 번씩 나온다.
    expect(find.text(l10n.chatPlanPro), findsNWidgets(2));

    await tester.tap(find.text(l10n.chatModePro).last);
    await tester.pump();
    expect(find.text(l10n.chatModeProActive), findsOneWidget);
    await tester.enterText(find.byType(TextField), '질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(repository.modes.single, ChatMode.pro);
  });

  testWidgets('blocks the input when today\'s questions are used up', (
    tester,
  ) async {
    final repository = _FakeChatRepository()
      ..quota = Success(_quota(remaining: 0));
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.textContaining(l10n.chatQuotaExceededTitle), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows blocked, quota and plan notices in the conversation', (
    tester,
  ) async {
    final repository = _FakeChatRepository()..quota = Success(_quota());
    final subject = await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    final vm = subject.container.read(chatViewModelProvider.notifier);

    repository.pending = Completer()
      ..complete(
        const Success(
          ChatReply(
            sessionId: 7,
            answer: '상품과 리뷰에 관한 질문만 답해요',
            blocked: true,
            blockReason: 'OFF_TOPIC',
          ),
        ),
      );
    await vm.send('날씨');
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatBlockedTitle), findsOneWidget);
    expect(find.byTooltip(l10n.chatCopy), findsNothing);

    repository.pending = Completer()
      ..complete(
        const FailureResult(
          Failure(message: '', code: 'CHAT_PLAN_REQUIRED', statusCode: 403),
        ),
      );
    await vm.send('프로 질문');
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatPlanRequiredTitle), findsOneWidget);
    expect(find.text(l10n.chatPlanRequiredAction), findsOneWidget);

    repository.pending = Completer()
      ..complete(
        const FailureResult(
          Failure(message: '', code: 'CHAT_QUOTA_EXCEEDED', statusCode: 429),
        ),
      );
    await vm.send('한도 질문');
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatQuotaExceededTitle), findsOneWidget);
    expect(find.text(l10n.chatRetry), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a suggestion fills the input, keeps focus and sends on enter', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    final repository = _FakeChatRepository();
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.chatSuggestGeneral1));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, l10n.chatSuggestGeneral1);
    expect(field.focusNode!.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(repository.requests.single.question, l10n.chatSuggestGeneral1);
    debugDefaultTargetPlatformOverride = null;
  });

  for (final (locale, scale) in [
    (const Locale('en'), 1.0),
    (const Locale('en'), 2.0),
    (const Locale('ja'), 2.0),
    (const Locale('zh'), 2.0),
  ]) {
    testWidgets('composer fits a 320px screen in $locale at ${scale}x', (
      tester,
    ) async {
      final repository = _FakeChatRepository()..quota = Success(_quota());
      await _pumpOverlay(
        tester,
        path: RoutePaths.home,
        isLoggedIn: true,
        repository: repository,
        size: const Size(320, 700),
        locale: locale,
        textScale: scale,
      );
      final l10n = _localizations(tester);
      await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'a' * 400);
      await tester.pumpAndSettle();

      expect(find.text('400/500'), findsOneWidget);
      expect(find.byTooltip(l10n.chatSend), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('counts length the way the server does', (tester) async {
    final repository = _FakeChatRepository();
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    // 이모지 251개는 화면 글자로는 251자지만 서버 기준으로는 502자다.
    await tester.enterText(find.byType(TextField), '😀' * 251);
    await tester.pump();
    expect(find.text('502/500'), findsOneWidget);
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pump();
    expect(repository.requests, isEmpty);
  });

  testWidgets('reopens the input once the reset time passes', (tester) async {
    final repository = _FakeChatRepository()
      ..quota = Success(
        ChatQuota(
          planCode: 'FREE',
          dailyLimit: 5,
          usedToday: 5,
          remaining: 0,
          proAvailable: false,
          resetAt: DateTime.now().add(const Duration(seconds: 3)),
        ),
      );
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.runAsync(() async {
      await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);

      repository.quota = Success(_quota(remaining: 5));
      await Future<void>.delayed(const Duration(seconds: 5));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
    });
    expect(repository.quotaRequests, 2);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
    expect(find.text(l10n.chatQuotaRemaining(5, 5)), findsOneWidget);
  });

  testWidgets('keeps the panel on screen in a short window', (tester) async {
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: false,
      size: const Size(1280, 260),
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    tester.takeException();
    expect(
      tester.getTopLeft(find.byType(ChatPanel)).dy,
      greaterThanOrEqualTo(0),
    );
    expect(find.byTooltip(l10n.chatClose).hitTestable(), findsOneWidget);
  });

  testWidgets('links to the plan page when the limit is reached', (
    tester,
  ) async {
    final repository = _FakeChatRepository()
      ..quota = Success(_quota(remaining: 0));
    final subject = await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.chatViewPlans));
    await tester.pumpAndSettle();
    expect(
      subject.router.routerDelegate.currentConfiguration.uri.path,
      RoutePaths.plan,
    );
  });

  testWidgets('links to the plan page from the locked pro mode', (
    tester,
  ) async {
    final repository = _FakeChatRepository()..quota = Success(_quota());
    final subject = await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.chatModePro));
    await tester.pump();
    await tester.tap(find.text(l10n.chatViewPlans));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(
      subject.router.routerDelegate.currentConfiguration.uri.path,
      RoutePaths.plan,
    );
  });

  testWidgets('talks without a product on a legacy product page', (
    tester,
  ) async {
    final repository = _FakeChatRepository();
    await _pumpOverlay(
      tester,
      path: '/product/900000000027',
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    // 챗봇이 찾을 수 없는 상품이라 상품 안내와 상품 질문을 보여 주지 않는다.
    expect(find.text(l10n.chatProductContext), findsNothing);
    expect(find.text(l10n.chatSuggestGeneral1), findsOneWidget);
    await tester.enterText(find.byType(TextField), '질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(repository.requests.single.productId, isNull);
  });

  testWidgets('copies an answer', (tester) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    final l10n = _localizations(tester);
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(l10n.chatCopy));
    await tester.pump();
    expect(copied, '리뷰 분석 답변');
    expect(find.byTooltip(l10n.chatCopied), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  for (final size in [const Size(1280, 1000), const Size(390, 850)]) {
    testWidgets('detail CTA opens visible product chat at $size', (
      tester,
    ) async {
      final subject = await _pumpOverlay(
        tester,
        path: '/product/kurly/1000146248',
        size: size,
        isLoggedIn: true,
        productPage: true,
      );
      final l10n = _localizations(tester);
      await tester.ensureVisible(find.byType(ChatAskButton));
      await tester.tap(find.byType(ChatAskButton));
      await tester.pumpAndSettle();
      expect(find.byType(ChatPanel), findsOneWidget);
      expect(find.text(l10n.chatProductContext), findsOneWidget);
      await tester.tap(find.text(l10n.chatSuggestProduct1));
      await tester.pump();
      await tester.tap(find.byTooltip(l10n.chatSend));
      await tester.pumpAndSettle();
      expect(subject.repository.requests.single.productId, 'kurly-1000146248');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('detail CTA opens with keyboard and resumes after a modal', (
    tester,
  ) async {
    final subject = await _pumpOverlay(
      tester,
      path: '/product/kurly/1000146248',
      productPage: true,
    );
    final l10n = _localizations(tester);
    Focus.of(tester.element(find.text(l10n.chatProductCta))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(ChatPanel), findsOneWidget);
    expect(find.text(l10n.chatLoginTitle), findsOneWidget);
    unawaited(
      showDialog<void>(
        context: subject.router.routerDelegate.navigatorKey.currentContext!,
        builder: (_) => const AlertDialog(content: Text('modal')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ChatPanel), findsNothing);
    subject.router.routerDelegate.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(ChatPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'detail CTA leaves history and opens a blank product conversation',
    (tester) async {
      final subject = await _pumpOverlay(
        tester,
        path: '/product/kurly/1000146248',
        isLoggedIn: true,
        productPage: true,
      );
      final l10n = _localizations(tester);
      final vm = subject.container.read(chatViewModelProvider.notifier);
      vm.open();
      await vm.send('question', productId: 'kurly-other');
      await vm.showHistory();
      vm.close();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ChatAskButton));
      await tester.pumpAndSettle();
      expect(find.byType(ChatPanel), findsOneWidget);
      expect(find.text(l10n.chatOtherProductNotice), findsNothing);
      expect(
        subject.container.read(chatViewModelProvider).isHistoryOpen,
        isFalse,
      );
      expect(
        subject.container.read(chatViewModelProvider).sessionProductId,
        'kurly-1000146248',
      );
      expect(subject.container.read(chatViewModelProvider).messages, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'shows a notice when navigating to another product in a session',
    (tester) async {
      final subject = await _pumpOverlay(
        tester,
        path: '/product/kurly/1',
        isLoggedIn: true,
      );
      final l10n = _localizations(tester);
      await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.chatSuggestProduct1));
      await tester.pump();
      await tester.tap(find.byTooltip(l10n.chatSend));
      await tester.pumpAndSettle();

      subject.router.go('/product/kurly/2');
      await tester.pumpAndSettle();

      expect(find.text(l10n.chatOtherProductNotice), findsOneWidget);
      expect(find.text(l10n.chatStartWithThisProduct), findsOneWidget);
      expect(find.text('리뷰 분석 답변'), findsOneWidget);
      expect(
        subject.container.read(chatViewModelProvider).sessionProductId,
        'kurly-1',
      );
      expect(subject.repository.requests, hasLength(1));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(l10n.chatStartWithThisProduct));
      await tester.pumpAndSettle();
      expect(find.text(l10n.chatOtherProductNotice), findsNothing);
      expect(find.text(l10n.chatProductContext), findsOneWidget);
      expect(subject.container.read(chatViewModelProvider).messages, isEmpty);
      expect(
        subject.container.read(chatViewModelProvider).sessionProductId,
        'kurly-2',
      );
      await tester.tap(find.text(l10n.chatSuggestProduct1));
      await tester.pump();
      await tester.tap(find.byTooltip(l10n.chatSend));
      await tester.pumpAndSettle();
      expect(subject.repository.requests.last.productId, 'kurly-2');
      expect(subject.repository.requests.last.sessionId, isNull);
    },
  );
}

AppLocalizations _localizations(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(ChatOverlay)));
}

Future<
  ({
    ProviderContainer container,
    GoRouter router,
    _FakeChatRepository repository,
  })
>
_pumpOverlay(
  WidgetTester tester, {
  required String path,
  bool isLoggedIn = false,
  _FakeChatRepository? repository,
  Size size = const Size(1280, 1000),
  Locale? locale,
  double textScale = 1,
  bool productPage = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: path,
    observers: [popupRouteTracker],
    routes: [
      for (final route in [
        RoutePaths.home,
        RoutePaths.landing,
        RoutePaths.login,
        RoutePaths.admin,
        RoutePaths.resetPassword,
        RoutePaths.passwordReset,
        RoutePaths.productDetail,
        '/product/:platform/:id',
        RoutePaths.plan,
      ])
        GoRoute(
          path: route,
          builder: (context, state) =>
              productPage && state.uri.path.startsWith('/product/')
              ? const ExternalProductPage(productRef: kurlyRef)
              : const Scaffold(body: Text('route page')),
        ),
    ],
  );
  final fake = repository ?? _FakeChatRepository();
  final container = ProviderContainer(
    overrides: [
      externalProductRepositoryProvider.overrideWithValue(
        FakeExternalProductRepository(),
      ),
      appRouterProvider.overrideWithValue(router),
      isLoggedInProvider.overrideWithValue(isLoggedIn),
      chatRepositoryProvider.overrideWithValue(fake),
      apiClientProvider.overrideWith((ref) {
        throw StateError('Unexpected API access in chat overlay test');
      }),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(router.dispose);

  final app = localizedApp(router: router) as MaterialApp;
  await pumpApp(
    tester,
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: app.theme,
        locale: locale ?? app.locale,
        supportedLocales: app.supportedLocales,
        localizationsDelegates: app.localizationsDelegates,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: ChatOverlay(child: child!),
        ),
      ),
    ),
  );
  return (container: container, router: router, repository: fake);
}

ChatQuota _quota({
  String plan = 'FREE',
  int limit = 5,
  int remaining = 3,
  bool pro = false,
}) => ChatQuota(
  planCode: plan,
  dailyLimit: limit,
  usedToday: limit - remaining,
  remaining: remaining,
  proAvailable: pro,
  resetAt: DateTime.now().add(const Duration(hours: 3)),
);

const _reply = Success(
  ChatReply(sessionId: 7, answer: '리뷰 분석 답변', blocked: false),
);

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

  Completer<Result<ChatReply>>? pending;
  final List<({String question, int? sessionId, String? productId})> requests =
      [];

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
    return pending == null ? _reply : await pending!.future;
  }
}

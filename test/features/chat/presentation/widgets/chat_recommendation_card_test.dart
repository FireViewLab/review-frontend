import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_recommendation.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_recommendation_card.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import '../../../../helpers/pump_app.dart';

const recommendation = ChatRecommendation(
  ref: ExternalProductRef(platform: 'kurly', productId: '100-x'),
  name: '추천 상품',
);

Future<GoRouter> pumpBubble(WidgetTester tester, ChatMessage message) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(
          body: SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: ChatMessageBubble(message: message),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/product/:platform/:productId',
        builder: (_, state) {
          final summary = (state.extra as ProductRouteContext).summary!;
          return Scaffold(body: Text('상세 ${summary.product.name}'));
        },
      ),
    ],
  );
  addTearDown(router.dispose);
  await pumpApp(
    tester,
    ProviderScope(
      overrides: [appRouterProvider.overrideWithValue(router)],
      child: localizedApp(router: router),
    ),
  );
  return router;
}

void main() {
  testWidgets('empty, blocked and error answers have no recommendation area', (
    tester,
  ) async {
    for (final message in [
      const ChatMessage(role: ChatRole.assistant, content: '빈 답변'),
      const ChatMessage(
        role: ChatRole.assistant,
        content: '차단',
        blocked: true,
        recommendations: [recommendation],
      ),
      const ChatMessage(
        role: ChatRole.assistant,
        content: '실패',
        error: ChatErrorKind.network,
        recommendations: [recommendation],
      ),
    ]) {
      await pumpBubble(tester, message);
      expect(find.byType(ChatRecommendationCard), findsNothing);
      await tester.pumpWidget(const SizedBox());
    }
  });
  testWidgets(
    'null metrics hidden, zero rendered; card opens encoded detail with seed',
    (tester) async {
      final zero = ChatRecommendation(
        ref: const ExternalProductRef(platform: 'oliveyoung', productId: 'A-0'),
        name: '0원 상품',
        price: 0,
        reviewCount: 0,
        rating: 0,
      );
      final router = await pumpBubble(
        tester,
        ChatMessage(
          role: ChatRole.assistant,
          content: '추천 안내',
          recommendations: [recommendation, zero],
        ),
      );
      expect(find.byType(ChatRecommendationCard), findsNWidgets(2));
      expect(find.text('★ 0.0'), findsOneWidget);
      expect(find.text('★ null'), findsNothing);
      expect(find.textContaining('리뷰'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(ChatRecommendationCard).first);
      final container = ProviderScope.containerOf(context);
      await tester.tap(find.text('추천 상품'));
      await tester.pumpAndSettle();
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        '/product/kurly/100-x',
      );
      final extra =
          router.routerDelegate.currentConfiguration.extra
              as ProductRouteContext;
      expect(extra.chatProductId, 'kurly-100-x');
      expect(extra.summary!.product.name, '추천 상품');
      expect(extra.summary!.product.price, isNull);
      expect(
        container.read(productSummaryCacheProvider).get(recommendation.ref),
        isNotNull,
      );
      expect(find.text('상세 추천 상품'), findsOneWidget);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/pages/external_product_page.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../helpers/pump_app.dart';
import 'external_product_fakes.dart';

void main() {
  Future<FakeExternalProductRepository> pumpContent(
    WidgetTester tester, {
    FakeExternalProductRepository? repository,
    Size size = const Size(1280, 1000),
    Duration pollInterval = const Duration(milliseconds: 10),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fake = repository ?? FakeExternalProductRepository();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: SingleChildScrollView(
              child: ExternalProductContent(productRef: kurlyRef),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await pumpApp(
      tester,
      ProviderScope(
        overrides: [
          externalProductRepositoryProvider.overrideWithValue(fake),
          externalProductPollIntervalProvider.overrideWithValue(pollInterval),
          isLoggedInProvider.overrideWithValue(false),
        ],
        child: localizedApp(router: router),
      ),
    );
    await tester.pump();
    await tester.pump();
    return fake;
  }

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(ExternalProductContent)));

  testWidgets('shows the product, says analysis is pending and lists reviews', (
    tester,
  ) async {
    await pumpContent(tester);
    final l10n = l10nOf(tester);

    expect(find.text(kurlyProduct.name), findsOneWidget);
    expect(find.text(l10n.extProductPrice('17,000')), findsOneWidget);
    expect(find.text(l10n.extProductVisitShop('컬리')), findsOneWidget);
    expect(find.text(l10n.extProductReviewCount(1318)), findsOneWidget);
    // 분석이 없으면 점수를 지어내지 않고 분석 전이라고 알린다.
    expect(find.text(l10n.extProductAnalysisPendingTitle), findsOneWidget);
    expect(find.textContaining('RTI'), findsNothing);
    // 수집되지 않은 별점은 자리를 만들지 않는다.
    expect(find.byIcon(Icons.star_rounded), findsNothing);
    expect(find.text('리뷰 1'), findsOneWidget);
    expect(find.text(l10n.extProductReviewsMore), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loads more reviews with the cursor', (tester) async {
    final repository = FakeExternalProductRepository()
      ..products = [
        Success(readyOf(nextCursor: 'c1')),
        Success(readyOf(reviews: [reviewOf('3')])),
      ];
    await pumpContent(tester, repository: repository);
    final l10n = l10nOf(tester);

    await tester.ensureVisible(find.text(l10n.extProductReviewsMore));
    await tester.tap(find.text(l10n.extProductReviewsMore));
    await tester.pumpAndSettle();
    expect(find.text('리뷰 3'), findsOneWidget);
    expect(find.text(l10n.extProductReviewsMore), findsNothing);
    expect(repository.cursors, [null, 'c1']);
  });

  testWidgets('shows a waiting screen while a new product is collected', (
    tester,
  ) async {
    final repository = FakeExternalProductRepository()
      ..products = [const Success(queued), Success(readyOf())]
      ..jobs = const [
        Success(CollectionJob(id: 9, status: CollectionJobStatus.pending)),
        Success(CollectionJob(id: 9, status: CollectionJobStatus.succeeded)),
      ];
    await pumpContent(
      tester,
      repository: repository,
      pollInterval: const Duration(seconds: 3),
    );
    final l10n = l10nOf(tester);
    expect(find.text(l10n.extProductCollectingTitle), findsOneWidget);
    expect(find.text(kurlyProduct.name), findsNothing);

    // 3초마다 한 번씩 확인한다: 수집 중 → 완료 → 상품 다시 조회.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    await tester.pump();
    expect(find.text(kurlyProduct.name), findsOneWidget);
  });

  testWidgets('explains an unavailable product and retries', (tester) async {
    final repository = FakeExternalProductRepository()
      ..products = [
        const Success(
          ExternalProductSnapshot(status: CollectionStatus.unavailable),
        ),
        Success(readyOf()),
      ];
    await pumpContent(tester, repository: repository);
    final l10n = l10nOf(tester);
    expect(find.text(l10n.extProductUnavailableTitle), findsOneWidget);
    expect(find.text(l10n.extProductUnavailableBody), findsOneWidget);

    await tester.tap(find.text(l10n.extProductRetry));
    await tester.pumpAndSettle();
    expect(find.text(kurlyProduct.name), findsOneWidget);
  });

  testWidgets('shows that stale data is being refreshed', (tester) async {
    final repository = FakeExternalProductRepository()
      ..products = [Success(readyOf(status: CollectionStatus.stale))];
    await pumpContent(tester, repository: repository);
    expect(find.text(l10nOf(tester).extProductStale), findsOneWidget);
    expect(find.text(kurlyProduct.name), findsOneWidget);
  });

  for (final width in [320.0, 800.0, 1400.0]) {
    testWidgets('fits a ${width.toInt()}px screen', (tester) async {
      await pumpContent(tester, size: Size(width, 900));
      expect(find.text(kurlyProduct.name), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

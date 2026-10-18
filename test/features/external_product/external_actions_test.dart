import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_actions_remote_data_source.dart';
import 'package:re_view_front/features/external_product/data/repositories/external_actions_repository_impl.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_history_target.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_actions_repository.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_actions_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_actions_view_model.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_action_notice.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_product_action_bar.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_actions.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_report_dialog.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_history_review_content.dart';
import 'package:re_view_front/features/wishlist/data/dtos/wishlist_item_dto.dart';
import 'package:re_view_front/features/cart/data/dtos/cart_item_dto.dart';
import 'package:re_view_front/features/feedback_history/data/dtos/feedback_item_dto.dart';
import 'package:re_view_front/features/review_report/data/dtos/review_report_dto.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_report_dto.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

const product = ExternalProductRef(platform: 'kurly', productId: 'abc-def');
const target = (product: product, springProductId: null);
const reviewTarget = (product: product, reviewId: 'review/id');
void main() {
  test(
    'tag requests coalesce and successful tag survives repeated calls',
    () async {
      final client = ApiClient(AppConfig.fromEnvironment());
      client.dio.interceptors.clear();
      int calls = 0;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) {
            calls++;
            expect(o.path, '/api/v2/products/kurly/abc-def/tag');
            h.resolve(
              Response(
                requestOptions: o,
                data: {
                  'success': true,
                  'data': {'springProductId': 42},
                },
              ),
            );
          },
        ),
      );
      final repository = ExternalActionsRepositoryImpl(
        ExternalActionsRemoteDataSource(client),
      );
      final results = await Future.wait([
        repository.tag(product),
        repository.tag(product),
      ]);
      expect((results.first as Success<int>).value, 42);
      await repository.tag(product);
      expect(calls, 1);
    },
  );
  for (final entry in {
    'PRODUCT_NOT_COLLECTED': 409,
    'DATA_SERVER_UNAVAILABLE': 503,
    'REPORT_ALREADY_EXISTS': 409,
    'FEEDBACK_ALREADY_EXISTS': 409,
    'UNAUTHORIZED': 401,
    'UNKNOWN': 500,
  }.entries) {
    test('preserves ${entry.key} errors and retries failed tags', () async {
      final client = ApiClient(AppConfig.fromEnvironment());
      client.dio.interceptors.clear();
      int calls = 0;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) {
            calls++;
            h.reject(
              DioException(
                requestOptions: o,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: o,
                  statusCode: entry.value,
                  data: {
                    'success': false,
                    'errorCode': entry.key,
                    'message': 'error',
                  },
                ),
              ),
            );
          },
        ),
      );
      final repo = ExternalActionsRepositoryImpl(
        ExternalActionsRemoteDataSource(client),
      );
      for (final result in [
        await repo.tag(product),
        await repo.feedback(product, 'id', 'REAL'),
        await repo.report(product, 'id', reason: 'OTHER', detail: 'x' * 20),
      ]) {
        expect((result as FailureResult).failure.code, entry.key);
        expect(result.failure.statusCode, entry.value);
      }
      await repo.tag(product);
      expect(calls, 4);
    });
  }
  test(
    'report and feedback use encoded review IDs and only contractual fields',
    () async {
      final client = ApiClient(AppConfig.fromEnvironment());
      client.dio.interceptors.clear();
      final requests = <RequestOptions>[];
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) {
            requests.add(o);
            h.resolve(Response(requestOptions: o, data: {'success': true}));
          },
        ),
      );
      final repo = ExternalActionsRepositoryImpl(
        ExternalActionsRemoteDataSource(client),
      );
      await repo.feedback(product, 'review/id', 'FAKE');
      await repo.report(
        product,
        'review/id',
        reason: 'OTHER',
        detail: 'x' * 20,
        includeAiEvidence: true,
        attachmentUrl: 'https://example.com',
      );
      expect(
        requests.first.path,
        '/api/reviews/external/kurly/abc-def/reviews/review%2Fid/feedback',
      );
      expect(requests.first.data, {'feedbackType': 'FAKE'});
      expect(
        requests.last.path,
        '/api/reports/external/kurly/abc-def/reviews/review%2Fid',
      );
      expect(requests.last.data, {
        'reason': 'OTHER',
        'detail': 'x' * 20,
        'includeAiEvidence': true,
        'attachmentUrl': 'https://example.com',
      });
    },
  );
  test(
    'unknown tag is never requested for initial state; actions reuse tag and refresh counts',
    () async {
      final f = Fixture();
      addTearDown(f.container.dispose);
      final sub = f.container.listen(
        externalActionsProvider(target),
        (_, _) {},
      );
      addTearDown(sub.close);
      expect(f.repo.tags, 0);
      await f.container
          .read(externalActionsProvider(target).notifier)
          .act(wishlist: true);
      await f.container
          .read(externalActionsProvider(target).notifier)
          .act(wishlist: false);
      await f.container
          .read(externalActionsProvider(target).notifier)
          .act(wishlist: true);
      expect(f.repo.tags, 1);
      expect(f.wish.added, [42]);
      expect(f.wish.removed, [42]);
      expect(f.cart.added, [42]);
      expect(await f.container.read(cartItemCountProvider.future), 1);
      expect(await f.container.read(wishlistItemCountProvider.future), 0);
    },
  );
  test('supplied tag initializes wishlist and skips tag endpoint', () async {
    final f = Fixture();
    addTearDown(f.container.dispose);
    f.wish.items.add(wishItem(42));
    const known = (product: product, springProductId: 42);
    final sub = f.container.listen(externalActionsProvider(known), (_, _) {});
    addTearDown(sub.close);
    await Future<void>.delayed(Duration.zero);
    expect(f.container.read(externalActionsProvider(known)).wished, true);
    await f.container
        .read(externalActionsProvider(known).notifier)
        .act(wishlist: true);
    expect(f.repo.tags, 0);
    expect(f.wish.removed, [42]);
  });
  test(
    'blocks duplicate actions and ignores completion after dispose',
    () async {
      final f = Fixture();
      final pending = Completer<Result<int>>();
      f.repo.pendingTag = pending.future;
      final sub = f.container.listen(
        externalActionsProvider(target),
        (_, _) {},
      );
      final vm = f.container.read(externalActionsProvider(target).notifier);
      final first = vm.act(wishlist: true);
      expect(await vm.act(wishlist: false), null);
      expect(f.repo.tags, 1);
      sub.close();
      f.container.dispose();
      pending.complete(const Success(42));
      expect(await first, null);
      expect(f.wish.added, isEmpty);
    },
  );
  test('review submit blocks duplicates and ignores late response', () async {
    final f = Fixture();
    final pending = Completer<Result<void>>();
    f.repo.pendingReview = pending.future;
    final sub = f.container.listen(
      externalReviewActionsProvider(reviewTarget),
      (_, _) {},
    );
    final vm = f.container.read(
      externalReviewActionsProvider(reviewTarget).notifier,
    );
    final first = vm.submit(feedbackType: 'REAL');
    expect(await vm.submit(feedbackType: 'FAKE'), null);
    expect(f.repo.reviews, 1);
    sub.close();
    f.container.dispose();
    pending.complete(const Success(null));
    expect(await first, null);
  });
  test('logged out actions perform no request', () async {
    final f = Fixture(loggedIn: false);
    addTearDown(f.container.dispose);
    final s = f.container.listen(externalActionsProvider(target), (_, _) {});
    addTearDown(s.close);
    final r = await f.container
        .read(externalActionsProvider(target).notifier)
        .act(wishlist: true);
    expect((r as FailureResult).failure.statusCode, 401);
    expect(f.repo.tags, 0);
  });
  for (final code in [
    'PRODUCT_NOT_COLLECTED',
    'DATA_SERVER_UNAVAILABLE',
    'UNKNOWN',
  ]) {
    test(
      'tag failure $code restores buttons without calling wishlist',
      () async {
        final f = Fixture();
        addTearDown(f.container.dispose);
        f.repo.pendingTag = Future.value(
          FailureResult(Failure(message: 'x', code: code)),
        );
        final sub = f.container.listen(
          externalActionsProvider(target),
          (_, _) {},
        );
        addTearDown(sub.close);
        final result = await f.container
            .read(externalActionsProvider(target).notifier)
            .act(wishlist: true);
        expect((result as FailureResult).failure.code, code);
        expect(f.container.read(externalActionsProvider(target)).busy, false);
        expect(f.wish.added, isEmpty);
      },
    );
  }
  for (final code in [
    'REPORT_ALREADY_EXISTS',
    'FEEDBACK_ALREADY_EXISTS',
    'PRODUCT_NOT_COLLECTED',
    'UNKNOWN',
  ]) {
    test(
      'review failure $code preserves error and releases busy state',
      () async {
        final f = Fixture();
        addTearDown(f.container.dispose);
        f.repo.pendingReview = Future.value(
          FailureResult(Failure(message: 'x', code: code)),
        );
        final sub = f.container.listen(
          externalReviewActionsProvider(reviewTarget),
          (_, _) {},
        );
        addTearDown(sub.close);
        final result = await f.container
            .read(externalReviewActionsProvider(reviewTarget).notifier)
            .submit(feedbackType: 'REAL');
        expect((result as FailureResult).failure.code, code);
        expect(
          f.container.read(externalReviewActionsProvider(reviewTarget)),
          false,
        );
      },
    );
  }
  testWidgets('logged out widget redirects with external return path', (
    tester,
  ) async {
    final f = Fixture(loggedIn: false);
    addTearDown(f.container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) =>
              const Scaffold(body: ExternalProductActionBar(product: product)),
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => Text(state.uri.queryParameters['from']!),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: f.container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.text(product.routePath), findsOneWidget);
    expect(f.repo.tags, 0);
  });
  testWidgets('replacing the product discards its pending response', (
    tester,
  ) async {
    final f = Fixture();
    addTearDown(f.container.dispose);
    final pending = Completer<Result<int>>();
    f.repo.pendingTag = pending.future;
    Widget app(ExternalProductRef p) => UncontrolledProviderScope(
      container: f.container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ExternalProductActionBar(product: p)),
      ),
    );
    await tester.pumpWidget(app(product));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    await tester.pumpWidget(
      app(const ExternalProductRef(platform: 'naver', productId: 'other')),
    );
    await tester.pump();
    pending.complete(const Success(42));
    await tester.pumpAndSettle();
    expect(f.wish.added, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
    expect(tester.takeException(), null);
  });
  test(
    'nullable histories preserve identities and summaries; RTI is never defaulted',
    () {
      final json = {
        'reviewId': null,
        'reviewContent': null,
        'externalReviewId': 'r',
        'productExternalId': 'kurly-abc-def',
        'productName': 'Product',
      };
      final feedback = FeedbackItemDto.fromJson(json).toEntity();
      expect(feedback.reviewContent, null);
      expect(feedback.reviewId, null);
      expect(externalHistoryTarget(feedback.productExternalId), product);
      final report = ReviewReportDto.fromJson(json).toEntity();
      expect(report.reviewContent, null);
      expect(report.reviewId, null);
      expect(report.externalReviewId, 'r');
      final admin = AdminReportDto(json).toEntity();
      expect(admin.reviewContent, null);
      expect(admin.productExternalId, product.externalId);
      expect(
        FeedbackItemDto.fromJson({
          'reviewContentSummary': 'Original',
          'reviewId': 7,
        }).toEntity().reviewContent,
        'Original',
      );
      final wish = WishlistItemDto.fromJson({}).toEntity();
      expect(wish.avgRti, null);
      expect(wish.rtiColor, null);
      expect(wish.rtiGrade, null);
      expect(wish.categoryDisplayName, null);
      final cart = CartItemDto.fromJson({}).toEntity();
      expect(cart.avgRti, null);
      expect(cart.rtiColor, null);
      expect(cart.rtiGrade, null);
    },
  );
  for (final width in [320.0, 800.0, 1400.0]) {
    for (final locale in ['ko', 'en', 'ja', 'zh']) {
      testWidgets('widgets and report dialog fit $width $locale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final f = Fixture();
        addTearDown(f.container.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: f.container,
            child: MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Column(
                  children: [
                    const ExternalProductActionBar(product: product),
                    const ExternalReviewActions(
                      product: product,
                      reviewId: 'id',
                    ),
                    Builder(
                      builder: (context) => TextButton(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) => const ExternalReviewReportDialog(
                            product: product,
                            reviewId: 'id',
                            productName: 'Product',
                            reviewContent: 'Review',
                          ),
                        ),
                        child: const Text('open'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), null);
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), null);
      });
    }
  }
  testWidgets(
    'external null review displays product and navigates preserving hyphens; Spring displays content',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: Column(
                children: [
                  ExternalHistoryReviewContent(
                    reviewContent: null,
                    productName: 'External product',
                    productExternalId: 'kurly-abc-def',
                  ),
                  ExternalHistoryReviewContent(
                    reviewContent: 'Spring review',
                    productName: 'Spring product',
                  ),
                ],
              ),
            ),
          ),
          GoRoute(
            path: '/product/:platform/:id',
            builder: (_, s) => Text(s.pathParameters['id']!),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(find.text('External product'), findsOneWidget);
      expect(find.text('Spring review'), findsOneWidget);
      await tester.tap(find.text('External product'));
      await tester.pumpAndSettle();
      expect(find.text('abc-def'), findsOneWidget);
    },
  );
  testWidgets('each failure has a distinct localized message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l = AppLocalizations.of(context);
            final messages =
                [
                      'PRODUCT_NOT_COLLECTED',
                      'DATA_SERVER_UNAVAILABLE',
                      'REPORT_ALREADY_EXISTS',
                      'FEEDBACK_ALREADY_EXISTS',
                      'UNKNOWN',
                    ]
                    .map(
                      (c) => externalFailureMessage(
                        l,
                        Failure(message: 'x', code: c),
                      ),
                    )
                    .toSet();
            expect(messages.length, 5);
            return const SizedBox();
          },
        ),
      ),
    );
  });
}

class FakeExternal implements ExternalActionsRepository {
  int tags = 0, reviews = 0;
  Future<Result<int>>? pendingTag;
  Future<Result<void>>? pendingReview;
  @override
  Future<Result<int>> tag(ExternalProductRef p) {
    tags++;
    return pendingTag ?? Future.value(const Success(42));
  }

  @override
  Future<Result<void>> feedback(ExternalProductRef p, String r, String t) {
    reviews++;
    return pendingReview ?? Future.value(const Success(null));
  }

  @override
  Future<Result<void>> report(
    ExternalProductRef p,
    String r, {
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) {
    reviews++;
    return pendingReview ?? Future.value(const Success(null));
  }
}

WishlistItem wishItem(int id) => WishlistItem(
  productId: id,
  name: 'p',
  imageUrl: '',
  price: 1,
  category: '',
  categoryDisplayName: null,
  avgRti: null,
  rtiGrade: null,
  rtiColor: null,
  reviewCount: 0,
  avgRating: 0,
  isPriceDrop: false,
  isNewAlert: false,
);

class FakeWish implements WishlistRepository {
  final items = <WishlistItem>[];
  final added = <int>[], removed = <int>[];
  @override
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>>
  getWishlist() async => Success((
    items: [...items],
    summary: const WishlistSummary(
      priceDropCount: 0,
      newAlertCount: 0,
      totalReviewCount: 0,
    ),
  ));
  @override
  Future<Result<void>> addWishlist(int id) async {
    added.add(id);
    items.add(wishItem(id));
    return const Success(null);
  }

  @override
  Future<Result<void>> removeWishlist(int id) async {
    removed.add(id);
    items.removeWhere((i) => i.productId == id);
    return const Success(null);
  }

  @override
  Future<Result<bool>> checkWishlist(int id) async =>
      Success(items.any((i) => i.productId == id));
}

class FakeCart implements CartRepository {
  final added = <int>[];
  @override
  Future<Result<({List<CartItem> items, CartSummary summary})>>
  getCart() async => Success((
    items: [
      for (final id in added)
        CartItem(
          cartItemId: id,
          productId: id,
          name: 'p',
          imageUrl: '',
          price: 1,
          quantity: 1,
          avgRti: null,
          rtiGrade: null,
          rtiColor: null,
          trustLevel: '',
          shippingFee: 0,
        ),
    ],
    summary: const CartSummary(
      totalProductPrice: 0,
      shippingFee: 0,
      discountAmount: 0,
      totalPayment: 0,
    ),
  ));
  @override
  Future<Result<void>> addItem(int id, {int quantity = 1}) async {
    added.add(id);
    return const Success(null);
  }

  @override
  Future<Result<void>> updateQuantity(int id, int quantity) async =>
      const Success(null);
  @override
  Future<Result<void>> removeItem(int id) async => const Success(null);
  @override
  Future<Result<void>> clearCart() async => const Success(null);
}

class Fixture {
  Fixture({bool loggedIn = true}) {
    container = ProviderContainer(
      overrides: [
        isLoggedInProvider.overrideWithValue(loggedIn),
        externalActionsRepositoryProvider.overrideWithValue(repo),
        wishlistRepositoryProvider.overrideWithValue(wish),
        cartRepositoryProvider.overrideWithValue(cart),
      ],
    );
  }
  final repo = FakeExternal();
  final wish = FakeWish();
  final cart = FakeCart();
  late final ProviderContainer container;
}

import 'package:re_view_front/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_product_card.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/product_recommendation_section.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/core/analysis/analysis_contract.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/analysis_summary_card.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import '../../helpers/pump_app.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/data/dtos/cart_item_dto.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_product_remote_data_source.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/home/data/dtos/dashboard_product_dto.dart';
import 'package:re_view_front/features/product_detail/data/dtos/product_detail_dto.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';
import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';
import 'package:re_view_front/features/search/presentation/widgets/review_comparison_banner.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';
import 'package:re_view_front/features/wishlist/data/dtos/wishlist_item_dto.dart';

const realProduct = <String, dynamic>{
  'id': 690821524936079,
  'name': '테스트 선크림',
  'price': 29900,
  'imageUrl': '',
  'dataPlatform': 'kurly',
  'dataProductId': '1001319595',
  'externalId': 'kurly-1001319595',
  'category': null,
  'subCategory': '뷰티 인디 > 인디 썬케어 > 인디 썬크림',
  'avgRti': null,
  'rtiGrade': null,
  'rtiColor': null,
  'reviewCount': null,
  'avgRating': null,
};

void main() {
  test('keeps mapped backend categories authoritative and raw mall labels', () {
    final product = SearchResultProductDto.fromJson({
      ...realProduct,
      'name': '도서처럼 보이는 스킨케어 상품',
      'category': 'BEAUTY_SKINCARE',
      'categoryDisplayName': '스킨케어',
      'subCategory': '뷰티 인디 > 썬크림',
    }).toEntity();
    expect(product.category, 'BEAUTY_SKINCARE');
    expect(product.subCategory, '뷰티 인디 > 썬크림');
    expect(product.categoryDisplayName, '스킨케어');
    final shoes = SearchResultProductDto.fromJson({
      ...realProduct,
      'category': 'ACC_SHOES',
      'categoryDisplayName': '신발',
      'subCategory': '스니커즈 > 운동화',
    }).toEntity();
    expect(shoes.categoryDisplayName, '신발');
    expect(shoes.subCategory, '스니커즈 > 운동화');
    expect(
      isProductInCategory(
        'shoes',
        productCategory: shoes.category,
        productCategoryDisplayName: shoes.categoryDisplayName,
      ),
      isTrue,
    );
    expect(
      isProductInCategory(
        'skincare',
        productCategory: product.category,
        productCategoryDisplayName: product.categoryDisplayName,
        productName: product.name,
      ),
      isTrue,
    );
    expect(
      isProductInCategory(
        'book',
        productCategory: product.category,
        productCategoryDisplayName: product.categoryDisplayName,
        productName: product.name,
      ),
      isFalse,
    );
  });

  test('preserves real identity, large numeric REST ID and raw category', () {
    final product = SearchResultProductDto.fromJson(realProduct).toEntity();
    expect(product.id, 690821524936079);
    expect(product.detailPath, '/product/kurly/1001319595');
    expect(product.chatProductId, 'kurly-1001319595');
    expect(product.category, isEmpty);
    expect(product.categoryDisplayName, realProduct['subCategory']);
    expect(product.subCategory, realProduct['subCategory']);
    expect(product.avgRti, isNull);
    expect(product.rtiGrade, isNull);
    expect(product.rtiColor, isNull);
    expect(product.reviewCount, isNull);
    expect(product.avgRating, isNull);
  });

  test(
    'prefers explicit pair and parses only the first external separator',
    () {
      final paired = SearchResultProductDto.fromJson({
        ...realProduct,
        'externalId': 'other-wrong',
        'dataProductId': 'a-b/c %',
      }).toEntity();
      expect(paired.chatProductId, 'other-wrong');
      expect(paired.detailPath, '/product/kurly/a-b%2Fc%20%25');
      final onlyExternal = SearchResultProductDto.fromJson({
        ...realProduct,
        'dataPlatform': null,
        'dataProductId': null,
        'externalId': 'kurly-a-b/c %',
      }).toEntity();
      expect(onlyExternal.detailPath, paired.detailPath);
      expect(
        ExternalProductRef.fromRoute(Uri.parse(paired.detailPath))?.externalId,
        'kurly-a-b/c %',
      );
    },
  );

  test('pair-only and dummy retain distinct route and chat contracts', () {
    final paired = SearchResultProductDto.fromJson({
      ...realProduct,
      'externalId': null,
    }).toEntity();
    expect(paired.chatProductId, 'kurly-1001319595');
    final dummy = SearchResultProductDto.fromJson({
      'id': 42,
      'name': '기존 상품',
    }).toEntity();
    expect(dummy.detailPath, '/product/42');
    expect(dummy.chatProductId, isNull);
    expect(ExternalProductRef.fromRoute(Uri.parse(dummy.detailPath)), isNull);
  });

  test('wishlist, cart and dashboard preserve external navigation', () {
    final payload = {
      ...realProduct,
      'productId': realProduct['id'],
      'cartItemId': 7,
      'quantity': 1,
    };
    final wished = WishlistItemDto.fromJson(payload).toEntity();
    final cart = CartItemDto.fromJson(payload).toEntity();
    final dashboard = DashboardProductDto.fromJson(payload).toEntity();
    expect(wished.detailPath, '/product/kurly/1001319595');
    expect(cart.copyWith(quantity: 2).detailPath, wished.detailPath);
    expect(cart.productId, realProduct['id']);
    expect(dashboard.detailPath, wished.detailPath);
  });

  test(
    'legacy detail keeps null analysis and explicit zero metrics distinct',
    () {
      final absent = ProductDetailDto.fromJson(realProduct).toEntity();
      expect(absent.rtiSummary, isNull);
      expect(absent.rtiColor, isNull);
      expect(absent.detailPath, '/product/kurly/1001319595');
      final zero = ProductDetailDto.fromJson({
        ...realProduct,
        'avgRti': 0,
        'avgRating': 0,
        'reviewCount': 0,
      }).toEntity();
      expect(zero.avgRti, 0);
      expect(zero.avgRating, 0);
      expect(zero.reviewCount, 0);
      expect(zero.rtiSummary?.rtiScore, 0);
      expect(zero.rtiSummary?.rtiLabel, isEmpty);
      expect(zero.rtiSummary?.hasReviewMetrics, isFalse);
    },
  );

  testWidgets(
    'unknown analysis displays no score or invented analysis summary',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RtiSummaryCard(rtiSummary: null, onDetailPressed: () {}),
          ),
        ),
      );
      expect(find.text('분석 전'), findsOneWidget);
      expect(find.textContaining('AI'), findsNothing);
      expect(find.textContaining('RTI 0'), findsNothing);
    },
  );

  testWidgets('comparison average includes zero and excludes unknown scores', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final products = [
      realProduct,
      {...realProduct, 'id': 2, 'avgRti': 0},
      {...realProduct, 'id': 3, 'avgRti': 80},
    ].map((v) => SearchResultProductDto.fromJson(v).toEntity()).toList();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: ReviewComparisonBanner(products: products)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('40'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: ReviewComparisonBanner(products: [products.first]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('분석 전'), findsOneWidget);
    expect(find.text('0%'), findsNothing);
  });

  for (final score in [null, 0.0]) {
    testWidgets('search card distinguishes RTI and rating null/zero ($score)', (
      tester,
    ) async {
      final product = SearchResultProductDto.fromJson({
        ...realProduct,
        'avgRti': score,
        'avgRating': score,
        'reviewCount': score == null ? null : 0,
      }).toEntity();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [isLoggedInProvider.overrideWithValue(false)],
          child: MaterialApp(
            locale: const Locale('ko'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SizedBox(
                width: 360,
                height: 460,
                child: SearchProductCard(product: product),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(score == null ? '분석 전' : 'RTI 0'), findsOneWidget);
      expect(find.text('0.0'), score == null ? findsNothing : findsOneWidget);
      expect(
        find.text('(리뷰 0)'),
        score == null ? findsNothing : findsOneWidget,
      );
      expect(find.text(realProduct['subCategory'] as String), findsOneWidget);
    });
  }

  test(
    'home catalog reads products without replacing the dashboard source',
    () async {
      final client = ApiClient(AppConfig.fromEnvironment());
      final paths = <String>[];
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'success': true,
                  'data': [realProduct],
                },
              ),
            );
          },
        ),
      );
      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(client)],
      );
      addTearDown(container.dispose);
      addTearDown(() => client.dio.close());
      final products = await container.read(homeCatalogProvider.future);
      expect(products.single.detailPath, '/product/kurly/1001319595');
      expect(paths, ['/api/products/catalog']);
    },
  );

  test('v2 keeps queued job and distinguishes missing/zero metrics', () async {
    final config = AppConfig.fromEnvironment();
    final client = ApiClient(config);
    Map<String, dynamic> data = {
      'collectionStatus': 'QUEUED',
      'product': null,
      'job': {'id': 9, 'status': 'pending'},
    };
    RequestOptions? request;
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response(
              requestOptions: options,
              data: {'success': true, 'data': data},
            ),
          );
        },
      ),
    );
    final source = ExternalProductRemoteDataSourceImpl(client);
    const ref = ExternalProductRef(platform: 'kurly', productId: 'a-b/c');
    final queued = await source.getProduct(ref);
    expect(queued.status, CollectionStatus.queued);
    expect(queued.product, isNull);
    expect(queued.job?.id, 9);
    expect(request?.path, '/api/v2/products/kurly/a-b%2Fc');
    data = {
      'collectionStatus': 'FRESH',
      'product': {'name': '상품', 'reviewCount': null, 'rating': null},
      'reviews': {'items': [], 'nextCursor': 'a+/='},
    };
    final absent = await source.getProduct(ref, cursor: 'cursor+/=');
    expect(request?.queryParameters['cursor'], 'cursor+/=');
    expect(absent.product?.reviewCount, isNull);
    expect(absent.product?.rating, isNull);
    expect(absent.nextCursor, 'a+/=');
    data['product'] = {'name': '상품', 'reviewCount': 0, 'rating': 0};
    final zero = await source.getProduct(ref);
    expect(zero.product?.reviewCount, 0);
    expect(zero.product?.rating, 0);
    client.dio.close();
  });
  test(
    'catalog v4 values and attention counts survive product DTO conversion',
    () {
      final payload = {
        ...realProduct,
        'productId': 1,
        'cartItemId': 7,
        'quantity': 1,
        'contractVersion': 'v2',
        'avgPolicyIndexV4': 50,
        'avgPolicyIndexV3': 99,
        'analysisStatus': 'DONE',
        'v4LevelCounts': {'SAFE': 8, 'WARN': 2, 'DANGER': 1},
      };
      final displays = [
        SearchResultProductDto.fromJson(payload).toEntity().analysisDisplay,
        DashboardProductDto.fromJson(payload).toEntity().analysisDisplay,
        WishlistItemDto.fromJson(payload).toEntity().analysisDisplay,
        CartItemDto.fromJson(payload).toEntity().analysisDisplay,
      ];
      for (final display in displays) {
        expect(display.score, 50);
        expect(display.level, 'WARN');
        expect(display.attentionReviewCount, 3);
      }
    },
  );

  test(
    'detail prefers v4 model and policy versions and hides old summary fallback',
    () async {
      final client = ApiClient(AppConfig.fromEnvironment());
      addTearDown(() => client.dio.close(force: true));
      var analysis = <String, dynamic>{
        'contractVersion': 'v2',
        'avgPolicyIndexV4': 55,
        'modelVersion': 'old-model',
        'policyVersion': 'old-policy',
        'modelVersionV4': 'ptext-koelectra-v4.0',
        'policyVersionV4': 'text-first-v1',
        'analysisSummaryKo': '이전 기준 요약',
        'rulesReasonsKo': ['이전 기준 이유'],
      };
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'success': true,
                  'data': {
                    'collectionStatus': 'FRESH',
                    'analysisStatus': 'DONE',
                    'product': {'name': '상품'},
                    'analysis': analysis,
                    'analysisSummaryKo': '본문의 이전 기준 요약',
                  },
                },
              ),
            );
          },
        ),
      );
      final source = ExternalProductRemoteDataSourceImpl(client);
      const productRef = ExternalProductRef(
        platform: 'kurly',
        productId: 'test',
      );
      final result = await source.getProduct(productRef);
      expect(result.analysis?.modelVersion, 'ptext-koelectra-v4.0');
      expect(result.analysis?.policyVersion, 'text-first-v1');
      expect(result.analysis?.summary, isNull);
      expect(result.analysis?.display?.displayReasons, isEmpty);
      analysis = {
        'contractVersion': 'v2',
        'modelVersion': 'old-model',
        'policyVersion': 'old-policy',
      };
      final fallback = await source.getProduct(productRef);
      expect(fallback.analysis?.modelVersion, 'old-model');
      expect(fallback.analysis?.policyVersion, 'old-policy');
      expect(fallback.analysis?.display?.isAwaitingScore, isTrue);
    },
  );

  for (final counts in <Map<String, int>?>[
    null,
    {'SAFE': 10, 'WARN': 2, 'DANGER': 1},
    {'SAFE': 10, 'WARN': 0, 'DANGER': 0},
  ]) {
    testWidgets(
      'v4 search card shows only supplied attention review counts ($counts)',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final product = SearchResultProductDto.fromJson({
          ...realProduct,
          'contractVersion': 'v2',
          'avgPolicyIndexV4': 50,
          'v4LevelCounts': ?counts,
        }).toEntity();
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => Scaffold(
                body: MediaQuery.withClampedTextScaling(
                  minScaleFactor: 1.6,
                  maxScaleFactor: 1.6,
                  child: SizedBox(
                    width: 300,
                    height: 550,
                    child: SearchProductCard(product: product),
                  ),
                ),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await pumpApp(
          tester,
          ProviderScope(
            overrides: [isLoggedInProvider.overrideWithValue(false)],
            child: localizedApp(router: router),
          ),
        );
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(SearchProductCard)),
        );
        if (counts == null) {
          expect(find.textContaining('주의 리뷰'), findsNothing);
        } else {
          expect(
            find.text(
              l.analysisAttentionReviews(counts['WARN']! + counts['DANGER']!),
            ),
            findsOneWidget,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'v4 summary keeps model and policy metadata beside the fixed caution text',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: SingleChildScrollView(
                child: AnalysisSummaryCard(
                  state: ExternalProductState(
                    analysisStatus: 'DONE',
                    analysis: ExternalAnalysis(
                      summary: '이전 기준 요약',
                      modelVersion: 'old-model',
                      policyVersion: 'old-policy',
                      display: AnalysisContract.parse({
                        'contractVersion': 'v2',
                        'avgPolicyIndexV4': 50,
                        'modelVersionV4': 'ptext-koelectra-v4.0',
                        'policyVersionV4': 'text-first-v1',
                      }, catalog: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await pumpApp(tester, ProviderScope(child: localizedApp(router: router)));
      final l = AppLocalizations.of(
        tester.element(find.byType(AnalysisSummaryCard)),
      );
      expect(find.textContaining('ptext-koelectra-v4.0'), findsNothing);
      await tester.tap(find.text(l.extSummaryEvidenceToggle));
      await tester.pump();
      expect(find.text(l.analysisTextCaution), findsOneWidget);
      expect(find.textContaining('ptext-koelectra-v4.0'), findsOneWidget);
      expect(find.textContaining('text-first-v1'), findsOneWidget);
      expect(find.text('이전 기준 요약'), findsNothing);
      expect(find.textContaining('old-model'), findsNothing);
    },
  );
  for (final width in [320.0, 1280.0]) {
    testWidgets(
      'catalog cards retain attention counts with large text at width $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1500);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final payload = {
          ...realProduct,
          'contractVersion': 'v2',
          'avgPolicyIndexV4': 50,
          'v4LevelCounts': {'SAFE': 1, 'WARN': 2, 'DANGER': 1},
          'productId': 1,
          'cartItemId': 7,
          'quantity': 1,
        };
        final analysis = SearchResultProductDto.fromJson(
          payload,
        ).toEntity().analysisDisplay;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) {
                final home = HomeProductData(
                  productId: '1',
                  name: '상품 이름',
                  storeName: '컬리',
                  priceLabel: '10,000원',
                  ratingLabel: '4.5',
                  reviewCountLabel: '10',
                  rtiLabel: analysis.badgeText(context),
                  attentionReviewLabel: width == 1280
                      ? 'Reviews needing attention: 3'
                      : analysis.attentionReviewsLabel(context),
                  analysisDescription: analysis
                      .localizedReasons(context)
                      .firstOrNull,
                  imageUrl: '',
                  label: '뷰티',
                );
                return Scaffold(
                  body: MediaQuery.withClampedTextScaling(
                    minScaleFactor: 1.6,
                    maxScaleFactor: 1.6,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProductRecommendationSection(
                            showHeader: false,
                            products: [home, home],
                          ),
                          SizedBox(
                            width: 300,
                            height: 500,
                            child: WishlistProductCard(
                              item: WishlistItemDto.fromJson(
                                payload,
                              ).toEntity(),
                              isToggling: false,
                              onRemove: () {},
                            ),
                          ),
                          CartItemCard(
                            item: CartItemDto.fromJson(payload).toEntity(),
                            isSelected: false,
                            isUpdating: false,
                            onToggleSelect: () {},
                            onQuantityChanged: (_) {},
                            onRemove: () {},
                            onMoveToWishlist: () {},
                            onSaveForLater: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
        addTearDown(router.dispose);
        await pumpApp(
          tester,
          ProviderScope(
            overrides: [isLoggedInProvider.overrideWithValue(false)],
            child: localizedApp(router: router),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('주의 리뷰 3건'), findsNWidgets(width == 1280 ? 2 : 4));
        if (width == 1280) {
          expect(find.text('Reviews needing attention: 3'), findsNWidgets(2));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}

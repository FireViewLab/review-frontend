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
        home: Scaffold(body: ReviewComparisonBanner(products: products)),
      ),
    );
    expect(find.text('40'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewComparisonBanner(products: [products.first]),
        ),
      ),
    );
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
      expect(paths, ['/api/products']);
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
}

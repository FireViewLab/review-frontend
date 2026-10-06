import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_image_gallery.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

void main() {
  testWidgets('toggles wishlist through the API from the gallery button', (
    tester,
  ) async {
    final repository = _FakeWishlistRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          wishlistRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ProductImageGallery(
                  productId: 42,
                  imageUrls: ['https://example.com/product.png'],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('찜하기'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(find.byTooltip('찜 취소'), findsOneWidget);
    expect(repository.addWishlistCalls, 1);
    expect(repository.addedProductIds, [42]);
  });

  Future<void> pumpGallery(WidgetTester tester, {required bool reduced}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [isLoggedInProvider.overrideWithValue(false)],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
            child: child!,
          ),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ProductImageGallery(
                  productId: 42,
                  imageUrls: [
                    'https://example.com/one.png',
                    'https://example.com/two.png',
                    'https://example.com/three.png',
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'reduced motion stops the gallery timer and keeps manual navigation',
    (tester) async {
      await pumpGallery(tester, reduced: false);
      expect(find.text('1 / 3'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('2 / 3'), findsOneWidget);

      await pumpGallery(tester, reduced: true);
      await tester.pump(const Duration(seconds: 9));
      expect(find.text('2 / 3'), findsOneWidget);
      await tester.tap(find.byTooltip('다음 상품 이미지'));
      await tester.pump();
      expect(find.text('3 / 3'), findsOneWidget);
      await tester.pump(const Duration(seconds: 9));
      expect(find.text('3 / 3'), findsOneWidget);

      await pumpGallery(tester, reduced: false);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('1 / 3'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reduced motion removes the moving hover magnifier', (
    tester,
  ) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await pumpGallery(tester, reduced: false);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(ProductImageGallery)));
    await tester.pump();
    Finder magnifier() => find.byWidgetPredicate(
      (widget) =>
          widget is Transform && widget.transform.getMaxScaleOnAxis() == 2.8,
    );
    expect(magnifier(), findsOneWidget);
    await pumpGallery(tester, reduced: true);
    await mouse.moveTo(
      tester.getCenter(find.byType(ProductImageGallery)) + const Offset(10, 10),
    );
    await tester.pump();
    expect(magnifier(), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _FakeWishlistRepository implements WishlistRepository {
  int getWishlistCalls = 0;
  int addWishlistCalls = 0;
  int removeWishlistCalls = 0;
  final List<int> addedProductIds = [];

  @override
  Future<Result<({List<WishlistItem> items, WishlistSummary summary})>>
  getWishlist() async {
    getWishlistCalls += 1;
    return Success((
      items: addedProductIds
          .map(
            (id) => WishlistItem(
              productId: id,
              name: "Test product",
              imageUrl: "",
              price: 0,
              category: "test",
              categoryDisplayName: null,
              avgRti: null,
              rtiGrade: null,
              rtiColor: null,
              reviewCount: 0,
              avgRating: 0,
              isPriceDrop: false,
              isNewAlert: false,
            ),
          )
          .toList(),
      summary: const WishlistSummary(
        priceDropCount: 0,
        newAlertCount: 0,
        totalReviewCount: 0,
      ),
    ));
  }

  @override
  Future<Result<void>> addWishlist(int productId) async {
    addWishlistCalls += 1;
    addedProductIds.add(productId);
    return const Success(null);
  }

  @override
  Future<Result<void>> removeWishlist(int productId) async {
    removeWishlistCalls += 1;
    return const Success(null);
  }

  @override
  Future<Result<bool>> checkWishlist(int productId) async {
    return const FailureResult(Failure(message: 'unexpected check call'));
  }
}

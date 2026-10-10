import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_list_section.dart';

void main() {
  testWidgets('shows reviews ten at a time', (tester) async {
    tester.view.physicalSize = const Size(1280, 8000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReviewListSection(
                reviews: [for (var i = 0; i < 25; i++) _review(i)],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ReviewCard), findsNWidgets(10));
    expect(find.text('리뷰 더보기 (15개 남음)'), findsOneWidget);

    await tester.tap(find.text('리뷰 더보기 (15개 남음)'));
    await tester.pump();
    expect(find.byType(ReviewCard), findsNWidgets(20));

    await tester.tap(find.text('리뷰 더보기 (5개 남음)'));
    await tester.pump();
    expect(find.byType(ReviewCard), findsNWidgets(25));
    expect(find.textContaining('리뷰 더보기'), findsNothing);
  });
}

ProductReview _review(int i) => ProductReview(
  id: i,
  authorName: 'user$i',
  authorAvatarUrl: '',
  rating: 4,
  content: '리뷰 내용 $i',
  createdAt: '2026.09.01',
  platform: 'NAVER',
  isVerifiedPurchase: true,
  rtiScore: 80,
  rtiColor: 'GREEN',
  rtiLabel: '안전',
);

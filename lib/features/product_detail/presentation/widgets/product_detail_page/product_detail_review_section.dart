import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_insight_panel.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_list_section.dart';

class ProductDetailDesktopReviewSection extends StatelessWidget {
  const ProductDetailDesktopReviewSection({
    super.key,
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
    this.productId,
    this.productName = '',
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 65,
          child: ReviewListSection(
            reviews: reviews,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
            onFeedback: onFeedback,
            productId: productId,
            productName: productName,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 280,
          child: ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        ),
      ],
    );
  }
}

class ProductDetailMobileReviewSection extends StatelessWidget {
  const ProductDetailMobileReviewSection({
    super.key,
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
    this.productId,
    this.productName = '',
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        const SizedBox(height: AppSpacing.md),
        ReviewListSection(
          reviews: reviews,
          safeCount: safeCount,
          warnCount: warnCount,
          dangerCount: dangerCount,
          onFeedback: onFeedback,
          productId: productId,
          productName: productName,
        ),
      ],
    );
  }
}

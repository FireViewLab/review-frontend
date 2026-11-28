import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/shared/widgets/list_row_skeleton.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/shared/widgets/product_card_layout.dart';
import 'package:re_view_front/shared/widgets/product_review_metrics.dart';
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageSavedProductsSection extends StatelessWidget {
  const MyPageSavedProductsSection({
    required this.items,
    required this.isLoading,
    required this.onProductTap,
  });

  final List<WishlistItem> items;
  final bool isLoading;
  final ValueChanged<WishlistItem> onProductTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      if (items.isEmpty) {
        return const ListLoadingSkeleton(responsiveGrid: true);
      }
      return SizedBox(
        height: 180,
        child: AppLoadingView(
          message: AppLocalizations.of(context).myPageWishlistLoading,
        ),
      );
    }

    if (items.isEmpty) {
      return MyPageEmptyPanel(
        icon: Icons.favorite_border,
        message: AppLocalizations.of(context).myPageWishlistEmpty,
      );
    }

    final displayItems = items.take(4).toList(growable: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 600
            ? 1
            : constraints.maxWidth < 1000
            ? 2
            : 4;
        return Column(
          children: [
            for (var start = 0; start < displayItems.length; start += columns)
              Padding(
                padding: EdgeInsets.only(top: start == 0 ? 0 : AppSpacing.md),
                child: ProductCardRow(
                  columns: columns,
                  spacing: AppSpacing.md,
                  cards: [
                    for (final item in displayItems.skip(start).take(columns))
                      _card(context, item),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _card(BuildContext context, WishlistItem item) {
    return MyPageCompactProductCard(
      key: ValueKey(item.productId),
      stacked: true,
      title: item.name,
      subtitle:
          item.platform ??
          item.categoryDisplayName ??
          AppLocalizations.of(context).externalUnanalyzed,
      imageUrl: item.imageUrl,
      price: item.price,
      rating: item.avgRating,
      reviewCount: item.reviewCount,
      analysis: item.analysisDisplay,
      analyzedReviewCount: item.summary?.catalogAnalysis?.reviewCount,
      onTap: () => onProductTap(item),
    );
  }
}

class MyPageCompactProductCard extends StatelessWidget {
  const MyPageCompactProductCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.analysis,
    required this.onTap,
    this.analyzedReviewCount,
    this.gradeLabel,
    this.stacked = false,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final int? price;
  final double? rating;
  final int? reviewCount;
  final AnalysisDisplay analysis;
  final int? analyzedReviewCount;
  final String? gradeLabel;
  final VoidCallback onTap;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          price == null
              ? AppLocalizations.of(context).homePriceUnavailable
              : myPageFormatPrice(context, price!),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (gradeLabel case final String grade)
          Text(
            grade,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: analysis.color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ProductReviewMetrics(
          rating: rating,
          reviewCount: reviewCount,
          analysis: analysis,
          analyzedReviewCount: analyzedReviewCount,
        ),
      ],
    );

    return MyPagePanel(
      onTap: onTap,
      padding: stacked ? EdgeInsets.zero : const EdgeInsets.all(AppSpacing.md),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: productCardImageAspectRatio,
                  child: AppNetworkImage(
                    url: imageUrl,
                    thumbnailWidth: 480,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.sm),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: details,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: 96,
                  child: AppNetworkImage(
                    url: imageUrl,
                    thumbnailWidth: 240,
                    borderRadius: AppRadius.small,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: details),
              ],
            ),
    );
  }
}

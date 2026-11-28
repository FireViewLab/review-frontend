import 'package:re_view_front/shared/widgets/product_card_layout.dart';
import 'package:re_view_front/shared/widgets/product_review_metrics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_actions.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.item,
    required this.isToggling,
    required this.onRemove,
  });

  final WishlistItem item;
  final bool isToggling;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Align(
                heightFactor: 1,
                child: AspectRatio(
                  aspectRatio: productCardImageAspectRatio,
                  child: AppNetworkImage(
                    url: item.imageUrl,
                    thumbnailWidth: 480,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.platform != null || item.isPriceDrop)
                    Wrap(
                      spacing: AppSpacing.xxs,
                      runSpacing: AppSpacing.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.platform case final String platform)
                          Text(
                            platform,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                          ),
                        if (item.isPriceDrop) _PriceDropBadge(),
                      ],
                    ),
                  const SizedBox(height: 2),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      height: 1.22,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ProductReviewMetrics(
                    rating: item.avgRating,
                    reviewCount: item.reviewCount,
                    analysis: item.analysisDisplay,
                    analyzedReviewCount:
                        item.summary?.catalogAnalysis?.reviewCount,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.price == null
                        ? AppLocalizations.of(context).homePriceUnavailable
                        : formatSearchPrice(item.price!),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: 36,
                        child: isToggling
                            ? const Center(
                                child: SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: onRemove,
                                style: outlineHoverButtonStyle(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                              ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 36),
                          child: OutlinedButton(
                            onPressed: () => context.go(
                              item.detailPath,
                              extra: item.routeContext,
                            ),
                            style: outlineHoverButtonStyle(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: AppSpacing.xxs,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context).wishlistProductView,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceDropBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_down_rounded,
              color: AppColors.error,
              size: 12,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                AppLocalizations.of(context).wishlistProductPriceDrop,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

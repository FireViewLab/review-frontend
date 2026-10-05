import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';
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
    final rtiColor = item.rtiColor == null
        ? AppColors.textTertiary
        : colorFromHex(item.rtiColor!);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(url: item.imageUrl),
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: item.avgRti == null ||
                            item.rtiGrade == null ||
                            item.rtiColor == null
                        ? Text(AppLocalizations.of(context).externalUnanalyzed)
                        : RtiBadge(
                            value: item.avgRti!.round(),
                            color: rtiColor,
                          ),
                  ),
                  if (item.isPriceDrop)
                    Positioned(
                      top: AppSpacing.xs,
                      right: AppSpacing.xs,
                      child: _PriceDropBadge(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.platform ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 13,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        item.avgRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          '(리뷰 ${formatSearchCount(item.reviewCount)})',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    formatSearchPrice(item.price),
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
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () => context.goNamed(
                              RouteNames.productDetail,
                              pathParameters: {'id': item.productId.toString()},
                            ),
                            style: outlineHoverButtonStyle(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context).wishlistProductView,
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
            Text(
              AppLocalizations.of(context).wishlistProductPriceDrop,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class WishlistSummaryCard extends StatelessWidget {
  const WishlistSummaryCard({
    super.key,
    required this.summary,
    required this.totalCount,
  });

  final WishlistSummary summary;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bar_chart_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  AppLocalizations.of(context).wishlistSummaryTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context).wishlistSummaryTotal(totalCount),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.trending_down_rounded,
                    iconColor: AppColors.error,
                    bgColor: AppColors.errorSoft,
                    value: summary.hasPriceDropInformation
                        ? '${summary.priceDropCount}개'
                        : '정보 없음',
                    label: AppLocalizations.of(
                      context,
                    ).wishlistSummaryPriceDrop,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.notifications_outlined,
                    iconColor: AppColors.info,
                    bgColor: AppColors.infoSoft,
                    value: '${summary.newAlertCount}개',
                    label: AppLocalizations.of(context).wishlistSummaryNewAlert,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.rate_review_outlined,
                    iconColor: AppColors.textSecondary,
                    bgColor: AppColors.surfaceMuted,
                    value: '${summary.totalReviewCount}개',
                    label: AppLocalizations.of(
                      context,
                    ).wishlistSummaryTotalReview,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  const _SummaryStatItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

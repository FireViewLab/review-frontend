// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageStatGrid extends StatelessWidget {
  const MyPageStatGrid({
    required this.wishlistCount,
    required this.recentCount,
    required this.riskyCount,
    required this.notificationCount,
    required this.onWishlistTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onNotificationTap,
  });

  final int? wishlistCount;
  final int? recentCount;
  final int? riskyCount;
  final int notificationCount;
  final VoidCallback onWishlistTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final width = context.viewportSize.width;
    final columns = width < 700
        ? 1
        : width < 1100
        ? 2
        : 4;
    final l10n = AppLocalizations.of(context);
    final stats = [
      MyPageStatItem(
        icon: Icons.favorite_border,
        label: l10n.myPageSideNavWishlist,
        value: wishlistCount?.toString() ?? '—',
        onTap: onWishlistTap,
      ),
      MyPageStatItem(
        icon: Icons.history,
        label: l10n.myPageSideNavRecentlyViewed,
        value: recentCount?.toString() ?? '—',
        onTap: onRecentTap,
      ),
      MyPageStatItem(
        icon: Icons.warning_amber_rounded,
        label: l10n.myPageSideNavRiskyProducts,
        value: riskyCount?.toString() ?? '—',
        onTap: onReviewTap,
      ),
      MyPageStatItem(
        icon: Icons.notifications_none,
        label: l10n.myPageSideNavAlerts,
        value: notificationCount.toString(),
        onTap: onNotificationTap,
      ),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 92,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) => MyPageStatCard(item: stats[index]),
    );
  }
}

class MyPageStatItem {
  const MyPageStatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
}

class MyPageStatCard extends StatelessWidget {
  const MyPageStatCard({required this.item});

  final MyPageStatItem item;

  @override
  Widget build(BuildContext context) {
    return MyPagePanel(
      onTap: item.onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageRecentActivitySection extends ConsumerWidget {
  const MyPageRecentActivitySection({
    required this.savedItems,
    required this.recentProducts,
    required this.onProductTap,
  });

  final List<WishlistItem> savedItems;
  final List<DashboardProduct> recentProducts;
  final ValueChanged<String> onProductTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 서버 활동 기록을 우선 쓰고, 불러오지 못하면 찜·최근 본 상품으로 대신한다.
    final serverActivities = ref.watch(myActivitiesProvider).value;
    final activities = <MyPageActivityItem>[
      if (serverActivities != null)
        for (final activity in serverActivities)
          MyPageActivityItem(
            icon: activity.type == 'FEEDBACK_SUBMIT'
                ? Icons.rate_review_outlined
                : Icons.favorite_border,
            title: activity.description,
            trailing: _relativeDate(activity.createdAt),
            onTap: () => switch (activity.type) {
              'WISHLIST_ADD' when activity.targetId != null => onProductTap(
                activity.targetId!,
              ),
              'FEEDBACK_SUBMIT' => context.go(RoutePaths.feedbackHistory),
              _ => null,
            },
          )
      else ...[
        for (final item in savedItems.take(2))
          MyPageActivityItem(
            icon: Icons.favorite_border,
            title: '"${item.name}" 상품을 저장했어요.',
            trailing: _relativeDate(item.savedAt),
            onTap: () => context.go(item.detailPath, extra: item.routeContext),
          ),
        for (final item in recentProducts.take(2))
          MyPageActivityItem(
            icon: Icons.history,
            title: '"${item.name}" 상품을 확인했어요.',
            trailing: AppLocalizations.of(context).myPageRecentLabel,
            onTap: () => context.go(item.detailPath, extra: item.routeContext),
          ),
      ],
    ];

    return MyPagePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyPagePanelTitle(
            title: AppLocalizations.of(context).myPageRecentActivity,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (activities.isEmpty)
            MyPageInlineEmpty(
              message: AppLocalizations.of(context).myPageRecentActivityEmpty,
            )
          else
            for (final activity in activities)
              MyPageActivityTile(item: activity),
        ],
      ),
    );
  }
}

class MyPageActivityItem {
  const MyPageActivityItem({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback onTap;
}

class MyPageActivityTile extends StatelessWidget {
  const MyPageActivityTile({required this.item});

  final MyPageActivityItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(item.icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              item.trailing,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

String _relativeDate(DateTime? date) {
  if (date == null) return '최근';
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 1) return '${diff.inDays}일 전';
  if (diff.inHours >= 1) return '${diff.inHours}시간 전';
  return '방금 전';
}

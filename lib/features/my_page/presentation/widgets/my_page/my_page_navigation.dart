// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageTitle extends StatelessWidget {
  const MyPageTitle({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(AppLocalizations.of(context).navHome),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            Text(
              AppLocalizations.of(context).navMyPage,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              AppLocalizations.of(context).myPageTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${profile.nickname}님의 정보와 저장한 상품 활동을 관리해요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyPageSideNavCard extends StatelessWidget {
  const MyPageSideNavCard({
    required this.profile,
    required this.onTopTap,
    required this.onCartTap,
    required this.onWishlistTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onSettingsTap,
  });

  final UserProfile profile;
  final VoidCallback onTopTap;
  final VoidCallback onCartTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return MyPagePanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    profile.initials,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  profile.nickname.isEmpty
                      ? AppLocalizations.of(context).myPageDefaultName
                      : profile.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      profile.role.isEmpty
                          ? AppLocalizations.of(context).myPageMemberBasic
                          : AppLocalizations.of(
                              context,
                            ).settingsAccountMemberLabel(profile.role),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          MyPageSideNavItem(
            icon: Icons.home_outlined,
            label: AppLocalizations.of(context).myPageSideNavMyPage,
            selected: true,
            onTap: onTopTap,
          ),
          MyPageSideNavItem(
            icon: Icons.inventory_2_outlined,
            label: AppLocalizations.of(context).myPageSideNavOrders,
            onTap: onCartTap,
          ),
          MyPageSideNavItem(
            icon: Icons.favorite_border,
            label: AppLocalizations.of(context).myPageSideNavWishlist,
            onTap: onWishlistTap,
          ),
          MyPageSideNavItem(
            icon: Icons.history,
            label: AppLocalizations.of(context).myPageSideNavRecentlyViewed,
            onTap: onRecentTap,
          ),
          MyPageSideNavItem(
            icon: Icons.rate_review_outlined,
            label: AppLocalizations.of(context).sideNavReviewActivity,
            onTap: onReviewTap,
          ),
          MyPageSideNavItem(
            icon: Icons.feedback_outlined,
            label: AppLocalizations.of(context).sideNavFeedbackHistory,
            onTap: () => context.go(RoutePaths.feedbackHistory),
          ),
          MyPageSideNavItem(
            icon: Icons.workspace_premium_outlined,
            label: AppLocalizations.of(context).myPageSideNavPlan,
            onTap: () => context.go(RoutePaths.plan),
          ),
          MyPageSideNavItem(
            icon: Icons.settings_outlined,
            label: AppLocalizations.of(context).sideNavAccountSettings,
            onTap: () => context.go(RoutePaths.settings),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class MyPageSideNavItem extends StatelessWidget {
  const MyPageSideNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    left: BorderSide(color: AppColors.primary, width: 3),
                  )
                : null,
          ),
          padding: EdgeInsets.only(
            left: selected ? AppSpacing.lg - 3 : AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textPrimary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

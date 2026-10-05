import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 계정 영역 안에서 내용만 바꾸는 메뉴.
List<({IconData icon, String label, String path})> _sections(
  AppLocalizations l10n,
) => [
  (
    icon: Icons.home_outlined,
    label: l10n.myPageSideNavMyPage,
    path: RoutePaths.myPage,
  ),
  (
    icon: Icons.workspace_premium_outlined,
    label: l10n.myPageSideNavPlan,
    path: RoutePaths.plan,
  ),
  (
    icon: Icons.feedback_outlined,
    label: l10n.sideNavFeedbackHistory,
    path: RoutePaths.feedbackHistory,
  ),
  (
    icon: Icons.settings_outlined,
    label: l10n.sideNavAccountSettings,
    path: RoutePaths.settings,
  ),
];

/// 넓은 화면에서 왼쪽에 두는 세로 메뉴. 위에는 내 정보를 보여 준다.
class AccountSideNav extends StatelessWidget {
  const AccountSideNav({super.key, required this.location, this.profile});

  final String location;

  /// 아직 불러오지 못했으면 null이고, 그때는 내 정보 자리를 비워 둔다.
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final profile = this.profile;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (profile != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      profile.initials,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    profile.nickname.isEmpty
                        ? l10n.myPageDefaultName
                        : profile.nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    profile.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
          ],
          const SizedBox(height: AppSpacing.xs),
          for (final section in _sections(l10n))
            _SideNavItem(
              icon: section.icon,
              label: section.label,
              selected: location == section.path,
              onTap: () => context.go(section.path),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Divider(height: 1, color: AppColors.border),
          ),
          // 아래 둘은 다른 화면으로 나간다.
          _SideNavItem(
            icon: Icons.favorite_border,
            label: l10n.myPageSideNavWishlist,
            onTap: () => context.go(RoutePaths.wishlist),
          ),
          _SideNavItem(
            icon: Icons.shopping_cart_outlined,
            label: l10n.myPageSideNavOrders,
            onTap: () => context.go(RoutePaths.cart),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
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
    final color = selected ? AppColors.primary : AppColors.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: selected ? null : onTap,
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            height: 52,
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryLight : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.only(
              left: AppSpacing.lg - 3,
              right: AppSpacing.lg,
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 좁은 화면에서 내용 위에 두는 가로 탭.
class AccountTabBar extends StatelessWidget {
  const AccountTabBar({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final section in _sections(l10n))
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _Tab(
                label: section.label,
                selected: location == section.path,
                onTap: () => context.go(section.path),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(999));
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: InkWell(
          onTap: selected ? null : onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? AppColors.onPrimary : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

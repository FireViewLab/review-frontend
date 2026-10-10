import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AdminTopBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  static const double height = 64;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unreadCount = ref.watch(isLoggedInProvider)
        ? ref.watch(unreadNotificationCountProvider).value ?? 0
        : 0;
    final tokenStore = ref.read(authTokenStoreProvider.notifier);
    final nickname = tokenStore.nickname ?? l10n.adminSidebarTitle;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = AppBreakpoints.isMobile(width);

    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? AppSpacing.md : AppSpacing.lg,
        ),
        child: Row(
          children: [
            if (onMenuTap != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  color: AppColors.textPrimary,
                  onPressed: onMenuTap,
                  tooltip: l10n.adminSidebarTitle,
                ),
              ),
            const Spacer(),
            IconButton(
              tooltip: l10n.adminTopBarNotifications,
              onPressed: () => context.go(RoutePaths.notifications),
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
                child: const Icon(Icons.notifications_none_rounded),
              ),
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Flexible로 두면 Spacer와 남은 폭을 반씩 나눠 알림 벨이 가운데로 밀린다.
            if (!isCompact)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: _ProfileBadge(nickname: nickname),
              ),
            if (isCompact) _ProfileAvatar(nickname: nickname),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProfileAvatar(nickname: nickname),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    final initial = nickname.isEmpty ? '?' : nickname.characters.first;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}

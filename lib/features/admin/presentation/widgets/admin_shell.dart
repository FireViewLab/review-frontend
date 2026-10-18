import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_top_bar.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = !AppBreakpoints.isMobile(width) &&
        !AppBreakpoints.isTablet(width);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final l10n = AppLocalizations.of(context);
    final items = _AdminMenuItem.all(l10n);
    final tokenStore = ref.read(authTokenStoreProvider.notifier);
    final profile = _AdminProfile(
      nickname: tokenStore.nickname ?? l10n.adminSidebarTitle,
      role: tokenStore.role ?? 'ADMIN',
    );

    final sidebar = _AdminSidebar(
      items: items,
      currentLocation: currentLocation,
      profile: profile,
      onLogout: () => _logout(context),
      onNavigate: (path) {
        if (!isDesktop) {
          Navigator.of(context).maybePop();
        }
        context.go(path);
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: isDesktop ? null : Drawer(child: SafeArea(child: sidebar)),
      body: SafeArea(
        child: Column(
          children: [
            AdminTopBar(
              onMenuTap: isDesktop
                  ? null
                  : () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop) sidebar,
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await ref.read(logoutUseCaseProvider).call();
    if (context.mounted) {
      context.go(RoutePaths.landing);
    }
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({
    required this.items,
    required this.currentLocation,
    required this.profile,
    required this.onLogout,
    required this.onNavigate,
  });

  final List<_AdminMenuItem> items;
  final String currentLocation;
  final _AdminProfile profile;
  final VoidCallback onLogout;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'R',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.adminSidebarTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              children: [
                for (final item in items)
                  _AdminMenuTile(
                    item: item,
                    isActive: _isActive(item.path, currentLocation),
                    onTap: () => onNavigate(item.path),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: _SidebarProfileCard(
              profile: profile,
              onLogout: onLogout,
              logoutLabel: l10n.adminMenuLogout,
            ),
          ),
        ],
      ),
    );
  }

  bool _isActive(String path, String current) {
    if (path == RoutePaths.admin) {
      return current == RoutePaths.admin;
    }
    return current == path || current.startsWith('$path/');
  }
}

class _AdminMenuTile extends StatelessWidget {
  const _AdminMenuTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _AdminMenuItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Material(
        color: isActive ? AppColors.primaryLight : Colors.transparent,
        borderRadius: AppRadius.medium,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.medium,
          child: Stack(
            children: [
              if (isActive)
                Positioned(
                  left: 0,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarProfileCard extends StatelessWidget {
  const _SidebarProfileCard({
    required this.profile,
    required this.onLogout,
    required this.logoutLabel,
  });

  final _AdminProfile profile;
  final VoidCallback onLogout;
  final String logoutLabel;

  @override
  Widget build(BuildContext context) {
    final initial = profile.nickname.isEmpty
        ? '?'
        : profile.nickname.characters.first;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.nickname,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  profile.role,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 18),
            color: AppColors.textSecondary,
            tooltip: logoutLabel,
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _AdminProfile {
  const _AdminProfile({required this.nickname, required this.role});

  final String nickname;
  final String role;
}

class _AdminMenuItem {
  const _AdminMenuItem({
    required this.path,
    required this.label,
    required this.icon,
  });

  final String path;
  final String label;
  final IconData icon;

  static List<_AdminMenuItem> all(AppLocalizations l10n) => [
        _AdminMenuItem(
          path: RoutePaths.admin,
          label: l10n.adminMenuDashboard,
          icon: Icons.dashboard_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminReviews,
          label: l10n.adminMenuSuspiciousReviews,
          icon: Icons.rate_review_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminReports,
          label: l10n.adminMenuReports,
          icon: Icons.flag_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminAnalysisFeedbacks,
          label: l10n.adminMenuAnalysisFeedbacks,
          icon: Icons.fact_check_outlined,
        ),
        _AdminMenuItem(
          path: RoutePaths.adminUsers,
          label: l10n.adminMenuUsers,
          icon: Icons.people_outline,
        ),
        const _AdminMenuItem(
          path: RoutePaths.adminBanners,
          label: '배너 관리',
          icon: Icons.view_carousel_outlined,
        ),
      ];
}

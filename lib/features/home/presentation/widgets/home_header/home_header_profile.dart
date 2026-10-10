// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class HeaderUserProfileButton extends StatefulWidget {
  const HeaderUserProfileButton({
    super.key,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
    this.compact = false,
  });

  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;
  final bool compact;

  @override
  State<HeaderUserProfileButton> createState() =>
      HomeHeaderUserProfileButtonState();
}

class HomeHeaderUserProfileButtonState extends State<HeaderUserProfileButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  String _maskName(String name) {
    if (name.length <= 1) return name;
    return name[0] + '*' * (name.length - 1);
  }

  void _toggle() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 8),
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              child: GestureDetector(
                // Consume internal taps so the parent dismissal layer does not close the menu.
                onTap: () {},
                child: HomeHeaderProfileDropdown(
                  nickname: widget.nickname,
                  onMyPagePressed: () {
                    _removeOverlay();
                    widget.onMyPagePressed?.call();
                  },
                  onProfileWishPressed: () {
                    _removeOverlay();
                    widget.onProfileWishPressed?.call();
                  },
                  onProfileOrderPressed: () {
                    _removeOverlay();
                    widget.onProfileOrderPressed?.call();
                  },
                  onLogoutPressed: () {
                    _removeOverlay();
                    widget.onLogoutPressed?.call();
                  },
                  onAdminPressed: () {
                    _removeOverlay();
                    context.go(RoutePaths.admin);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.nickname != null && widget.nickname!.isNotEmpty
        ? _maskName(widget.nickname!)
        : '내 계정';

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: widget.compact
              ? Icon(
                  Icons.person,
                  size: 24,
                  color: _isOpen ? AppColors.primary : AppColors.textPrimary,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 24,
                      color: _isOpen
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 긴 닉네임이 헤더 액션 줄을 밀어내지 않게 폭을 제한한다.
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 64),
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: _isOpen
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 14,
                          color: _isOpen
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class HomeHeaderProfileDropdown extends StatelessWidget {
  const HomeHeaderProfileDropdown({
    this.nickname,
    required this.onMyPagePressed,
    required this.onProfileWishPressed,
    required this.onProfileOrderPressed,
    required this.onLogoutPressed,
    required this.onAdminPressed,
  });

  final String? nickname;
  final VoidCallback onMyPagePressed;
  final VoidCallback onProfileWishPressed;
  final VoidCallback onProfileOrderPressed;
  final VoidCallback onLogoutPressed;
  final VoidCallback onAdminPressed;

  @override
  Widget build(BuildContext context) {
    final displayName = nickname != null && nickname!.isNotEmpty
        ? nickname!
        : '회원';

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty ? displayName[0] : '?',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$displayName님',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Re:view 멤버',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            HomeHeaderDropdownItem(
              icon: Icons.person_outline,
              label: '마이페이지',
              onTap: onMyPagePressed,
            ),
            HomeHeaderDropdownItem(
              icon: Icons.favorite_border,
              label: '찜한 상품',
              onTap: onProfileWishPressed,
            ),
            HomeHeaderDropdownItem(
              icon: Icons.receipt_long_outlined,
              label: '주문/활동',
              onTap: onProfileOrderPressed,
            ),
            // 관리자 계정에만 보인다. 권한은 로그인 응답의 role 기준이다.
            Consumer(
              builder: (context, ref, _) => ref.watch(isAdminProvider)
                  ? HomeHeaderDropdownItem(
                      icon: Icons.admin_panel_settings_outlined,
                      label: AppLocalizations.of(context).adminSidebarTitle,
                      onTap: onAdminPressed,
                    )
                  : const SizedBox.shrink(),
            ),
            const Divider(height: 1, color: AppColors.border),
            HomeHeaderDropdownItem(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: onLogoutPressed,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeaderDropdownItem extends StatelessWidget {
  const HomeHeaderDropdownItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

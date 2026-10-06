// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/brand/home_logo.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_bar.dart'
    as home;
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_types.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_profile.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_menu.dart';

class HomeHeaderDesktop extends StatelessWidget {
  const HomeHeaderDesktop({
    required this.navItems,
    required this.selectedNavItem,
    required this.showCategoryNav,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.onSearchSubmitted,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.onLogoPressed,
    this.searchFocusNode,
    this.searchQuery,
    this.cartCount,
    this.wishlistCount,
    this.onNotificationPressed,
    this.unreadNotificationCount = 0,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final bool showCategoryNav;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final ValueChanged<String>? onSearchSubmitted;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final VoidCallback? onLogoPressed;
  final FocusNode? searchFocusNode;
  final String? searchQuery;
  final int? cartCount;
  final int? wishlistCount;
  final VoidCallback? onNotificationPressed;
  final int unreadNotificationCount;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final searchWidth = (context.viewportSize.width * 0.34).clamp(440.0, 560.0);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 360,
              child: Row(
                children: [
                  HomeLogo(onTap: onLogoPressed),
                  const SizedBox(width: AppSpacing.xxl),
                  HomeHeaderTopLink(label: '고객센터', onTap: onLoginPressed),
                  const SizedBox(width: AppSpacing.lg),
                  HomeHeaderTopLink(label: '판매자 입점', onTap: onLoginPressed),
                  const SizedBox(width: AppSpacing.lg),
                  HomeHeaderTopLink(label: '앱 다운로드', onTap: onLoginPressed),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: searchWidth,
                  child: home.SearchBar(
                    focusNode: searchFocusNode,
                    initialValue: searchQuery,
                    popularKeywords: searchKeywords,
                    recommendedProducts: searchRecommendedProducts,
                    onSuggestionsRequested: onSearchSuggestionsRequested,
                    onSubmitted: onSearchSubmitted,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isLoggedIn ? 300 : 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isLoggedIn) ...[
                    HeaderUserProfileButton(
                      nickname: nickname,
                      onMyPagePressed: onMyPagePressed,
                      onProfileWishPressed: onProfileWishPressed,
                      onProfileOrderPressed: onProfileOrderPressed,
                      onLogoutPressed: onLogoutPressed,
                    ),
                    HomeHeaderAction(
                      icon: Icons.notifications_none,
                      label: AppLocalizations.of(context).headerNotifications,
                      onTap: onNotificationPressed,
                      badge: _badgeLabel(unreadNotificationCount),
                    ),
                    HomeHeaderAction(
                      icon: Icons.favorite_border,
                      label: '찜',
                      onTap: onWishPressed,
                      badge: wishlistCount == null || wishlistCount == 0
                          ? null
                          : '$wishlistCount',
                    ),
                    HomeHeaderAction(
                      icon: Icons.shopping_cart_outlined,
                      label: '장바구니',
                      onTap: onCartPressed,
                      badge: cartCount == null || cartCount == 0
                          ? null
                          : '$cartCount',
                    ),
                  ] else ...[
                    HomeHeaderAction(
                      icon: Icons.person_outline,
                      label: '로그인',
                      onTap: onLoginPressed,
                    ),
                    HomeHeaderAction(
                      icon: Icons.favorite_border,
                      label: '찜',
                      onTap: onWishPressed,
                      badge: wishlistCount == null || wishlistCount == 0
                          ? null
                          : '$wishlistCount',
                    ),
                    HomeHeaderAction(
                      icon: Icons.shopping_cart_outlined,
                      label: '장바구니',
                      onTap: onCartPressed,
                      badge: cartCount == null || cartCount == 0
                          ? null
                          : '$cartCount',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (showCategoryNav) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              HomeHeaderCategoryMenuButton(
                products: searchRecommendedProducts,
                onCategorySelected: onNavItemPressed,
              ),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in navItems)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xl),
                          child: TextButton(
                            onPressed: () => onNavItemPressed(item),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: item == selectedNavItem
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: item == selectedNavItem
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    fontWeight: item == selectedNavItem
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class HomeHeaderTopLink extends StatelessWidget {
  const HomeHeaderTopLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class HomeHeaderMobile extends StatelessWidget {
  const HomeHeaderMobile({
    this.onLogoPressed,
    required this.onLoginPressed,
    required this.onNotificationPressed,
    this.unreadNotificationCount = 0,
    required this.onCartPressed,
    this.onSearchSubmitted,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.searchFocusNode,
    this.searchQuery,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
  });

  final VoidCallback? onLogoPressed;
  final VoidCallback onLoginPressed;
  final VoidCallback onNotificationPressed;
  final int unreadNotificationCount;
  final VoidCallback onCartPressed;
  final ValueChanged<String>? onSearchSubmitted;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final FocusNode? searchFocusNode;
  final String? searchQuery;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HomeLogo(onTap: onLogoPressed),
            const Spacer(),
            if (isLoggedIn)
              HeaderUserProfileButton(
                nickname: nickname,
                onMyPagePressed: onMyPagePressed,
                onProfileWishPressed: onProfileWishPressed,
                onProfileOrderPressed: onProfileOrderPressed,
                onLogoutPressed: onLogoutPressed,
                compact: true,
              )
            else
              IconButton(
                tooltip: '로그인',
                onPressed: onLoginPressed,
                icon: const Icon(Icons.person_outline),
              ),
            if (isLoggedIn)
              IconButton(
                tooltip: AppLocalizations.of(context).headerNotifications,
                onPressed: onNotificationPressed,
                icon: Badge(
                  isLabelVisible: unreadNotificationCount > 0,
                  label: Text(_badgeLabel(unreadNotificationCount) ?? ''),
                  child: const Icon(Icons.notifications_none),
                ),
              ),
            IconButton(
              tooltip: '장바구니',
              onPressed: onCartPressed,
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        home.SearchBar(
          focusNode: searchFocusNode,
          initialValue: searchQuery,
          popularKeywords: searchKeywords,
          recommendedProducts: searchRecommendedProducts,
          onSuggestionsRequested: onSearchSuggestionsRequested,
          onSubmitted: onSearchSubmitted,
        ),
      ],
    );
  }
}

class HomeHeaderAction extends StatelessWidget {
  const HomeHeaderAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 24, color: AppColors.textPrimary);

    return InkWell(
      borderRadius: AppRadius.small,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badge == null
                ? iconWidget
                : Badge(label: Text(badge!), child: iconWidget),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 배지 숫자. 0이면 표시하지 않고, 100 이상은 99+로 줄인다.
String? _badgeLabel(int count) {
  if (count <= 0) return null;
  return count > 99 ? '99+' : '$count';
}

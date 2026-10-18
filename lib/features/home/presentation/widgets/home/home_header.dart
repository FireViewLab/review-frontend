import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_types.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_layouts.dart';
export 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_profile.dart'
    show HeaderUserProfileButton;
export 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_types.dart'
    show SearchSuggestionsRequested;

class HomeHeader extends ConsumerWidget {
  const HomeHeader({
    required this.navItems,
    required this.selectedNavItem,
    required this.onLoginPressed,
    required this.onWishPressed,
    required this.onCartPressed,
    required this.onNavItemPressed,
    this.showCategoryNav = true,
    this.searchKeywords = const [],
    this.searchRecommendedProducts = const [],
    this.onSearchSuggestionsRequested,
    this.onSearchSubmitted,
    this.onLogoPressed,
    this.searchFocusNode,
    this.searchQuery,
    this.cartCount,
    this.wishlistCount,
    this.isLoggedIn = false,
    this.nickname,
    this.onMyPagePressed,
    this.onProfileWishPressed,
    this.onProfileOrderPressed,
    this.onLogoutPressed,
    super.key,
  });

  final List<String> navItems;
  final String selectedNavItem;
  final VoidCallback onLoginPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onCartPressed;
  final ValueChanged<String> onNavItemPressed;
  final bool showCategoryNav;
  final List<String> searchKeywords;
  final List<HomeProductData> searchRecommendedProducts;
  final SearchSuggestionsRequested? onSearchSuggestionsRequested;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onLogoPressed;
  final FocusNode? searchFocusNode;
  final String? searchQuery;
  final int? cartCount;
  final int? wishlistCount;
  final bool isLoggedIn;
  final String? nickname;
  final VoidCallback? onMyPagePressed;
  final VoidCallback? onProfileWishPressed;
  final VoidCallback? onProfileOrderPressed;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCompactHeader =
        context.isMobile || context.viewportSize.width < 1100;
    final effectiveCartCount =
        cartCount ?? ref.watch(cartItemCountProvider).value ?? 0;
    final effectiveWishlistCount =
        wishlistCount ?? ref.watch(wishlistItemCountProvider).value ?? 0;
    final unreadNotificationCount = isLoggedIn
        ? ref.watch(unreadNotificationCountProvider).value ?? 0
        : 0;
    void openNotifications() => context.go(RoutePaths.notifications);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.md,
            context.isMobile ? AppSpacing.md : AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: useCompactHeader
              ? HomeHeaderMobile(
                  onLogoPressed: onLogoPressed,
                  onLoginPressed: onLoginPressed,
                  onNotificationPressed: openNotifications,
                  unreadNotificationCount: unreadNotificationCount,
                  onCartPressed: onCartPressed,
                  onSearchSubmitted: onSearchSubmitted,
                  searchKeywords: searchKeywords,
                  searchRecommendedProducts: searchRecommendedProducts,
                  onSearchSuggestionsRequested: onSearchSuggestionsRequested,
                  searchFocusNode: searchFocusNode,
                  searchQuery: searchQuery,
                  isLoggedIn: isLoggedIn,
                  nickname: nickname,
                  onMyPagePressed: onMyPagePressed,
                  onProfileWishPressed: onProfileWishPressed,
                  onProfileOrderPressed: onProfileOrderPressed,
                  onLogoutPressed: onLogoutPressed,
                )
              : HomeHeaderDesktop(
                  navItems: navItems,
                  selectedNavItem: selectedNavItem,
                  showCategoryNav: showCategoryNav,
                  onLoginPressed: onLoginPressed,
                  onWishPressed: onWishPressed,
                  onCartPressed: onCartPressed,
                  onNavItemPressed: onNavItemPressed,
                  onSearchSubmitted: onSearchSubmitted,
                  searchKeywords: searchKeywords,
                  searchRecommendedProducts: searchRecommendedProducts,
                  onSearchSuggestionsRequested: onSearchSuggestionsRequested,
                  onLogoPressed: onLogoPressed,
                  searchFocusNode: searchFocusNode,
                  searchQuery: searchQuery,
                  cartCount: effectiveCartCount,
                  wishlistCount: effectiveWishlistCount,
                  onNotificationPressed: openNotifications,
                  unreadNotificationCount: unreadNotificationCount,
                  isLoggedIn: isLoggedIn,
                  nickname: nickname,
                  onMyPagePressed: onMyPagePressed,
                  onProfileWishPressed: onProfileWishPressed,
                  onProfileOrderPressed: onProfileOrderPressed,
                  onLogoutPressed: onLogoutPressed,
                ),
        ),
      ),
    );
  }
}

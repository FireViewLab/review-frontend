import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_navigation.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

/// 마이페이지·요금제·피드백 내역·계정 설정이 함께 쓰는 틀.
///
/// 헤더와 메뉴는 그대로 두고 [child]만 바뀐다. 메뉴를 누를 때마다 화면 전체가
/// 새로 그려지지 않게 하려는 것이다.
class AccountShell extends ConsumerWidget {
  const AccountShell({super.key, required this.location, required this.child});

  /// 지금 보고 있는 경로. 메뉴에서 선택 표시를 하는 데 쓴다.
  final String location;
  final Widget child;

  /// 이 너비부터 메뉴를 왼쪽에 세로로 둔다.
  static const _sideNavBreakpoint = 980.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final cartCount = ref.watch(cartItemCountProvider).value ?? 0;
    final wishlistCount = ref.watch(wishlistItemCountProvider).value ?? 0;
    final profile = switch (ref.watch(myPageViewModelProvider)) {
      MyPageSuccess(:final profile) => profile,
      _ => null,
    };
    final wide = context.viewportSize.width >= _sideNavBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              cartCount: cartCount,
              wishlistCount: wishlistCount,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onNavItemPressed: (item) => openHomeNavItem(context, item),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              searchKeywords: const [],
              searchRecommendedProducts: const [],
              onSearchSuggestionsRequested: (query) => ref
                  .read(searchAutocompleteRemoteDataSourceProvider)
                  .fetchSuggestions(query),
              onMyPagePressed: () => context.go(RoutePaths.myPage),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: () {
                ref.read(authTokenStoreProvider.notifier).clear();
                context.go(RoutePaths.landing);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1320,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 260,
                          child: AccountSideNav(
                            location: location,
                            profile: profile,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                        Expanded(child: child),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AccountTabBar(location: location),
                        const SizedBox(height: AppSpacing.lg),
                        child,
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

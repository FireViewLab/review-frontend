import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';

/// 헤더는 유지하고, 높이가 제한된 Navigator 안에서 본문만 전환한다.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.uri, required this.child});

  final Uri uri;
  final Widget child;

  static void focusSearch(BuildContext context) {
    context
        .findAncestorStateOfType<_AppShellState>()
        ?._searchFocus
        .requestFocus();
  }

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _searchFocus = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _syncSearchQuery();
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget.uri) {
      _searchFocus.unfocus();
      _syncSearchQuery();
    }
  }

  void _syncSearchQuery() {
    if (widget.uri.path == RoutePaths.search) {
      _searchQuery =
          widget.uri.queryParameters['q']?.trim() ??
          widget.uri.queryParameters['category']?.trim() ??
          '';
    }
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(isLoggedInProvider);
    final showRecommendations = {
      RoutePaths.home,
      RoutePaths.wishlist,
      RoutePaths.cart,
    }.contains(widget.uri.path);
    final dashboard = showRecommendations
        ? ref.watch(homeDashboardViewModelProvider)
        : const HomeDashboardEmpty();
    final keywords = switch (dashboard) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.trendingKeywords.map((k) => k.keyword).toList(),
      _ => const <String>[],
    };
    final products = switch (dashboard) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.recommendedProducts
            .map(
              (p) => HomeProductData(
                productId: p.id,
                name: p.name,
                storeName: p.storeName,
                priceLabel: '${p.price}원',
                ratingLabel: p.rating?.toStringAsFixed(1) ?? '-',
                reviewCountLabel: p.reviewCount?.toString() ?? '-',
                rtiLabel: p.rtiScore == null ? '' : 'RTI ${p.rtiScore}',
                imageUrl: p.imageUrl,
                label: p.label ?? '',
              ),
            )
            .toList(),
      _ => const <HomeProductData>[],
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            navItems: homeNavItems,
            selectedNavItem: widget.uri.path == RoutePaths.home ? '홈' : '',
            isLoggedIn: loggedIn,
            nickname: ref.watch(userNicknameProvider).value,
            searchQuery: _searchQuery,
            searchFocusNode: _searchFocus,
            searchKeywords: keywords,
            searchRecommendedProducts: products,
            onSearchSuggestionsRequested: (query) => ref
                .read(searchAutocompleteRemoteDataSourceProvider)
                .fetchSuggestions(query),
            onSearchSubmitted: (value) {
              final query = value.trim();
              if (query.isEmpty) return;
              _searchFocus.unfocus();
              if (widget.uri.path == RoutePaths.search &&
                  widget.uri.queryParameters.length == 1 &&
                  widget.uri.queryParameters['q'] == query) {
                ref.read(searchResubmissionProvider.notifier).submit();
                return;
              }
              context.goNamed(RouteNames.search, queryParameters: {'q': query});
            },
            onNavItemPressed: (item) => openHomeNavItem(context, item),
            onLogoPressed: () => context.go(RoutePaths.home),
            onLoginPressed: () => context.go(RoutePaths.login),
            onWishPressed: () => context.go(RoutePaths.wishlist),
            onCartPressed: () => context.go(RoutePaths.cart),
            onMyPagePressed: () => context.go(RoutePaths.myPage),
            onProfileWishPressed: () => context.go(RoutePaths.wishlist),
            onProfileOrderPressed: () => context.go(RoutePaths.cart),
            onLogoutPressed: () {
              ref.read(authTokenStoreProvider.notifier).clear();
              context.go(RoutePaths.landing);
            },
          ),
          // 내부 라우트의 모달 배리어가 헤더의 접근성 노드를 가리지 않게 한다.
          Expanded(child: Semantics(container: true, child: widget.child)),
        ],
      ),
    );
  }
}

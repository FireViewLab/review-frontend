import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_body.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  final _topKey = GlobalKey();
  final _savedKey = GlobalKey();
  final _recentKey = GlobalKey();
  final _settingsKey = GlobalKey();
  final _accountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wishlistViewModelProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    final myPageState = ref.watch(myPageViewModelProvider);
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    final cartCount = ref.watch(cartItemCountProvider).value ?? 0;
    final wishlistCount = ref.watch(wishlistItemCountProvider).value ?? 0;

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
              onSearchSubmitted: _handleSearchSubmitted,
              searchKeywords: _keywordsFrom(dashboardState),
              searchRecommendedProducts: _productsFrom(dashboardState),
              onSearchSuggestionsRequested: _handleSearchSuggestionsRequested,
              onMyPagePressed: () {},
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: _handleLogout,
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
              child: switch (myPageState) {
                MyPageLoading() => SizedBox(
                  height: 360,
                  child: AppLoadingView(message: AppLocalizations.of(context).myPageLoading),
                ),
                MyPageFailure(:final failure) => SizedBox(
                  height: 360,
                  child: AppErrorView(
                    message: failure.message,
                    onRetry: () =>
                        ref.read(myPageViewModelProvider.notifier).load(),
                  ),
                ),
                MyPageSuccess(:final profile) => MyPageBody(
                  profile: profile,
                  dashboardState: dashboardState,
                  wishlistState: wishlistState,
                  wishlistCount: wishlistCount,
                  onProductTap: _goProductDetail,
                  onWishlistTap: () => context.go(RoutePaths.wishlist),
                  onCartTap: () => context.go(RoutePaths.cart),
                  onPasswordTap: () => context.go(RoutePaths.passwordReset),
                  onTopTap: () => _scrollTo(_topKey),
                  onRecentTap: () => _scrollTo(_recentKey),
                  onReviewTap: () => _scrollTo(_recentKey),
                  onSettingsTap: () => _scrollTo(_settingsKey),
                  onAccountTap: () => _scrollTo(_accountKey),
                  topKey: _topKey,
                  savedKey: _savedKey,
                  recentKey: _recentKey,
                  settingsKey: _settingsKey,
                  accountKey: _accountKey,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _handleSearchSuggestionsRequested(String query) {
    return ref
        .read(searchAutocompleteRemoteDataSourceProvider)
        .fetchSuggestions(query);
  }

  void _handleSearchSubmitted(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.goNamed(RouteNames.search, queryParameters: {'q': query});
  }

  void _goProductDetail(String productId) {
    context.goNamed(
      RouteNames.productDetail,
      pathParameters: {'id': productId},
    );
  }

  void _handleLogout() {
    ref.read(authTokenStoreProvider.notifier).clear();
    context.go(RoutePaths.landing);
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: AppMotion.slow,
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  List<String> _keywordsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.trendingKeywords.map((k) => k.keyword).toList(),
      _ => const [],
    };
  }

  List<HomeProductData> _productsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(:final dashboard) =>
        dashboard.recommendedProducts
            .map(_toHomeProductData)
            .toList(growable: false),
      _ => const [],
    };
  }

  HomeProductData _toHomeProductData(DashboardProduct product) {
    return HomeProductData(
      productId: product.id,
      name: product.name,
      storeName: product.storeName,
      priceLabel: myPageFormatPrice(product.price),
      ratingLabel: product.rating?.toStringAsFixed(1) ?? '-',
      reviewCountLabel: product.reviewCount?.toString() ?? '-',
      rtiLabel: product.rtiScore == null ? '' : 'RTI ${product.rtiScore}',
      imageUrl: product.imageUrl,
      label: product.label ?? '',
    );
  }
}

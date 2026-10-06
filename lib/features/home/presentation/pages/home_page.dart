import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/app/router/app_shell.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/shared/widgets/app_fade_in.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/benefit_cta.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_footer.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/popular_category_section.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/product_recommendation_section.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/quick_category_row.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/review_trust_info_card.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/trending_keyword_chips.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/product_card_skeleton.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _categoryKey = GlobalKey();
  final _recommendationKey = GlobalKey();
  final _benefitKey = GlobalKey();
  final _popularCategoryKey = GlobalKey();
  // locale-independent: 'home' = main content; anything else = placeholder tab label

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shouldRefresh = ref.read(refreshHomeDashboardOnEnterProvider);
      if (!shouldRefresh) return;

      ref.read(refreshHomeDashboardOnEnterProvider.notifier).consume();
      ref.read(homeDashboardViewModelProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final useWideCommerceGrid = context.viewportSize.width >= 1120;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final catalog = ref.watch(homeCatalogProvider);
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final dashboardProducts = _recommendedProductsFrom(dashboardState);
    final dashboardKeywords = _trendingKeywordsFrom(dashboardState);
    final page = Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: context.isMobile ? 20 : 28),
              child: AppFadeIn(
                key: _heroKey,
                delay: 0,
                child: HeroBannerCarousel(
                  items: banners,
                  onBannerPressed: _handleBannerPressed,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1440,
              padding: _homeContentPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppFadeIn(
                    key: _categoryKey,
                    delay: 60,
                    child: QuickCategoryRow(
                      items: quickCategories,
                      onCategoryPressed: _handleCategoryPressed,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (dashboardState is HomeDashboardLoading) ...[
                    const ProductCardGridSkeleton(itemCount: 5),
                    const SizedBox(height: AppSpacing.xl),
                  ] else if (dashboardState is HomeDashboardFailure) ...[
                    SizedBox(
                      height: 280,
                      child: AppErrorView(
                        message: dashboardState.failure.message,
                        onRetry: () => ref
                            .read(homeDashboardViewModelProvider.notifier)
                            .refresh(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ] else ...[
                    AppFadeIn(
                      delay: 120,
                      child: TrendingKeywordChips(
                        keywords: dashboardKeywords,
                        onKeywordTap: _handleKeywordSearch,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  Text(
                    '상품 둘러보기',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  catalog.when(
                    loading: () => const ProductCardGridSkeleton(itemCount: 5),
                    error: (_, _) => SizedBox(
                      height: 280,
                      child: AppErrorView(
                        message: '상품을 불러오지 못했습니다.',
                        onRetry: () => ref.invalidate(homeCatalogProvider),
                      ),
                    ),
                    data: (products) => products.isEmpty
                        ? const Text('표시할 상품이 없습니다.')
                        : ProductRecommendationSection(
                            showHeader: false,
                            products: products
                                .take(10)
                                .map(
                                  (p) => HomeProductData(
                                    productId: p.id.toString(),
                                    detailPath: p.detailPath,
                                    chatProductId: p.chatProductId,
                                    name: p.name,
                                    storeName:
                                        p.platform ?? p.dataPlatform ?? '',
                                    priceLabel: _formatPrice(p.price),
                                    ratingLabel:
                                        p.avgRating?.toStringAsFixed(1) ?? '',
                                    reviewCountLabel:
                                        p.reviewCount?.toString() ?? '',
                                    rtiLabel: p.avgRti == null
                                        ? '분석 전'
                                        : 'RTI ${p.avgRti!.round()}',
                                    imageUrl: p.imageUrl,
                                    label: p.subCategory ?? '',
                                  ),
                                )
                                .toList(),
                            onProductTap: _handleProductPressed,
                          ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.goNamed(
                        RouteNames.search,
                        queryParameters: {'sort': 'accuracy'},
                      ),
                      child: const Text('전체 상품 보기'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (useWideCommerceGrid) ...[
                    AppFadeIn(
                      key: _recommendationKey,
                      delay: 180,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).homeRecommendedTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: AppSpacing.xxs,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: AppColors.textSecondary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context).homeViewAll,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.chevron_right, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProductRecommendationSection(
                      showHeader: false,
                      products: dashboardProducts,
                      onProductTap: _handleProductPressed,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: AppFadeIn(
                            delay: 240,
                            child: ReviewTrustInfoCard(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppFadeIn(
                            key: _benefitKey,
                            delay: 300,
                            child: BenefitCTA(
                              items: benefitItems,
                              onBenefitPressed: () =>
                                  context.go(RoutePaths.login),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppFadeIn(
                      key: _popularCategoryKey,
                      delay: 360,
                      child: PopularCategorySection(
                        items: popularCategories,
                        onCategoryPressed: _handleCategoryPressed,
                      ),
                    ),
                  ] else ...[
                    AppFadeIn(
                      key: _recommendationKey,
                      delay: 180,
                      child: ProductRecommendationSection(
                        products: dashboardProducts,
                        onProductTap: _handleProductPressed,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const AppFadeIn(delay: 240, child: ReviewTrustInfoCard()),
                    const SizedBox(height: AppSpacing.xl),
                    AppFadeIn(
                      key: _benefitKey,
                      delay: 300,
                      child: BenefitCTA(
                        items: benefitItems,
                        onBenefitPressed: () => context.go(RoutePaths.login),
                      ),
                    ),
                  ],
                  if (!useWideCommerceGrid) ...[
                    const SizedBox(height: AppSpacing.xl),
                    AppFadeIn(
                      key: _popularCategoryKey,
                      delay: 360,
                      child: PopularCategorySection(
                        items: popularCategories,
                        onCategoryPressed: _handleCategoryPressed,
                      ),
                    ),
                  ],
                  SizedBox(height: context.isMobile ? 96 : AppSpacing.xxxl),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: HomeFooter()),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? _HomeBottomTabs(
              onHomePressed: () => _handleNavItemPressed('홈'),
              onCategoryPressed: () => _scrollTo(_categoryKey),
              onSearchPressed: () => AppShell.focusSearch(context),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onMyPressed: () =>
                  context.go(isLoggedIn ? RoutePaths.myPage : RoutePaths.login),
            )
          : null,
    );

    return page;
  }

  EdgeInsets _homeContentPadding(BuildContext context) {
    if (context.isMobile) {
      return const EdgeInsets.fromLTRB(16, 20, 16, 0);
    }

    if (context.isTablet) {
      return const EdgeInsets.fromLTRB(24, 28, 24, 0);
    }

    return const EdgeInsets.fromLTRB(32, 28, 32, 0);
  }

  void _handleNavItemPressed(String item) {
    if (item == '홈') {
      _scrollController.jumpTo(0);
      return;
    }
    openHomeNavItem(context, item);
  }

  void _handleCategoryPressed(String label) {
    if (label == AppLocalizations.of(context).homeViewAll) {
      _scrollTo(_popularCategoryKey);
      return;
    }

    _handleNavItemPressed(label);
  }

  void _handleBannerPressed(HomeBannerData banner) {
    _scrollTo(_recommendationKey);
  }

  void _handleProductPressed(HomeProductData product) {
    context.go(
      product.detailPath ?? '/product/${product.productId}',
      extra: ProductRouteContext(chatProductId: product.chatProductId),
    );
  }

  void _handleKeywordSearch(String keyword) {
    context.goNamed(RouteNames.search, queryParameters: {'q': keyword});
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      targetContext,
      duration: AppMotion.slow,
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  List<HomeProductData> _recommendedProductsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(dashboard: final dashboard) =>
        dashboard.recommendedProducts
            .map(_toHomeProductData)
            .toList(growable: false),
      _ => const [],
    };
  }

  List<String> _trendingKeywordsFrom(HomeDashboardState state) {
    return switch (state) {
      HomeDashboardSuccess(dashboard: final dashboard) =>
        dashboard.trendingKeywords
            .map(_toKeywordLabel)
            .where((keyword) => keyword.isNotEmpty)
            .toList(growable: false),
      _ => const [],
    };
  }

  HomeProductData _toHomeProductData(DashboardProduct product) {
    return HomeProductData(
      productId: product.id,
      detailPath: product.detailPath,
      chatProductId: product.chatProductId,
      name: product.name,
      storeName: product.storeName,
      priceLabel: _formatPrice(product.price),
      ratingLabel: product.rating?.toStringAsFixed(1) ?? '-',
      reviewCountLabel: product.reviewCount?.toString() ?? '-',
      rtiLabel: product.rtiScore == null ? '' : 'RTI ${product.rtiScore}',
      imageUrl: product.imageUrl,
      label: product.label ?? '',
    );
  }

  String _toKeywordLabel(TrendingKeyword keyword) => keyword.keyword;

  String _formatPrice(int price) {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    return '$buffer원';
  }
}

class _HomeBottomTabs extends StatelessWidget {
  const _HomeBottomTabs({
    required this.onHomePressed,
    required this.onCategoryPressed,
    required this.onSearchPressed,
    required this.onWishPressed,
    required this.onMyPressed,
  });

  final VoidCallback onHomePressed;
  final VoidCallback onCategoryPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onWishPressed;
  final VoidCallback onMyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.home_filled, l10n.navHome),
      (Icons.grid_view_outlined, l10n.navCategory),
      (Icons.search, l10n.navSearch),
      (Icons.favorite_border, l10n.navWishShort),
      (Icons.person_outline, l10n.navMyShort),
    ];
    final callbacks = [
      onHomePressed,
      onCategoryPressed,
      onSearchPressed,
      onWishPressed,
      onMyPressed,
    ];

    return Container(
      height: 72 + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: callbacks[i],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[i].$1,
                      color: i == 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      size: 27,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      items[i].$2,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: i == 0
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: i == 0 ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

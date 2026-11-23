import 'package:intl/intl.dart';
import 'package:re_view_front/shared/widgets/scroll_to_top_button.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/app/router/app_shell.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
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
import 'package:re_view_front/features/home/presentation/widgets/home/home_category_sheet.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/banners/presentation/providers/banner_providers.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final bannerFeed = ref.watch(publicBannersProvider);
    final bannerContract = ref.watch(bannerApiContractProvider);
    final registeredBanners = bannerFeed.hasError
        ? const <HomeBannerData>[]
        : (bannerFeed.value ?? [])
              .map(
                (banner) => HomeBannerData(
                  title: banner.title,
                  emphasis: '',
                  description: '',
                  ctaLabel: '',
                  badgeLabel: '',
                  imageUrl: banner.imageUrl,
                  mobileImageUrl: banner.mobileImageUrl,
                  targetUrl: banner.targetUrl,
                  color: AppColors.surface,
                  accentColor: AppColors.textPrimary,
                  icon: Icons.image_outlined,
                ),
              )
              .toList();
    final dashboardState = ref.watch(homeDashboardViewModelProvider);
    final dashboardProducts = _recommendedProductsFrom(dashboardState);
    final dashboardKeywords = _trendingKeywordsFrom(dashboardState);
    final dashboardExtras = <Widget>[
      if (dashboardState is HomeDashboardLoading) ...[
        const ProductCardGridSkeleton(itemCount: 5),
        const SizedBox(height: AppSpacing.xl),
      ] else if (dashboardState is HomeDashboardFailure) ...[
        SizedBox(
          height: 280,
          child: AppErrorView(
            failure: dashboardState.failure,
            onRetry: () =>
                ref.read(homeDashboardViewModelProvider.notifier).refresh(),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ] else if (dashboardKeywords.isNotEmpty) ...[
        AppFadeIn(
          delay: 120,
          child: TrendingKeywordChips(
            keywords: dashboardKeywords,
            onKeywordTap: _handleKeywordSearch,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    ];
    final browseTitle = <Widget>[
      Text(
        AppLocalizations.of(context).wishlistBrowse,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: AppSpacing.md),
    ];
    final scrollView = CustomScrollView(
      physics: kIsWeb ? null : const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      // 바로 아래 섹션은 미리 만들어 스크롤이 끊기지 않게 하고, 그보다 먼 섹션만 미룬다.
      scrollCacheExtent: const ScrollCacheExtent.pixels(800),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: context.isMobile ? 20 : 28),
            child: AppFadeIn(
              key: _heroKey,
              delay: 0,
              child: HeroBannerCarousel(
                items: registeredBanners.isEmpty ? banners : registeredBanners,
                onBannerPressed: _handleBannerPressed,
              ),
            ),
          ),
        ),
        if (bannerContract != null && bannerFeed.hasError)
          SliverToBoxAdapter(
            child: Padding(
              padding: context.pagePadding,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).homeBannerFallbackNotice),
                  TextButton(
                    onPressed: () => ref.invalidate(publicBannersProvider),
                    child: Text(AppLocalizations.of(context).actionRetry),
                  ),
                ],
              ),
            ),
          ),
        // 본문 섹션은 화면에 가까워질 때 만들어지도록 지연 생성 목록으로 둔다.
        SliverList.list(
          children: [
            SizedBox(height: _homeContentPadding(context).top),
            for (final section in <Widget>[
              AppFadeIn(
                key: _categoryKey,
                delay: 60,
                child: QuickCategoryRow(
                  items: quickCategories,
                  onCategoryPressed: _handleCategoryPressed,
                ),
              ),
              SizedBox(
                height: context.isMobile ? AppSpacing.md : AppSpacing.xl,
              ),
              if (!context.isMobile) ...dashboardExtras,
              ...catalog.when(
                loading: () => [
                  ...browseTitle,
                  const ProductCardGridSkeleton(itemCount: 5),
                ],
                error: (error, _) => [
                  ...browseTitle,
                  SizedBox(
                    height: 280,
                    child: AppErrorView(
                      failure: error is Failure
                          ? error
                          : Failure(
                              message: AppLocalizations.of(
                                context,
                              ).homeProductsLoadFailed,
                              cause: error,
                            ),
                      onRetry: () => ref.invalidate(homeCatalogProvider),
                    ),
                  ),
                ],
                // 리뷰가 없는 상품은 둘러볼 근거가 없으므로 빼고, 남는 게 없으면 섹션을 숨긴다.
                data: (products) {
                  final reviewed = products
                      .where((p) => p.hasReviews)
                      .take(10)
                      .toList(growable: false);
                  if (reviewed.isEmpty) return const <Widget>[];
                  return [
                    ...browseTitle,
                    ProductRecommendationSection(
                      showHeader: false,
                      products: reviewed
                          .map(
                            (p) => HomeProductData(
                              productId: p.id.toString(),
                              detailPath: p.detailPath,
                              chatProductId: p.chatProductId,
                              routeContext: p.routeContext,
                              name: p.name,
                              storeName: p.platform ?? p.dataPlatform ?? '',
                              priceLabel: _formatPrice(p.price),
                              ratingLabel: p.avgRating == null
                                  ? ''
                                  : NumberFormat(
                                      '0.0',
                                      AppLocalizations.of(context).localeName,
                                    ).format(p.avgRating),
                              reviewCountLabel: (p.reviewCount ?? 0) > 0
                                  ? NumberFormat.decimalPattern(
                                      AppLocalizations.of(context).localeName,
                                    ).format(p.reviewCount)
                                  : '',
                              // 분석한 리뷰가 없으면 점수 배지를 붙이지 않는다.
                              rtiLabel:
                                  (p.summary?.catalogAnalysis?.reviewCount ??
                                          0) >
                                      0
                                  ? p.analysisDisplay.badgeText(context)
                                  : '',
                              attentionReviewLabel: p.analysisDisplay
                                  .attentionReviewsLabel(context),
                              analysisDescription: p.analysisDisplay
                                  .localizedReasons(context)
                                  .firstOrNull,
                              imageUrl: p.imageUrl,
                              label: p.subCategory ?? '',
                            ),
                          )
                          .toList(),
                      onProductTap: _handleProductPressed,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.goNamed(
                          RouteNames.search,
                          queryParameters: {'sort': 'accuracy'},
                        ),
                        child: Text(
                          AppLocalizations.of(context).homeViewAllProducts,
                        ),
                      ),
                    ),
                  ];
                },
              ),
              if (context.isMobile) ...dashboardExtras,
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
                        onPressed: () => context.push(RoutePaths.search),
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
                          onBenefitPressed: () => context.go(RoutePaths.login),
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
            ])
              _homeSection(context, section),
          ],
        ),
        const SliverToBoxAdapter(child: HomeFooter()),
      ],
    );
    final page = Scaffold(
      floatingActionButton: ScrollToTopButton(controller: _scrollController),
      backgroundColor: AppColors.background,
      body: kIsWeb
          ? scrollView
          : RefreshIndicator(
              onRefresh: () async {
                try {
                  await Future.wait([
                    ref.read(homeDashboardViewModelProvider.notifier).refresh(),
                    ref.refresh(homeCatalogProvider.future),
                    ref.refresh(publicBannersProvider.future),
                  ]);
                } on Object {
                  // 조회 실패는 각 provider의 기존 오류 화면에서 표시한다.
                }
              },
              child: scrollView,
            ),
      bottomNavigationBar: context.isMobile
          ? _HomeBottomTabs(
              onHomePressed: () => _handleNavItemPressed('홈'),
              onCategoryPressed: _openCategories,
              onSearchPressed: () => AppShell.focusSearch(context),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onMyPressed: () =>
                  context.go(isLoggedIn ? RoutePaths.myPage : RoutePaths.login),
            )
          : null,
    );

    return page;
  }

  /// 본문 한 섹션. 예전 Column(stretch)처럼 최대 폭을 꽉 채운다.
  Widget _homeSection(BuildContext context, Widget child) {
    final padding = _homeContentPadding(context);
    return AppContentView(
      maxWidth: 1440,
      padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 0),
      child: SizedBox(width: double.infinity, child: child),
    );
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

  Future<void> _openCategories() async {
    final selection = await showHomeCategorySheet(context);
    if (!mounted || selection == null) return;
    final category = selection.category;
    context.goNamed(
      RouteNames.search,
      queryParameters: category == null
          ? {'sort': SearchSortOption.accuracy.name}
          : {'categoryId': category.id, 'category': category.label},
    );
  }

  void _handleCategoryPressed(String label) {
    if (label == AppLocalizations.of(context).homeViewAll ||
        label == quickCategories.last.label) {
      _openCategories();
      return;
    }

    _handleNavItemPressed(label);
  }

  Future<void> _handleBannerPressed(HomeBannerData banner) async {
    final target = banner.targetUrl;
    if (target != null) {
      if (target.startsWith('/')) {
        context.go(target);
      } else {
        try {
          final opened = await launchUrl(
            Uri.parse(target),
            mode: LaunchMode.externalApplication,
          );
          if (!opened && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).homeBannerLinkFailed,
                ),
              ),
            );
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).homeBannerLinkFailed,
                ),
              ),
            );
          }
        }
      }
      return;
    }
    _scrollTo(_recommendationKey);
  }

  void _handleProductPressed(HomeProductData product) {
    context.go(
      product.detailPath ?? '/product/${product.productId}',
      extra:
          product.routeContext ??
          ProductRouteContext(chatProductId: product.chatProductId),
    );
  }

  void _handleKeywordSearch(String keyword) {
    context.goNamed(RouteNames.search, queryParameters: {'q': keyword});
  }

  Future<void> _scrollTo(GlobalKey key) async {
    // 섹션은 지연 생성되므로 아직 없으면 한 화면씩 내려가며 만들어질 때까지 찾는다.
    for (
      var attempt = 0;
      key.currentContext == null && attempt < 8;
      attempt++
    ) {
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent) break;
      _scrollController.jumpTo(
        (position.pixels + position.viewportDimension).clamp(
          0.0,
          position.maxScrollExtent,
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }
    final targetContext = key.currentContext;
    if (targetContext == null || !targetContext.mounted) {
      return;
    }

    await Scrollable.ensureVisible(
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
            .where((product) => product.hasReviews)
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
      routeContext: product.routeContext,
      name: product.name,
      storeName: product.storeName,
      priceLabel: _formatPrice(product.price),
      ratingLabel: product.rating == null
          ? ''
          : NumberFormat(
              '0.0',
              AppLocalizations.of(context).localeName,
            ).format(product.rating),
      reviewCountLabel: (product.reviewCount ?? 0) > 0
          ? NumberFormat.decimalPattern(
              AppLocalizations.of(context).localeName,
            ).format(product.reviewCount)
          : '',
      rtiLabel:
          (product.summary?.catalogAnalysis?.reviewCount ??
                      product.reviewCount ??
                      0) >
                  0 &&
              product.analysisDisplay.score != null
          ? product.analysisDisplay.badgeText(context, legacyMissingLabel: '')
          : '',
      attentionReviewLabel: product.analysisDisplay.attentionReviewsLabel(
        context,
      ),
      analysisDescription: product.analysisDisplay
          .localizedReasons(context)
          .firstOrNull,
      imageUrl: product.imageUrl,
      label: product.label ?? '',
    );
  }

  String _toKeywordLabel(TrendingKeyword keyword) => keyword.keyword;

  String _formatPrice(int? price) {
    if (price == null) return AppLocalizations.of(context).homePriceUnavailable;
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    return AppLocalizations.of(context).extProductPrice(buffer.toString());
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

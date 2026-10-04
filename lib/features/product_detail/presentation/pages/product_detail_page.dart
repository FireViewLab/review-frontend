import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_ask_button.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/price_comparison_table.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_image_gallery.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_info_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_insight_panel.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_list_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/similar_products_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/trust_signal_card.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';

enum _ProductDetailTab { review, priceComparison, info }

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  _ProductDetailTab _selectedTab = _ProductDetailTab.review;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailViewModelProvider(widget.productId));
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              showCategoryNav: false,
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onMyPagePressed: () => context.go(RoutePaths.myPage),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: () =>
                  ref.read(authTokenStoreProvider.notifier).clear(),
              onNavItemPressed: (item) => openHomeNavItem(context, item),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              onLogoPressed: () => context.goNamed(RouteNames.home),
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1680,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.md,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const _LoadingView(),
                ProductDetailFailure(:final failure) => _ErrorView(
                  message: failure.message,
                  onRetry: () => ref
                      .read(
                        productDetailViewModelProvider(
                          widget.productId,
                        ).notifier,
                      )
                      .refresh(),
                ),
                ProductDetailSuccess(
                  :final detail,
                  :final reviews,
                  :final reviewInsight,
                  :final similarProducts,
                  :final isAnalyzing,
                  :final safeCount,
                  :final warnCount,
                  :final dangerCount,
                ) =>
                  _DetailContent(
                    detail: detail,
                    reviews: reviews,
                    reviewInsight: reviewInsight,
                    similarProducts: similarProducts,
                    selectedTab: _selectedTab,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    onTabChanged: (tab) => setState(() => _selectedTab = tab),
                    onFeedback: (reviewId, feedbackType) => ref
                        .read(
                          productDetailViewModelProvider(
                            widget.productId,
                          ).notifier,
                        )
                        .submitFeedback(reviewId, feedbackType),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.detail,
    required this.reviews,
    required this.reviewInsight,
    required this.similarProducts,
    required this.selectedTab,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.onTabChanged,
    this.onFeedback,
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
  final _ProductDetailTab selectedTab;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final ValueChanged<_ProductDetailTab> onTabChanged;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Breadcrumb(breadcrumbs: detail.breadcrumbs),
        const SizedBox(height: AppSpacing.md),
        isMobile
            ? _MobileHeroSection(detail: detail)
            : _DesktopHeroSection(detail: detail),
        if (!isMobile && detail.specChips.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ProductSpecChipsStrip(chips: detail.specChips),
        ],
        const SizedBox(height: AppSpacing.xl),
        isMobile
            ? _MobileAnalysisSection(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => context.goNamed(
                  RouteNames.analysisReport,
                  pathParameters: {'id': detail.id.toString()},
                ),
              )
            : _DesktopAnalysisSection(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => context.goNamed(
                  RouteNames.analysisReport,
                  pathParameters: {'id': detail.id.toString()},
                ),
              ),
        const SizedBox(height: AppSpacing.xl),
        _ProductTabBar(
          detail: detail,
          selectedTab: selectedTab,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (selectedTab == _ProductDetailTab.review)
          isMobile
              ? _MobileReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                  productId: detail.id,
                  productName: detail.name,
                )
              : _DesktopReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                  productId: detail.id,
                  productName: detail.name,
                )
        else if (selectedTab == _ProductDetailTab.priceComparison)
          PriceComparisonTable(
            comparisons: detail.priceComparisons,
            totalSellerCount: detail.totalSellerCount,
          )
        else
          _ProductInfoTable(detail: detail),
        if (similarProducts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          SimilarProductsSection(products: similarProducts),
        ],
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.breadcrumbs});

  final List<String> breadcrumbs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < breadcrumbs.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Icon(
                Icons.chevron_right,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ),
          GestureDetector(
            onTap: i == breadcrumbs.length - 1
                ? null
                : () {
                    final category = resolveProductCategory(breadcrumbs[i]);
                    context.goNamed(
                      RouteNames.search,
                      queryParameters: {
                        if (category != null) 'categoryId': category.id,
                        'category': breadcrumbs[i],
                      },
                    );
                  },
            child: Text(
              breadcrumbs[i],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: i == breadcrumbs.length - 1
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: i == breadcrumbs.length - 1
                    ? FontWeight.w700
                    : FontWeight.w500,
                decoration: i < breadcrumbs.length - 1
                    ? TextDecoration.underline
                    : null,
                decorationColor: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DesktopHeroSection extends StatelessWidget {
  const _DesktopHeroSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ProductImageGallery(
              productId: detail.id,
              imageUrls: detail.imageUrls,
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfoSection(detail: detail),
                const SizedBox(height: AppSpacing.lg),
                PriceComparisonTable(
                  comparisons: detail.priceComparisons,
                  totalSellerCount: detail.totalSellerCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHeroSection extends StatelessWidget {
  const _MobileHeroSection({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageGallery(productId: detail.id, imageUrls: detail.imageUrls),
        const SizedBox(height: AppSpacing.md),
        ProductInfoSection(detail: detail),
        const SizedBox(height: AppSpacing.md),
        ProductSpecChips(chips: detail.specChips),
        const SizedBox(height: AppSpacing.md),
        PriceComparisonTable(
          comparisons: detail.priceComparisons,
          totalSellerCount: detail.totalSellerCount,
        ),
      ],
    );
  }
}

class _DesktopAnalysisSection extends StatelessWidget {
  const _DesktopAnalysisSection({
    required this.detail,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAnalyzing) _AnalyzingBanner(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RtiSummaryCard(
                rtiSummary: detail.rtiSummary,
                onDetailPressed: onDetailPressed,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 280,
              child: TrustSignalCard(
                signals: detail.trustSignals,
                onDetailPressed: onDetailPressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const ChatAskButton(),
      ],
    );
  }
}

class _MobileAnalysisSection extends StatelessWidget {
  const _MobileAnalysisSection({
    required this.detail,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAnalyzing) ...[
          _AnalyzingBanner(),
          const SizedBox(height: AppSpacing.sm),
        ],
        RtiSummaryCard(
          rtiSummary: detail.rtiSummary,
          onDetailPressed: onDetailPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        TrustSignalCard(
          signals: detail.trustSignals,
          onDetailPressed: onDetailPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        const SizedBox(width: double.infinity, child: ChatAskButton()),
      ],
    );
  }
}

class _AnalyzingBanner extends StatefulWidget {
  @override
  State<_AnalyzingBanner> createState() => _AnalyzingBannerState();
}

class _AnalyzingBannerState extends State<_AnalyzingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.09 + _pulse.value * 0.04),
                AppColors.primary.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: AppRadius.medium,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.1 + _pulse.value * 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 리뷰 분석 진행 중',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Re:view AI가 리뷰를 실시간 분석하고 있습니다. 완료 후 신뢰도 점수가 자동으로 업데이트됩니다.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductTabBar extends StatelessWidget {
  const _ProductTabBar({
    required this.detail,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final ProductDetail detail;
  final _ProductDetailTab selectedTab;
  final ValueChanged<_ProductDetailTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_ProductDetailTab.review, '리뷰 ${_formatTabCount(detail.reviewCount)}'),
      (_ProductDetailTab.priceComparison, '가격비교 ${detail.totalSellerCount}'),
      (_ProductDetailTab.info, '상품 정보'),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: tabs.map((entry) {
          final (tab, label) = entry;
          final isSelected = tab == selectedTab;
          return _TabItem(
            label: label,
            isSelected: isSelected,
            onTap: () => onTabChanged(tab),
          );
        }).toList(),
      ),
    );
  }

  String _formatTabCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    }
    return count.toString();
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DesktopReviewSection extends StatelessWidget {
  const _DesktopReviewSection({
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
    this.productId,
    this.productName = '',
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 65,
          child: ReviewListSection(
            reviews: reviews,
            safeCount: safeCount,
            warnCount: warnCount,
            dangerCount: dangerCount,
            onFeedback: onFeedback,
            productId: productId,
            productName: productName,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 280,
          child: ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        ),
      ],
    );
  }
}

class _MobileReviewSection extends StatelessWidget {
  const _MobileReviewSection({
    required this.reviews,
    required this.insight,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    this.onFeedback,
    this.productId,
    this.productName = '',
  });

  final List<ProductReview> reviews;
  final ReviewInsight insight;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReviewInsightPanel(insight: insight, onMorePressed: () {}),
        const SizedBox(height: AppSpacing.md),
        ReviewListSection(
          reviews: reviews,
          safeCount: safeCount,
          warnCount: warnCount,
          dangerCount: dangerCount,
          onFeedback: onFeedback,
          productId: productId,
          productName: productName,
        ),
      ],
    );
  }
}

/// 서버가 내려주는 상품 기본 정보. 값이 없는 항목은 표시하지 않는다.
class _ProductInfoTable extends StatelessWidget {
  const _ProductInfoTable({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final category = detail.breadcrumbs.isNotEmpty
        ? detail.breadcrumbs.join(' > ')
        : detail.categoryDisplayName;
    final rows = <(String, String)>[
      ('상품명', detail.name),
      if (detail.brand.isNotEmpty) ('브랜드', detail.brand),
      if (category.isNotEmpty) ('카테고리', category),
      if (detail.price > 0) ('최저가', '${_formatWon(detail.price)}원'),
      if (detail.totalSellerCount > 0)
        ('판매처', '${detail.totalSellerCount}곳'),
      if (detail.reviewCount > 0)
        (
          '평균 별점',
          '${detail.avgRating.toStringAsFixed(1)} '
              '(리뷰 ${_formatWon(detail.reviewCount)}개)',
        ),
      if (detail.avgRti > 0)
        (
          'RTI',
          detail.rtiGrade.isEmpty
              ? detail.avgRti.toStringAsFixed(1)
              : '${detail.avgRti.toStringAsFixed(1)} · '
                    '${_gradeLabel(detail.rtiGrade)}',
        ),
      if (detail.deliveryInfo?.isNotEmpty ?? false)
        ('배송', detail.deliveryInfo!),
    ];
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final (index, (label, value)) in rows.indexed) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _gradeLabel(String grade) => switch (grade) {
    'SAFE' => '안전',
    'SUSPICIOUS' => '의심',
    'DANGER' => '위험',
    _ => grade,
  };

  static String _formatWon(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

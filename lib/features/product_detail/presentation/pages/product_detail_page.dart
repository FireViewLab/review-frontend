import 'package:re_view_front/shared/widgets/product_detail_hero.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_content.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/price_comparison_table.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_image_gallery.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_info_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/similar_products_section.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_tab_bar.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_breadcrumb.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_analysis_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_review_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_info_table.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/product_detail_page/product_detail_status_views.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  ProductDetailTab _selectedTab = ProductDetailTab.review;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailViewModelProvider(widget.productId));
    if (state is ProductDetailSuccess && state.detail.externalRef != null) {
      final path = state.detail.detailPath;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(
            path,
            extra: ProductRouteContext(
              chatProductId: state.detail.chatProductId,
              summary: state.detail.summary,
              viewAlreadyRecorded: state.viewRecorded,
            ),
          );
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1200,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.md,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const ProductDetailLoadingView(),
                ProductDetailFailure(:final failure) => ProductDetailErrorView(
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
                  :final trend,
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
                    trend: trend,
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
    required this.trend,
    this.onFeedback,
  });

  final List<AnalysisTrendPoint> trend;
  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
  final ProductDetailTab selectedTab;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final ValueChanged<ProductDetailTab> onTabChanged;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailBreadcrumb(breadcrumbs: detail.breadcrumbs),
        const SizedBox(height: AppSpacing.md),
        ProductDetailHero(
          gallery: ProductImageGallery(
            productId: detail.id,
            imageUrls: detail.imageUrls,
          ),
          information: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductInfoSection(detail: detail),
              if (detail.specChips.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                ProductSpecChips(chips: detail.specChips),
              ],
              const SizedBox(height: AppSpacing.lg),
              ProductPurchaseArea(
                child: PriceComparisonTable(
                  comparisons: detail.priceComparisons,
                  totalSellerCount: detail.totalSellerCount,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        isMobile
            ? ProductDetailMobileAnalysisSection(
                detail: detail,
                loadedAnalysisCount: reviews
                    .where(
                      (r) =>
                          r.rtiScore != null ||
                          r.rtiLabel != null ||
                          r.reasons.isNotEmpty,
                    )
                    .length,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => showProductReport(
                  context,
                  AnalysisReportContent(
                    productId: detail.id,
                    detail: detail,
                    reviews: reviews,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    trend: trend,
                    onBackToProduct: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ),
              )
            : ProductDetailDesktopAnalysisSection(
                detail: detail,
                loadedAnalysisCount: reviews
                    .where(
                      (r) =>
                          r.rtiScore != null ||
                          r.rtiLabel != null ||
                          r.reasons.isNotEmpty,
                    )
                    .length,
                isAnalyzing: isAnalyzing,
                onDetailPressed: () => showProductReport(
                  context,
                  AnalysisReportContent(
                    productId: detail.id,
                    detail: detail,
                    reviews: reviews,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    trend: trend,
                    onBackToProduct: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ),
              ),
        const SizedBox(height: AppSpacing.xl),
        ProductDetailTabBar(
          detail: detail,
          selectedTab: selectedTab,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (selectedTab == ProductDetailTab.review)
          isMobile
              ? ProductDetailMobileReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                  productId: detail.id,
                  productName: detail.name,
                )
              : ProductDetailDesktopReviewSection(
                  reviews: reviews,
                  insight: reviewInsight,
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                  onFeedback: onFeedback,
                  productId: detail.id,
                  productName: detail.name,
                )
        else if (selectedTab == ProductDetailTab.priceComparison)
          PriceComparisonTable(
            comparisons: detail.priceComparisons,
            totalSellerCount: detail.totalSellerCount,
          )
        else
          ProductDetailInfoTable(detail: detail),
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

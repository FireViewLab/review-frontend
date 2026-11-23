import 'package:re_view_front/shared/widgets/product_review_metrics.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class SimilarProductsSection extends StatefulWidget {
  const SimilarProductsSection({super.key, required this.products});

  final List<SimilarProduct> products;

  @override
  State<SimilarProductsSection> createState() => _SimilarProductsSectionState();
}

class _SimilarProductsSectionState extends State<SimilarProductsSection> {
  final _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    setState(() {
      _canScrollLeft = pos.pixels > 0;
      _canScrollRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll(double delta) {
    _scrollController.animateTo(
      (_scrollController.offset + delta).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: AppMotion.slow,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).detailAlsoViewed,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 280,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: _canScrollLeft || _canScrollRight
                      ? AppSpacing.xxl
                      : 0,
                ),
                itemCount: widget.products.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) => _SimilarProductCard(
                  product: widget.products[index],
                  onTap: () => context.go(
                    widget.products[index].detailPath,
                    extra: widget.products[index].routeContext,
                  ),
                ),
              ),
            ),
            if (_canScrollLeft)
              Positioned(
                left: 0,
                child: _ScrollArrowButton(
                  icon: Icons.chevron_left,
                  onPressed: () => _scroll(-280),
                ),
              ),
            if (_canScrollRight)
              Positioned(
                right: 0,
                child: _ScrollArrowButton(
                  icon: Icons.chevron_right,
                  onPressed: () => _scroll(280),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ScrollArrowButton extends StatelessWidget {
  const _ScrollArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderStrong),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: 40,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _SimilarProductCard extends StatelessWidget {
  const _SimilarProductCard({required this.product, required this.onTap});

  final SimilarProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080F172A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AppNetworkImage(
                    url: product.imageUrl,
                    thumbnailWidth: 360,
                    borderRadius: AppRadius.small,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // RTI 배지는 이미지 위에 겹치지 않고 정보 영역에 둔다.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                ProductReviewMetrics(
                  rating: product.avgRating,
                  reviewCount: product.reviewCount,
                  analysis: product.analysisDisplay,
                ),
                const SizedBox(height: 2),
                Text(
                  formatSearchPrice(product.price),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

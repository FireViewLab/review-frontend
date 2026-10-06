import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class ReviewComparisonBanner extends StatelessWidget {
  const ReviewComparisonBanner({super.key, required this.products});

  final List<SearchResultProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final representative = _representativeProduct(products);
    final reviewCounts = products.map((p) => p.reviewCount).whereType<int>();
    final totalReviews = reviewCounts.isEmpty
        ? null
        : reviewCounts.reduce((a, b) => a + b);
    final analyzed = products.map((p) => p.avgRti).whereType<double>().toList();
    final avgRti = analyzed.isEmpty
        ? null
        : analyzed.reduce((a, b) => a + b) / analyzed.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SizedBox(
          height: context.isMobile ? 320 : 268,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.surface,
                        AppColors.surface,
                        AppColors.primaryLight.withValues(alpha: 0.42),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: context.isMobile ? 220 : 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      url: representative.imageUrl,
                      fit: BoxFit.contain,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.surface,
                            AppColors.surface.withValues(alpha: 0.82),
                            AppColors.surface.withValues(alpha: 0.24),
                            AppColors.surface.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                right: context.isMobile ? 0 : 360,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '멀티 스토어 통합 검색',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.sm,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          BannerMetric(
                            icon: Icons.shopping_bag_outlined,
                            label: '비교 상품',
                            value: '${formatSearchCount(products.length)}개',
                          ),
                          BannerMetric(
                            icon: Icons.chat_bubble_outline,
                            label: '수집 리뷰',
                            value: totalReviews == null
                                ? '미집계'
                                : '${formatSearchCount(totalReviews)}건',
                          ),
                          BannerMetric(
                            icon: Icons.favorite_border,
                            label: '평균 RTI',
                            value: avgRti == null
                                ? '분석 전'
                                : '${avgRti.round()}',
                            subtitle: avgRti == null ? null : _rtiLabel(avgRti),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '실사용 리뷰 기반 비교',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '가격과 리뷰, RTI 신뢰도를 한 번에 비교해 신뢰도 높은 상품을 빠르게 골라보세요.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: const [
                          BannerFeature(label: '최저가 비교', icon: Icons.swap_vert),
                          BannerFeature(
                            label: '리뷰 신뢰도',
                            icon: Icons.verified_outlined,
                          ),
                          BannerFeature(
                            label: '빠른 배송',
                            icon: Icons.local_shipping_outlined,
                          ),
                          BannerFeature(
                            label: '공식몰 포함',
                            icon: Icons.workspace_premium_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _rtiLabel(double rti) {
    if (rti >= 90) return '매우 신뢰 높음';
    if (rti >= 75) return '신뢰 높음';
    if (rti >= 60) return '보통';
    return '낮음';
  }

  SearchResultProduct _representativeProduct(
    List<SearchResultProduct> products,
  ) {
    return products.reduce((best, product) {
      return _representativeScore(product) > _representativeScore(best)
          ? product
          : best;
    });
  }

  double _representativeScore(SearchResultProduct product) {
    return (product.avgRti ?? 0) * 2 +
        (product.avgRating ?? 0) * 20 +
        (product.reviewCount ?? 0) / 40;
  }
}

class BannerMetric extends StatelessWidget {
  const BannerMetric({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FC).withValues(alpha: 0.88),
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: 36,
            child: Icon(icon, size: 24, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class BannerFeature extends StatelessWidget {
  const BannerFeature({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

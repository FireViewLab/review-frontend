import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
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
    final analyzed = products
        .where((p) => !p.analysisDisplay.isV2)
        .map((p) => p.analysisDisplay.score)
        .whereType<double>()
        .toList();
    final avgRti = analyzed.isEmpty
        ? null
        : analyzed.reduce((a, b) => a + b) / analyzed.length;

    if (products.any((p) => p.analysisDisplay.isV2)) {
      final l = AppLocalizations.of(context);
      final policyScores = products
          .where((p) => p.analysisDisplay.isV2)
          .map((p) => p.analysisDisplay.score)
          .whereType<double>()
          .toList();
      final policyAverage = policyScores.isEmpty
          ? null
          : policyScores.reduce((a, b) => a + b) / policyScores.length;
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.analysisScore,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                BannerMetric(
                  icon: Icons.fact_check_outlined,
                  label: l.analysisPolicyIndex,
                  value: policyAverage == null
                      ? l.analysisNotCalculable
                      : '${policyAverage.round()}',
                ),
                if (avgRti != null)
                  BannerMetric(
                    icon: Icons.favorite_border,
                    label: 'RTI',
                    value: '${avgRti.round()}',
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.analysisSeparateContracts),
          ],
        ),
      );
    }

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
                        AppLocalizations.of(context).searchMultiStoreTitle,
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
                            label: AppLocalizations.of(
                              context,
                            ).searchComparedProducts,
                            value: AppLocalizations.of(context)
                                .searchComparedProductCount(
                                  formatSearchCount(products.length),
                                ),
                          ),
                          BannerMetric(
                            icon: Icons.chat_bubble_outline,
                            label: AppLocalizations.of(
                              context,
                            ).searchCollectedReviews,
                            value: totalReviews == null
                                ? AppLocalizations.of(context).searchNotCounted
                                : AppLocalizations.of(
                                    context,
                                  ).searchCollectedReviewCount(
                                    formatSearchCount(totalReviews),
                                  ),
                          ),
                          BannerMetric(
                            icon: Icons.favorite_border,
                            label: AppLocalizations.of(
                              context,
                            ).detailAverageRti,
                            value: avgRti == null
                                ? AppLocalizations.of(
                                    context,
                                  ).externalUnanalyzed
                                : '${avgRti.round()}',
                            subtitle: avgRti == null
                                ? null
                                : _rtiLabel(context, avgRti),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).searchReviewBasedComparison,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).searchComparisonDescription,
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
                        children: [
                          BannerFeature(
                            label: AppLocalizations.of(
                              context,
                            ).searchLowestPriceComparison,
                            icon: Icons.swap_vert,
                          ),
                          BannerFeature(
                            label: AppLocalizations.of(
                              context,
                            ).searchReviewTrust,
                            icon: Icons.verified_outlined,
                          ),
                          BannerFeature(
                            label: AppLocalizations.of(
                              context,
                            ).searchFastDelivery,
                            icon: Icons.local_shipping_outlined,
                          ),
                          BannerFeature(
                            label: AppLocalizations.of(
                              context,
                            ).searchOfficialStores,
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

  String _rtiLabel(BuildContext context, double rti) {
    if (rti >= 90) return AppLocalizations.of(context).searchVeryHighTrust;
    if (rti >= 75) return AppLocalizations.of(context).landingGradeHigh;
    if (rti >= 60) return AppLocalizations.of(context).searchModerateTrust;
    return AppLocalizations.of(context).searchLowTrust;
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
    return (product.analysisDisplay.score ?? 0) * 2 +
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

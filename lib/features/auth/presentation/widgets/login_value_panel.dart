import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/shared/widgets/analysis_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class LoginValuePanel extends ConsumerWidget {
  const LoginValuePanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (compact) {
      return Text(
        AppLocalizations.of(context).authLoginContinue,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      );
    }
    final productAsync = ref.watch(featuredProductProvider);
    final product = productAsync.value;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoginBadge(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).authLoginTrackHeadline,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).authLoginManageDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          _TrustSummaryCard(product: product),
          const SizedBox(height: AppSpacing.lg),
          const _LoginBenefitGrid(),
        ],
      ),
    );
  }
}

class _LoginBadge extends StatelessWidget {
  const _LoginBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          AppLocalizations.of(context).authLoginSafeShopping,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TrustSummaryCard extends StatelessWidget {
  const _TrustSummaryCard({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).authLoginRecentProducts,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        AppLocalizations.of(context).authLoginRestoreRecords,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const _TrackingBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _FeaturedProductSection(product: product),
          ],
        ),
      ),
    );
  }
}

class _TrackingBadge extends StatelessWidget {
  const _TrackingBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          AppLocalizations.of(context).authLoginKeepTrackingRti,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FeaturedProductSection extends StatelessWidget {
  const _FeaturedProductSection({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useHorizontal = constraints.maxWidth >= 560;
        final thumbnail = Stack(
          clipBehavior: Clip.none,
          children: [
            _ProductThumbnail(product: product),
            Positioned(
              right: -10,
              top: 16,
              child: product?.analysisDisplay.isV2 == true
                  ? Text(
                      product!.analysisDisplay.badgeText(context),
                      style: TextStyle(
                        color: product!.analysisDisplay.color,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : _RtiScoreBadge(score: product?.rtiScore),
            ),
          ],
        );
        final details = _ProductDetails(product: product);

        if (!useHorizontal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              const SizedBox(height: AppSpacing.lg),
              details,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            thumbnail,
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product?.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const _SkeletonBox(width: 150, height: 150, radius: 22);
    }

    return SizedBox(
      width: 150,
      height: 150,
      child: AppNetworkImage(
        url: imageUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(22),
        placeholderIcon: Icons.inventory_2_outlined,
        iconSize: 42,
      ),
    );
  }
}

class _RtiScoreBadge extends StatelessWidget {
  const _RtiScoreBadge({required this.score});

  final int? score;

  Color get _color {
    if (score == null) return AppColors.primary;
    if (score! >= 80) return AppColors.success;
    if (score! >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: _color, width: 2),
      ),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: score != null
              ? Text(
                  '$score',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _color,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                )
              : const _SkeletonBox(width: 20, height: 12, radius: 6),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 300, height: 20, radius: 8),
          SizedBox(height: AppSpacing.sm),
          _SkeletonBox(width: 230, height: 14, radius: 7),
          SizedBox(height: AppSpacing.lg),
          _SkeletonMetricRow(
            label: AppLocalizations.of(context).authMetricText,
            widthFactor: 0.64,
          ),
          SizedBox(height: AppSpacing.sm),
          _SkeletonMetricRow(
            label: AppLocalizations.of(context).authMetricBehavior,
            widthFactor: 0.78,
          ),
          SizedBox(height: AppSpacing.sm),
          _SkeletonMetricRow(
            label: AppLocalizations.of(context).authMetricPurchaseContext,
            widthFactor: 0.86,
          ),
        ],
      );
    }

    if (product!.analysisDisplay.isV2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product!.name),
          AnalysisResultView(analysis: product!.analysisDisplay, compact: true),
        ],
      );
    }
    final rti = (product!.rtiScore ?? 0).clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product!.name,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product!.storeName.isNotEmpty
              ? product!.storeName
              : AppLocalizations.of(context).authProductUncategorized,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SkeletonMetricRow(
          label: AppLocalizations.of(context).authMetricText,
          widthFactor: (rti * 0.90).clamp(0, 100) / 100,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(
          label: AppLocalizations.of(context).authMetricBehavior,
          widthFactor: (rti * 1.05).clamp(0, 100) / 100,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(
          label: AppLocalizations.of(context).authMetricPurchaseContext,
          widthFactor: rti / 100,
        ),
      ],
    );
  }
}

class _SkeletonMetricRow extends StatelessWidget {
  const _SkeletonMetricRow({required this.label, required this.widthFactor});

  final String label;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              const _SkeletonBox(
                width: double.infinity,
                height: 7,
                radius: 999,
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const _SkeletonBox(width: 28, height: 12, radius: 6),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FA),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE3E8F2)),
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F7FC), Color(0xFFE9EEF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: width == 150
          ? Center(
              child: Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textTertiary.withValues(alpha: 0.7),
                size: 42,
              ),
            )
          : null,
    );
  }
}

class _LoginBenefitGrid extends StatelessWidget {
  const _LoginBenefitGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        number: '1',
        title: AppLocalizations.of(context).authLoginSavedProducts,
        body: AppLocalizations.of(context).authLoginSavedProductsDescription,
      ),
      (
        number: '2',
        title: AppLocalizations.of(context).authLoginPersonalFilters,
        body: AppLocalizations.of(context).authLoginPersonalFiltersDescription,
      ),
      (
        number: '3',
        title: AppLocalizations.of(context).authLoginFeedbackTracking,
        body: AppLocalizations.of(context).authLoginFeedbackTrackingDescription,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in items)
            _BenefitCard(
              number: item.number,
              title: item.title,
              body: item.body,
            ),
        ];

        if (!useRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

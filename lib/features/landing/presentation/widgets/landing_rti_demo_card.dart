import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/analysis_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class LandingRtiDemoCard extends ConsumerWidget {
  const LandingRtiDemoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(featuredProductProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TrustBadgeRow(product: productAsync.value),
          const SizedBox(height: AppSpacing.md),
          productAsync.when(
            data: (product) => _ProductCard(product: product),
            loading: () => const _ProductCardSkeleton(),
            error: (_, _) => const _ProductCardSkeleton(),
          ),
          const SizedBox(height: AppSpacing.md),
          const _RtiSummarySection(),
          const SizedBox(height: AppSpacing.md),
          const _RtiDisclaimer(),
        ],
      ),
    );
  }
}

class _TrustBadgeRow extends StatelessWidget {
  const _TrustBadgeRow({required this.product});

  final DashboardProduct? product;

  String _gradeLabel(BuildContext context) {
    final score = product?.rtiScore;
    if (score == null) return AppLocalizations.of(context).landingGradeHigh;
    if (score >= 80) return AppLocalizations.of(context).landingGradeHigh;
    if (score >= 50) return AppLocalizations.of(context).adminSuspicious;
    return AppLocalizations.of(context).adminDanger;
  }

  Color get _gradeColor {
    final score = product?.rtiScore;
    if (score == null) return AppColors.primary;
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    if (product?.analysisDisplay.isV2 == true) {
      return AnalysisResultView(
        analysis: product!.analysisDisplay,
        compact: true,
      );
    }
    final score = product?.rtiScore;
    return Row(
      children: [
        Icon(Icons.shield, color: _gradeColor, size: 16),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          _gradeLabel(context),
          style: AppTextStyles.labelLarge.copyWith(color: _gradeColor),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: _gradeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            score != null
                ? AppLocalizations.of(
                    context,
                  ).landingRtiReliabilityScore(score.toString())
                : AppLocalizations.of(context).landingRtiAnalyzing,
            style: AppTextStyles.caption.copyWith(
              color: _gradeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    if (product == null) return const _ProductCardSkeleton();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductThumbnail(imageUrl: product!.imageUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product!.name,
                  style: AppTextStyles.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product!.storeName.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    product!.storeName,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppLocalizations.of(
                    context,
                  ).extProductPrice(_formatPrice(product!.price)),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (product!.reviewCount != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).extProductReviewCount(product!.reviewCount!),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AppNetworkImage(
        url: imageUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        placeholderIcon: Icons.inventory_2_outlined,
        iconSize: 32,
      ),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 80, height: 80, radius: AppRadius.sm),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(height: 14, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.xs),
                _SkeletonBox(width: 120, height: 14, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.sm),
                _SkeletonBox(width: 80, height: 18, radius: AppRadius.xs),
                SizedBox(height: AppSpacing.xs),
                _SkeletonBox(width: 100, height: 12, radius: AppRadius.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RtiSummarySection extends StatelessWidget {
  const _RtiSummarySection();

  static const _icons = [
    Icons.verified_user_outlined,
    Icons.trending_down,
    Icons.chat_bubble_outline,
    Icons.check_circle_outline,
  ];
  static const _colors = [
    AppColors.success,
    AppColors.primary,
    AppColors.primary,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppLocalizations.of(context).landingGradeHigh,
      AppLocalizations.of(context).landingSummaryLowAd,
      AppLocalizations.of(context).landingSummaryFewRepeats,
      AppLocalizations.of(context).landingSummaryNoAnomalies,
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context).landingAnalysisSummary,
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.info_outline,
                size: 13,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      Icon(_icons[i], color: _colors[i], size: 22),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        labels[i],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RtiDisclaimer extends StatelessWidget {
  const _RtiDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            AppLocalizations.of(context).landingAnalysisDisclaimer,
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({this.width, required this.height, this.radius = 0});

  final double? width;
  final double height;
  final double radius;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween<double>(
      begin: 0.35,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

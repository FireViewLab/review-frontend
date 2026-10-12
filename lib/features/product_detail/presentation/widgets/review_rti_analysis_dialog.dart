import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_selected_review_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_score_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_signals_section.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_dialog_footer.dart';

void showReviewRtiAnalysisDialog(
  BuildContext context,
  ProductReview review, {
  int safeCount = 0,
  int warnCount = 0,
  int dangerCount = 0,
  int? productId,
  String productName = '',
}) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.overlay,
    builder: (_) => ReviewRtiAnalysisDialog(
      review: review,
      safeCount: safeCount,
      warnCount: warnCount,
      dangerCount: dangerCount,
      productId: productId,
      productName: productName,
    ),
  );
}

class ReviewRtiAnalysisDialog extends StatelessWidget {
  const ReviewRtiAnalysisDialog({
    super.key,
    required this.review,
    this.safeCount = 0,
    this.warnCount = 0,
    this.dangerCount = 0,
    this.productId,
    this.productName = '',
  });

  final ProductReview review;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width < 600 ? 12 : 24,
        vertical: 16,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 860),
        child: ClipRRect(
          borderRadius: AppRadius.large,
          child: Material(
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(onClose: () => Navigator.of(context).pop()),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: _DialogBody(
                      review: review,
                      safeCount: safeCount,
                      warnCount: warnCount,
                      dangerCount: dangerCount,
                    ),
                  ),
                ),
                RtiDialogFooter(
                  onClose: () => Navigator.of(context).pop(),
                  review: review,
                  productId: productId,
                  productName: productName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Analysis',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '리뷰 상세 분석',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  AppLocalizations.of(context).reviewIndividualScope,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: AppLocalizations.of(context).reportClose,
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceMuted,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dialog Body ─────────────────────────────────────────────────────────────

class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.review,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final ProductReview review;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    final detail = review.rtiDetail;
    final total = safeCount + warnCount + dangerCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RtiSelectedReviewSection(review: review),
        const SizedBox(height: AppSpacing.md),
        RtiScoreCard(review: review),
        if (detail != null && detail.signals.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          RtiSignalsSection(signals: detail.signals),
        ],
        if (detail != null && detail.judgmentBases.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          RtiJudgmentBasisSection(bases: detail.judgmentBases),
        ] else if (review.reasons.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          RtiReasonsSection(
            reasons: review.reasons,
            color: colorFromHex(review.rtiColor),
          ),
        ],
        if (total > 0) ...[
          const SizedBox(height: AppSpacing.md),
          ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            title: Text(
              AppLocalizations.of(context).reviewLoadedAggregate,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            children: [
              RtiRiskSummarySection(
                safeCount: safeCount,
                warnCount: warnCount,
                dangerCount: dangerCount,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─── Selected Review Section ─────────────────────────────────────────────────

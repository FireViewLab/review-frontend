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
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 860),
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
                    padding: EdgeInsets.all(
                      MediaQuery.sizeOf(context).width < 600
                          ? AppSpacing.md
                          : AppSpacing.lg,
                    ),
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
    final l = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.medium,
              ),
              child: const Icon(
                Icons.rate_review_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.reviewResultTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.reviewIndividualScope,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              onPressed: onClose,
              tooltip: l.reportClose,
              icon: const Icon(Icons.close, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceMuted,
              ),
            ),
          ],
        ),
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
        // 결과를 먼저 보여 주고 근거와 원문을 이어서 보여 준다.
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
        const SizedBox(height: AppSpacing.md),
        RtiSelectedReviewSection(review: review),
        if (total > 0) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.large,
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              tilePadding: const EdgeInsets.symmetric(horizontal: 20),
              childrenPadding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              title: Text(
                AppLocalizations.of(context).reviewLoadedAggregate,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              children: [
                RtiRiskSummarySection(
                  safeCount: safeCount,
                  warnCount: warnCount,
                  dangerCount: dangerCount,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Selected Review Section ─────────────────────────────────────────────────

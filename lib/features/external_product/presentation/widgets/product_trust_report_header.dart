import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/product_trust_report_data.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/shared/presentation/review_owl_assets.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';
import 'package:re_view_front/shared/widgets/rti_score_ring.dart';

class ProductTrustReportHeader extends StatelessWidget {
  const ProductTrustReportHeader({
    required this.data,
    required this.status,
    required this.missingReason,
    super.key,
  });
  final ProductTrustReportData data;
  final ProductReportStatus status;
  final String missingReason;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final score = data.score;
    final source = switch (data.source) {
      ProductScoreSource.detail => l.extTrustDetailSource,
      ProductScoreSource.catalog => l.extTrustCatalogSource,
      ProductScoreSource.none => null,
    };
    final grade = switch (data.grade) {
      ProductTrustGrade.safe => l.reviewAnalysisSafe,
      ProductTrustGrade.warn => l.reviewAnalysisWarn,
      ProductTrustGrade.danger => l.reviewAnalysisDanger,
      ProductTrustGrade.unknown => l.extTrustGradeMissing,
    };
    final color = switch (data.grade) {
      ProductTrustGrade.safe => AppColors.success,
      ProductTrustGrade.warn => AppColors.warning,
      ProductTrustGrade.danger => AppColors.error,
      ProductTrustGrade.unknown => AppColors.textSecondary,
    };
    final message = score == null
        ? missingReason
        : switch (data.grade) {
            ProductTrustGrade.safe => l.extTrustGuideSafe,
            ProductTrustGrade.warn ||
            ProductTrustGrade.danger => l.extTrustGuideCaution,
            ProductTrustGrade.unknown => l.extTrustGuideUnknown,
          };
    final result = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            borderRadius: AppRadius.small,
          ),
          child: Text(grade, style: theme.labelLarge?.copyWith(color: color)),
        ),
        if (source != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            source,
            style: theme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
        if (data.isV2) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(l.analysisPolicyExplanation, style: theme.bodySmall),
        ],
      ],
    );
    final counts = data.analysis?.levelCounts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (score == null) ...[
          Text(switch (status) {
            ProductReportStatus.ready => l.reportStateReady,
            ProductReportStatus.pending => l.reportBefore,
            ProductReportStatus.collecting => l.reportStateCollecting,
            ProductReportStatus.running => l.reportStateRunning,
            ProductReportStatus.failed => l.reportStateFailed,
            ProductReportStatus.stale => l.reportStateStale,
            ProductReportStatus.disabled => l.reportStateDisabled,
            ProductReportStatus.unavailable => l.reportStateUnavailable,
          }, style: theme.labelLarge),
          if (source != null) Text(source, style: theme.bodySmall),
        ] else
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
              final ring = Semantics(
                label: l.extTrustScoreValue(
                  data.analysis!.scoreName(context),
                  NumberFormat('0.#', l.localeName).format(score),
                ),
                child: ExcludeSemantics(
                  child: RtiScoreRing(
                    score: score,
                    color: color,
                    size: 112,
                    scoreLabel: data.analysis!.scoreName(context),
                    fitContent: true,
                  ),
                ),
              );
              final overview = LayoutBuilder(
                builder: (context, inner) {
                  if (inner.maxWidth < 380 * scale) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ring,
                        const SizedBox(height: AppSpacing.md),
                        result,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      ring,
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: result),
                    ],
                  );
                },
              );
              if (counts != null && constraints.maxWidth >= 700 * scale) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: overview),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: _TrustDistribution(counts: counts, data: data),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  overview,
                  if (counts != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _TrustDistribution(counts: counts, data: data),
                  ],
                ],
              );
            },
          ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Image.asset(ReviewOwlAssets.face, width: 24, height: 24),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustDistribution extends StatelessWidget {
  const _TrustDistribution({required this.counts, required this.data});
  final Map<String, int> counts;
  final ProductTrustReportData data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    final labels = [
      l.reviewAnalysisSafe,
      l.reviewAnalysisWarn,
      l.reviewAnalysisDanger,
    ];
    const colors = [AppColors.success, AppColors.warning, AppColors.error];
    const levels = ['SAFE', 'WARN', 'DANGER'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.extSummaryV2Grades, style: theme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < levels.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(labels[i], style: theme.bodySmall),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: AppRadius.small,
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : (counts[levels[i]] ?? 0) / total,
                      minHeight: 8,
                      color: colors[i],
                      backgroundColor: AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  NumberFormat.decimalPattern(
                    l.localeName,
                  ).format(counts[levels[i]] ?? 0),
                  style: theme.labelMedium,
                ),
              ],
            ),
          ),
        if (data.analysis?.attentionReviewsLabel(context)
            case final String attention)
          Text(
            attention,
            style: theme.labelMedium?.copyWith(color: AppColors.textPrimary),
          ),
      ],
    );
  }
}

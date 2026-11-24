import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/product_trust_report_data.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';
import 'package:re_view_front/shared/widgets/rti_score_ring.dart';

class ProductTrustReportHeader extends StatelessWidget {
  const ProductTrustReportHeader({
    required this.data,
    required this.status,
    required this.missingReason,
    this.loadedSource,
    super.key,
  });
  final ProductTrustReportData data;
  final ProductReportStatus status;
  final String missingReason;
  final String? loadedSource;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final score = data.score;
    final numbers = NumberFormat.decimalPattern(l.localeName);
    final source = switch (data.source) {
      ProductScoreSource.detail => l.extTrustDetailSource,
      ProductScoreSource.catalog => l.extTrustCatalogSource,
      ProductScoreSource.loadedReviews => loadedSource,
      ProductScoreSource.none => null,
    };
    final loadedScoreCount = data.loadedScoreCount;
    final loadedLevelCount = data.loadedLevelCount;
    final separateCounts =
        loadedScoreCount != null &&
        loadedLevelCount != null &&
        loadedScoreCount > 0 &&
        loadedLevelCount > 0 &&
        (loadedScoreCount != data.loadedReviewCount ||
            loadedLevelCount != data.loadedReviewCount);
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
    final secondary = theme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
      height: 1.5,
    );
    if (!data.hasResults) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: AppSpacing.xxs),
          Text(missingReason, style: secondary),
        ],
      );
    }
    final counts = data.analysis?.levelCounts;
    final distribution = counts == null
        ? null
        : _TrustDistribution(
            counts: counts,
            data: data,
            scope: separateCounts
                ? l.extTrustLoadedSource(numbers.format(loadedLevelCount))
                : null,
          );
    final scoreLabel = data.source == ProductScoreSource.loadedReviews
        ? l.extTrustLoadedAverage
        : data.analysis?.scoreName(context);
    final overview = score == null
        ? null
        : Row(
            children: [
              Semantics(
                label: l.extTrustScoreValue(
                  scoreLabel!,
                  NumberFormat('0.#', l.localeName).format(score),
                ),
                child: ExcludeSemantics(
                  child: RtiScoreRing(
                    score: score,
                    color: data.source == ProductScoreSource.loadedReviews
                        ? AppColors.primary
                        : color,
                    size: 88,
                    scoreLabel: 'RTI',
                    fitContent: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.source == ProductScoreSource.loadedReviews
                          ? scoreLabel
                          : grade,
                      style: theme.titleSmall?.copyWith(
                        color: data.source == ProductScoreSource.loadedReviews
                            ? AppColors.textPrimary
                            : color,
                      ),
                    ),
                    if (separateCounts)
                      Text(
                        l.extTrustLoadedSource(
                          numbers.format(loadedScoreCount),
                        ),
                        style: secondary,
                      ),
                    if (data.isV2)
                      Text(l.analysisPolicyExplanation, style: secondary),
                  ],
                ),
              ),
            ],
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (source != null) ...[
          Text(source, style: secondary),
          const SizedBox(height: AppSpacing.md),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
              if (overview != null &&
                  distribution != null &&
                  constraints.maxWidth >= 640 * scale) {
                return Row(
                  children: [
                    Expanded(child: overview),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(child: distribution),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ?overview,
                  if (overview != null && distribution != null)
                    const SizedBox(height: AppSpacing.md),
                  if (distribution != null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: distribution,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TrustDistribution extends StatelessWidget {
  const _TrustDistribution({
    required this.counts,
    required this.data,
    this.scope,
  });
  final Map<String, int> counts;
  final String? scope;
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
        if (scope case final String scope) Text(scope, style: theme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
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

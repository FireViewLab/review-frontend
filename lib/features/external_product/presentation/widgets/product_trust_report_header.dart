import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/product_trust_report_data.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/shared/widgets/owl_guide.dart';
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
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final score = data.score;
    final source = switch (data.source) {
      ProductScoreSource.detail => l10n.extTrustDetailSource,
      ProductScoreSource.catalog => l10n.extTrustCatalogSource,
      ProductScoreSource.none => null,
    };
    final grade = switch (data.grade) {
      ProductTrustGrade.safe => l10n.reviewAnalysisSafe,
      ProductTrustGrade.warn => l10n.reviewAnalysisWarn,
      ProductTrustGrade.danger => l10n.reviewAnalysisDanger,
      ProductTrustGrade.unknown => l10n.extTrustGradeMissing,
    };
    final color = switch (data.grade) {
      ProductTrustGrade.safe => AppColors.success,
      ProductTrustGrade.warn => AppColors.primaryDark,
      ProductTrustGrade.danger => AppColors.error,
      ProductTrustGrade.unknown => AppColors.textSecondary,
    };
    final icon = switch (data.grade) {
      ProductTrustGrade.safe => Icons.verified_outlined,
      ProductTrustGrade.warn => Icons.warning_amber_rounded,
      ProductTrustGrade.danger => Icons.gpp_bad_outlined,
      ProductTrustGrade.unknown => Icons.help_outline_rounded,
    };
    final message = score == null
        ? missingReason
        : switch (data.grade) {
            ProductTrustGrade.safe => l10n.extTrustGuideSafe,
            ProductTrustGrade.warn ||
            ProductTrustGrade.danger => l10n.extTrustGuideCaution,
            ProductTrustGrade.unknown => l10n.extTrustGuideUnknown,
          };
    final tone = score == null
        ? OwlGuideTone.info
        : switch (data.grade) {
            ProductTrustGrade.safe => OwlGuideTone.success,
            ProductTrustGrade.warn ||
            ProductTrustGrade.danger => OwlGuideTone.warning,
            ProductTrustGrade.unknown => OwlGuideTone.info,
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (score == null) ...[
          Text(switch (status) {
            ProductReportStatus.ready => l10n.reportStateReady,
            ProductReportStatus.pending => l10n.reportBefore,
            ProductReportStatus.collecting => l10n.reportStateCollecting,
            ProductReportStatus.running => l10n.reportStateRunning,
            ProductReportStatus.failed => l10n.reportStateFailed,
            ProductReportStatus.stale => l10n.reportStateStale,
            ProductReportStatus.disabled => l10n.reportStateDisabled,
            ProductReportStatus.unavailable => l10n.reportStateUnavailable,
          }, style: textTheme.labelLarge),
          if (source != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(source, style: textTheme.bodySmall),
          ],
        ] else
          LayoutBuilder(
            builder: (context, constraints) {
              final scoreLabel = data.analysis!.scoreName(context);
              final result = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    container: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .08),
                        borderRadius: AppRadius.small,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ExcludeSemantics(
                            child: Icon(icon, color: color, size: 18),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              grade,
                              style: textTheme.labelLarge?.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.extTrustScoreValue(
                      scoreLabel,
                      NumberFormat('0.#', l10n.localeName).format(score),
                    ),
                    style: textTheme.bodyLarge,
                  ),
                  if (source != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      source,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (data.isV2) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.analysisPolicyExplanation,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              );
              final ring = ExcludeSemantics(
                child: RtiScoreRing(
                  score: score,
                  color: color,
                  size: 112,
                  scoreLabel: scoreLabel,
                  fitContent: true,
                ),
              );
              if (constraints.maxWidth < 440 ||
                  MediaQuery.textScalerOf(context).scale(16) > 24) {
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
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: result),
                ],
              );
            },
          ),
        const SizedBox(height: AppSpacing.md),
        OwlGuide(message: message, tone: tone),
      ],
    );
  }
}

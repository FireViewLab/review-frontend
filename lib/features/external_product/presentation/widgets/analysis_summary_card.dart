import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/analysis_summary_data.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/owl_guide.dart';
import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';

class AnalysisSummaryCard extends ConsumerWidget {
  const AnalysisSummaryCard({required this.state, super.key});

  final ExternalProductState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    if (state.analysisState != ExternalAnalysisStatus.done) {
      final message = switch (state.analysisState) {
        ExternalAnalysisStatus.pending ||
        ExternalAnalysisStatus.running => l10n.extSummaryInProgress,
        ExternalAnalysisStatus.notAnalyzed => l10n.extSummaryNotAnalyzed,
        ExternalAnalysisStatus.failed => l10n.extSummaryFailed,
        ExternalAnalysisStatus.disabled => l10n.extSummaryDisabled,
        _ => l10n.extSummaryUnavailable,
      };
      return Text(
        message,
        style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }
    final analysis = state.analysis;
    final summary = analysis?.summary?.trim();
    if (summary != null && summary.isNotEmpty) {
      return OwlGuide(message: summary, title: l10n.extSummaryTitle);
    }
    final data = ref.watch(loadedReviewAnalysisSummaryProvider(state.reviews));
    final numbers = NumberFormat.decimalPattern(l10n.localeName);
    String count(int? value) =>
        value == null ? l10n.extSummaryMissingValue : numbers.format(value);
    String version(String? value) => value == null || value.trim().isEmpty
        ? l10n.extSummaryMissingValue
        : value;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryHeading(l10n.extSummaryFallbackTitle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              data.topReasons.isEmpty
                  ? l10n.extSummaryNoEvidence
                  : l10n.extSummaryFallbackIntro,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryFact(
              label: l10n.reportInputCount,
              value: count(analysis?.reviewCount),
            ),
            _SummaryFact(
              label: l10n.reportSourceCount,
              value: count(analysis?.sourceReviewCount),
            ),
            _SummaryFact(
              label: l10n.extSummarySampling,
              value: switch (analysis?.sampled) {
                true => l10n.reportSampled,
                false => l10n.extSummaryNotSampled,
                null => l10n.extSummaryMissingValue,
              },
            ),
            _SummaryFact(
              label: l10n.reportModel,
              value: version(analysis?.modelVersion),
            ),
            _SummaryFact(
              label: l10n.reportPolicy,
              value: version(analysis?.policyVersion),
            ),
            const Divider(height: AppSpacing.xl),
            _SummaryHeading(l10n.extSummaryLoadedScope(data.loadedCount)),
            const SizedBox(height: AppSpacing.xs),
            if (data.distributions.isEmpty)
              Text(l10n.extSummaryNoLoadedReviews)
            else
              for (final distribution in data.distributions)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _GradeDistribution(distribution: distribution),
                ),
            if (data.topReasons.isNotEmpty) ...[
              const Divider(height: AppSpacing.xl),
              _SummaryHeading(l10n.extSummaryEvidenceTitle),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.extSummaryEvidenceScope,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              for (final reason in data.topReasons)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ReviewEvidenceFormatter.text(
                          context,
                          reason.message,
                          detailed: true,
                        ),
                        style: textTheme.bodyMedium,
                      ),
                      Text(
                        l10n.extSummaryReasonCount(reason.count),
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryHeading extends StatelessWidget {
  const _SummaryHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _SummaryFact extends StatelessWidget {
  const _SummaryFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
    child: Text(
      AppLocalizations.of(context).extSummaryFact(label, value),
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}

class _GradeDistribution extends StatelessWidget {
  const _GradeDistribution({required this.distribution});

  final LoadedGradeDistribution distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (distribution.contract) {
      LoadedAnalysisContract.v2 => l10n.extSummaryV2Grades,
      LoadedAnalysisContract.legacy => l10n.extSummaryLegacyGrades,
      LoadedAnalysisContract.unknown => l10n.extSummaryUnknownVersion,
    };
    final grades = distribution.contract == LoadedAnalysisContract.unknown
        ? const [LoadedReviewGrade.notCalculable]
        : LoadedReviewGrade.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xxs),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (final grade in grades)
              Text(
                l10n.extSummaryGradeCount(switch (grade) {
                  LoadedReviewGrade.safe => l10n.extSummaryGradeSafe,
                  LoadedReviewGrade.warn => l10n.extSummaryGradeWarn,
                  LoadedReviewGrade.danger => l10n.extSummaryGradeDanger,
                  LoadedReviewGrade.notCalculable => l10n.analysisNotCalculable,
                }, distribution.count(grade)),
              ),
          ],
        ),
      ],
    );
  }
}

import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
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

class AnalysisSummaryCard extends ConsumerStatefulWidget {
  const AnalysisSummaryCard({required this.state, super.key});

  final ExternalProductState state;

  @override
  ConsumerState<AnalysisSummaryCard> createState() =>
      _AnalysisSummaryCardState();
}

class _AnalysisSummaryCardState extends ConsumerState<AnalysisSummaryCard> {
  bool _expanded = false;
  ExternalProductState get state => widget.state;

  @override
  void didUpdateWidget(covariant AnalysisSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.displayProduct?.ref != state.displayProduct?.ref) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final analysis = state.analysis;
    final display = analysis?.display;
    // 상세 응답의 상품 분석에는 v4 평균이 없으므로, v4 모델 정보가 왔는데
    // 점수가 비어 있을 때만 분석 중으로 안내한다.
    final explanation = state.analysisState != ExternalAnalysisStatus.done
        ? switch (state.analysisState) {
            ExternalAnalysisStatus.pending ||
            ExternalAnalysisStatus.running => l10n.extSummaryInProgress,
            ExternalAnalysisStatus.notAnalyzed => l10n.extSummaryNotAnalyzed,
            ExternalAnalysisStatus.failed => l10n.extSummaryFailed,
            ExternalAnalysisStatus.disabled => l10n.extSummaryDisabled,
            _ => l10n.extSummaryUnavailable,
          }
        : display?.isAwaitingScore == true && display?.modelVersion != null
        ? l10n.analysisPending
        : display?.localizedReasons(context).firstOrNull;
    final summary = analysis?.summary?.trim();
    final content = ReviewContentSummary.fromReviews(
      state.reviews,
      productName: state.displayProduct?.name ?? '',
    );
    final rating = content.average == null
        ? l10n.extSummaryMissingValue
        : NumberFormat('0.0', l10n.localeName).format(content.average);
    final distribution = List.generate(
      5,
      (i) => l10n.extReviewStarCount(i + 1, content.distribution[i]),
    ).reversed.join(' · ');
    final reviewMessage = [
      l10n.extReviewRatingSummary(content.loadedCount, rating, distribution),
      if (content.keywords.isNotEmpty)
        l10n.extReviewKeywords(content.keywords.join(' · ')),
      if (content.positive != null) l10n.extReviewPositive(content.positive!),
      if (content.negative != null) l10n.extReviewNegative(content.negative!),
    ].join('\n');
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
            if (content.loadedCount == 0)
              Text(l10n.extSummaryNoLoadedReviews)
            else
              OwlGuide(
                message: summary != null && summary.isNotEmpty
                    ? summary
                    : reviewMessage,
                title: l10n.extReviewSummaryTitle,
              ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: state.displayProduct == null
                  ? null
                  : () {
                      final productId = state.displayProduct!.ref.externalId;
                      final chat = ref.read(chatViewModelProvider.notifier);
                      chat.openConversation(productId: productId);
                      chat.send(
                        l10n.extReviewSummaryQuestion,
                        productId: productId,
                      );
                    },
              child: Text(
                l10n.extReviewSummaryRequest,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              expanded: _expanded,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: AppRadius.large,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryHeading(l10n.extSummaryEvidenceToggle),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                explanation ??
                    (data.topReasons.isEmpty
                        ? l10n.extSummaryNoEvidence
                        : l10n.extSummaryFallbackIntro),
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
                value: version(display?.modelVersion ?? analysis?.modelVersion),
              ),
              _SummaryFact(
                label: l10n.reportPolicy,
                value: version(
                  display?.policyVersion ?? analysis?.policyVersion,
                ),
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

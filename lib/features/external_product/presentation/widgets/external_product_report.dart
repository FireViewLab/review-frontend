import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/product_trust_report_data.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_analysis.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/product_trust_report_header.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

class ExternalProductReport extends StatelessWidget {
  const ExternalProductReport({super.key, required this.state});
  final ExternalProductState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final analysis = state.analysis;
    final data = ProductTrustReportData.fromState(state);
    final reportStatus = state.phase == ExternalProductPhase.collecting
        ? ProductReportStatus.collecting
        : switch (state.analysisState) {
            ExternalAnalysisStatus.done => ProductReportStatus.ready,
            ExternalAnalysisStatus.pending ||
            ExternalAnalysisStatus.running => ProductReportStatus.running,
            ExternalAnalysisStatus.failed => ProductReportStatus.failed,
            ExternalAnalysisStatus.disabled => ProductReportStatus.disabled,
            ExternalAnalysisStatus.notAnalyzed => ProductReportStatus.pending,
            _ =>
              state.analysisStatus.toUpperCase() == 'STALE'
                  ? ProductReportStatus.stale
                  : ProductReportStatus.unavailable,
          };
    final message = switch (reportStatus) {
      ProductReportStatus.collecting => l.reportCollecting,
      ProductReportStatus.running => l.extTrustRunning,
      ProductReportStatus.failed => l.reportFailed,
      ProductReportStatus.disabled => l.reportDisabled,
      ProductReportStatus.stale => l.reportStale,
      ProductReportStatus.pending => l.extTrustBefore,
      ProductReportStatus.ready when data.isNotCalculable =>
        l.analysisNotCalculable,
      ProductReportStatus.ready when data.score == null => l.extTrustNoAverage,
      ProductReportStatus.ready => l.reportDone,
      ProductReportStatus.unavailable => l.reportUnavailable,
    };
    final done = state.analysisState == ExternalAnalysisStatus.done;
    final reviews = done
        ? state.reviews.where((r) => r.analysisDisplay.hasResult).toList()
        : const <ExternalReview>[];
    final hasDetails = data.hasComponents || data.reasons.isNotEmpty;
    final coverageInSummary =
        done &&
        analysis != null &&
        (analysis.summary == null || analysis.summary!.trim().isEmpty);
    final catalog = data.source == ProductScoreSource.catalog
        ? state.summary?.catalogAnalysis
        : null;
    return ProductReportCard(
      status: reportStatus,
      summary: message,
      resultHeader: ProductTrustReportHeader(
        data: data,
        status: reportStatus,
        missingReason: message,
      ),
      content: hasDetails ? _ScoreDetails(data: data) : null,
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportDetailSection(
            title: l.reportOverview,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                if (catalog != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(l.reportCatalogSource),
                  if (catalog.reviewCount != null)
                    ReportFactRow(
                      label: l.reportInputCount,
                      value: '${catalog.reviewCount}',
                    ),
                  if (catalog.sourceReviewCount != null)
                    ReportFactRow(
                      label: l.reportSourceCount,
                      value: '${catalog.sourceReviewCount}',
                    ),
                ],
              ],
            ),
          ),
          if (hasDetails) _ScoreDetails(data: data),
          if (done && analysis != null)
            ReportDetailSection(
              title: l.reportCoverage,
              child: coverageInSummary
                  ? Text(l.extTrustCoverageInSummary)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (analysis.reviewCount != null)
                          ReportFactRow(
                            label: l.reportInputCount,
                            value: '${analysis.reviewCount}',
                          ),
                        if (analysis.sourceReviewCount != null)
                          ReportFactRow(
                            label: l.reportSourceCount,
                            value: '${analysis.sourceReviewCount}',
                          ),
                        if (analysis.sampled != null)
                          ReportFactRow(
                            label: l.reportCoverage,
                            value: analysis.sampled!
                                ? l.reportSampled
                                : l.extSummaryNotSampled,
                          ),
                        if (analysis.modelVersion != null)
                          ReportFactRow(
                            label: l.reportModel,
                            value: analysis.modelVersion!,
                          ),
                        if (analysis.policyVersion != null)
                          ReportFactRow(
                            label: l.reportPolicy,
                            value: analysis.policyVersion!,
                          ),
                      ],
                    ),
            ),
          ReportDetailSection(
            title: l.reportReviewResults,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.reportLoadedScope,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.md),
                if (reviews.isEmpty)
                  Text(l.reportNoReviewResults)
                else ...[
                  ReportFactRow(
                    label: l.reportCurrentCount,
                    value: '${reviews.length}',
                  ),
                  _ReviewAnalysisList(reviews: reviews),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreDetails extends StatelessWidget {
  const _ScoreDetails({required this.data});

  final ProductTrustReportData data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final breakdown = data.breakdown;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.hasComponents) ...[
          ReportSectionTitle(title: l.extTrustComponents),
          const SizedBox(height: AppSpacing.sm),
          _ComponentScore(
            label: l.analysisTextScore,
            score: breakdown?.textScore,
            explanation: l.extTrustTextExplanation,
          ),
          _ComponentScore(
            label: l.analysisBehaviorScore,
            score: breakdown?.behaviorScore,
            explanation: l.extTrustBehaviorExplanation,
          ),
          _ComponentScore(
            label: l.analysisNetworkScore,
            score: breakdown?.networkScore,
            explanation: l.extTrustNetworkExplanation,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ReportSectionTitle(title: l.reportReasons),
        const SizedBox(height: AppSpacing.sm),
        if (data.reasons.isEmpty)
          Text(l.extTrustNoEvidence)
        else
          for (final reason in data.reasons)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                ReviewEvidenceFormatter.text(context, reason, detailed: true),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _ComponentScore extends StatelessWidget {
  const _ComponentScore({
    required this.label,
    required this.score,
    required this.explanation,
  });

  final String label;
  final double? score;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final value = ProductTrustReportData.validScore(score);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportFactRow(
            label: label,
            value: value == null
                ? l.analysisNotCalculable
                : '${NumberFormat('0.#', l.localeName).format(value)} / 100',
          ),
          Text(
            explanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 리뷰를 많이 불러온 뒤 팝업을 열어도 한 번에 모두 그리지 않도록 20개씩 펼친다.
class _ReviewAnalysisList extends StatefulWidget {
  const _ReviewAnalysisList({required this.reviews});

  final List<ExternalReview> reviews;

  @override
  State<_ReviewAnalysisList> createState() => _ReviewAnalysisListState();
}

class _ReviewAnalysisListState extends State<_ReviewAnalysisList> {
  static const _step = 20;
  int _visible = _step;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.reviews;
    final count = reviews.length < _visible ? reviews.length : _visible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final review in reviews.take(count))
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: ExternalReviewAnalysisDetails(
              review: review,
              embedded: true,
            ),
          ),
        if (count < reviews.length)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: TextButton(
              onPressed: () => setState(() => _visible += _step),
              child: Text(
                '${AppLocalizations.of(context).extProductReviewsMore} '
                '($count/${reviews.length})',
              ),
            ),
          ),
      ],
    );
  }
}

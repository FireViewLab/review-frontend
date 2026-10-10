import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_analysis.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

class ExternalProductReport extends StatelessWidget {
  const ExternalProductReport({super.key, required this.state});
  final ExternalProductState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final analysis = state.analysis;
    final status = state.analysisStatus.toUpperCase();
    final reportStatus = state.phase == ExternalProductPhase.collecting
        ? ProductReportStatus.collecting
        : switch (status) {
            'DONE' => ProductReportStatus.ready,
            'QUEUED' || 'RUNNING' => ProductReportStatus.running,
            'FAILED' => ProductReportStatus.failed,
            'DISABLED' => ProductReportStatus.disabled,
            'STALE' => ProductReportStatus.stale,
            'NOT_ANALYZED' => ProductReportStatus.pending,
            _ => ProductReportStatus.unavailable,
          };
    final display = state.displayProduct;
    final candidate =
        display != null && state.summary?.matches(display.ref) == true
        ? state.summary?.catalogAnalysis
        : null;
    final catalog = status == 'DONE' && candidate?.isCurrent == true
        ? candidate
        : null;
    final hasResults = status == 'DONE' && analysis != null;
    final summary = switch (reportStatus) {
      ProductReportStatus.collecting => l.reportCollecting,
      ProductReportStatus.running => l.reportRunning,
      ProductReportStatus.failed => l.reportFailed,
      ProductReportStatus.disabled => l.reportDisabled,
      ProductReportStatus.stale => l.reportStale,
      ProductReportStatus.pending => l.reportPendingBody,
      ProductReportStatus.ready when hasResults || catalog != null =>
        l.reportDone,
      _ => l.reportUnavailable,
    };
    final reviews = hasResults
        ? state.reviews
              .where(
                (r) => r.rti != null || r.level != null || r.reasons.isNotEmpty,
              )
              .toList()
        : [];
    return ProductReportCard(
      status:
          reportStatus == ProductReportStatus.ready &&
              !hasResults &&
              catalog == null
          ? ProductReportStatus.unavailable
          : reportStatus,
      score: catalog?.averageRti,
      summary: summary,
      metrics: [
        if (hasResults && analysis.reviewCount != null)
          ProductReportMetric(l.reportInputCount, '${analysis.reviewCount}'),
        if (hasResults && analysis.sampled != null)
          ProductReportMetric(
            l.reportCoverage,
            analysis.sampled! ? l.reportSampled : l.reportFull,
          ),
      ],
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportDetailSection(
            title: l.reportOverview,
            child: Text(
              summary,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),
          if (catalog != null)
            ReportDetailSection(
              title: l.reportScoreLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReportFactRow(
                    label: l.reportCatalogAverage,
                    value: '${catalog.averageRti} / 100',
                  ),
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
                  if (catalog.sampled != null)
                    ReportFactRow(
                      label: l.reportCoverage,
                      value: catalog.sampled! ? l.reportSampled : l.reportFull,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.reportCatalogSource,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          if (hasResults)
            ReportDetailSection(
              title: l.reportCoverage,
              child: Column(
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
                    Text(analysis.sampled! ? l.reportSampled : l.reportFull),
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
                  for (final review in reviews)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: ExternalReviewAnalysisDetails(review: review),
                        ),
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
}

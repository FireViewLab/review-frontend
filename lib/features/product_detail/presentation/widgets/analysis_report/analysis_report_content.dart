import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_reviews.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_trend.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

/// Read-only report from results already supplied by the product/review APIs.
/// Does not turn loaded review counts into product-wide ratios or evidence.
class AnalysisReportContent extends StatelessWidget {
  const AnalysisReportContent({
    super.key,
    required this.productId,
    required this.detail,
    required this.reviews,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.trend,
    required this.onBackToProduct,
  });
  final int productId;
  final ProductDetail detail;
  final List<ProductReview> reviews;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<AnalysisTrendPoint> trend;
  final VoidCallback onBackToProduct;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final analyzed = reviews
        .where(
          (r) =>
              r.rtiScore != null || r.rtiLabel != null || r.reasons.isNotEmpty,
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(detail.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ReportDetailSection(
          title: l.reportOverview,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAnalyzing) Text(l.reportRunning),
              if (detail.avgRti != null)
                ReportFactRow(
                  label: l.reportScoreLabel,
                  value: '${detail.avgRti} / 100',
                )
              else if (analyzed.isEmpty &&
                  detail.trustSignals.isEmpty &&
                  !isAnalyzing)
                Text(l.reportPendingBody),
              if (detail.rtiGrade != null) Text(detail.rtiGrade!),
              for (final signal in detail.trustSignals)
                ReportFactRow(
                  label: ReviewEvidenceFormatter.text(context, signal.label),
                  value: ReviewEvidenceFormatter.text(context, signal.value),
                ),
            ],
          ),
        ),
        ReportDetailSection(
          title: l.reportCoverage,
          child: Text(l.reportLoadedScope),
        ),
        Text(
          l.reportReviewResults,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        if (analyzed.isEmpty)
          Text(l.reportNoReviewResults)
        else ...[
          Text('${l.reportCurrentCount}: ${analyzed.length}'),
          AnalysisReportReviewListSection(
            reviews: analyzed,
            isAnalyzing: isAnalyzing,
          ),
          for (final review in analyzed.where((r) => r.reasons.isNotEmpty))
            ExpansionTile(
              title: Text(
                review.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(l.reportReasons),
              children: [
                for (final reason in ReviewEvidenceFormatter.list(
                  context,
                  review.reasons,
                  detailed: true,
                ))
                  ListTile(title: Text(reason)),
              ],
            ),
        ],
        if (trend.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          AnalysisReportTrendSection(trend: trend, isAnalyzing: false),
        ],
        const SizedBox(height: AppSpacing.md),
        TextButton(onPressed: onBackToProduct, child: Text(l.reportClose)),
      ],
    );
  }
}

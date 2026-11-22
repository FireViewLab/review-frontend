import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

/// Uses only the result already present on the product; no analysis request.
class RtiSummaryCard extends StatelessWidget {
  const RtiSummaryCard({
    super.key,
    required this.rtiSummary,
    required this.onDetailPressed,
    this.loadedAnalysisCount = 0,
    this.isAnalyzing = false,
    this.analysis,
  });
  final AnalysisDisplay? analysis;
  final int loadedAnalysisCount;
  final bool isAnalyzing;
  final RtiSummary? rtiSummary;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final summary = rtiSummary;
    return ProductReportCard(
      status: isAnalyzing || analysis?.isAwaitingScore == true
          ? ProductReportStatus.running
          : summary != null || analysis?.isV2 == true || loadedAnalysisCount > 0
          ? ProductReportStatus.ready
          : ProductReportStatus.pending,
      score: analysis?.isV2 == true
          ? analysis?.score
          : summary?.rtiScore.toDouble(),
      scoreLabel: analysis?.isV2 == true ? analysis!.scoreName(context) : null,
      summary: analysis?.isV2 == true && !isAnalyzing
          ? (analysis?.score == null
                ? analysis!.badgeText(context)
                : analysis!.localizedReasons(context).firstOrNull ??
                      l.reportDone)
          : isAnalyzing
          ? l.reportRunning
          : summary != null
          ? l.reportDone
          : loadedAnalysisCount > 0
          ? l.reportDone
          : l.reportPendingBody,
      metrics: [
        if (loadedAnalysisCount > 0)
          ProductReportMetric(l.reportCurrentCount, '$loadedAnalysisCount'),
      ],
      details: const SizedBox.shrink(),
      onDetailPressed: onDetailPressed,
    );
  }
}

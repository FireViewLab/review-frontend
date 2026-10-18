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
  });
  final int loadedAnalysisCount;
  final bool isAnalyzing;
  final RtiSummary? rtiSummary;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final summary = rtiSummary;
    return ProductReportCard(
      status: isAnalyzing
          ? ProductReportStatus.running
          : summary != null || loadedAnalysisCount > 0
          ? ProductReportStatus.ready
          : ProductReportStatus.pending,
      score: summary?.rtiScore.toDouble(),
      summary: isAnalyzing
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

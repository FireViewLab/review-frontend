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
      summary: isAnalyzing
          ? l.reportRunning
          : summary != null
          ? 'RTI ${summary.rtiScore}'
          : loadedAnalysisCount > 0
          ? l.reportDone
          : l.reportBefore,
      facts: [
        if (loadedAnalysisCount > 0)
          '${l.reportCurrentCount}: $loadedAnalysisCount',
      ],
      details: const SizedBox.shrink(),
      onDetailPressed: onDetailPressed,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/report_guide_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/report_process_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/report_summary_card.dart';

class ReportSidePanel extends StatelessWidget {
  const ReportSidePanel({
    super.key,
    required this.selectedCount,
    required this.evidenceCount,
  });

  final int selectedCount;
  final int evidenceCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportSummaryCard(
          selectedCount: selectedCount,
          evidenceCount: evidenceCount,
        ),
        const SizedBox(height: AppSpacing.md),
        const ReportProcessCard(),
        const SizedBox(height: AppSpacing.md),
        const ReportGuideCard(),
      ],
    );
  }
}

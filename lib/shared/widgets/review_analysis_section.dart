import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

/// Reading sections for one review, without requesting or synthesizing analysis.
class ReviewAnalysisSection extends StatelessWidget {
  const ReviewAnalysisSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });
  final String title;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportSectionTitle(title: title, trailing: trailing),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}

class ReviewEvidenceText extends StatelessWidget {
  const ReviewEvidenceText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.subdirectory_arrow_right_rounded,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: SelectableText(
            ReviewEvidenceFormatter.text(context, text, detailed: true),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      ],
    ),
  );
}

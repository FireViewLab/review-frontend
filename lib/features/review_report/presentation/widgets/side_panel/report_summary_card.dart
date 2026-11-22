import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/side_panel_header.dart';

class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({
    super.key,
    required this.selectedCount,
    required this.evidenceCount,
    this.reviewTargetCount = 1,
    this.avgReviewHours = 24,
  });

  final int selectedCount;
  final int evidenceCount;
  final int reviewTargetCount;
  final int avgReviewHours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SidePanelHeader(
            icon: Icons.assignment_outlined,
            title: AppLocalizations.of(context).reportSummaryTitle,
            description: AppLocalizations.of(context).reportSummaryDescription,
            badgeLabel: AppLocalizations.of(context).reportLiveBadge,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  value: '$selectedCount',
                  label: AppLocalizations.of(context).reportSelectedReasons,
                  highlight: selectedCount > 0,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _MetricBox(
                  value: '$evidenceCount',
                  label: AppLocalizations.of(context).reportAnalysisEvidence,
                  highlight: evidenceCount > 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  value: '${avgReviewHours}h',
                  label: AppLocalizations.of(
                    context,
                  ).reportAverageReviewRound(1),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _MetricBox(
                  value: AppLocalizations.of(
                    context,
                  ).reportReviewCount(reviewTargetCount),
                  label: AppLocalizations.of(context).reportTargetReviews,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.value,
    required this.label,
    this.highlight = false,
  });

  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.base),
      curve: AppMotion.enter,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.06)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.border,
          width: highlight ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

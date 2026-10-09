import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

/// Results supplied for this review. A missing score never becomes zero/safe.
class ExternalReviewAnalysis extends StatelessWidget {
  const ExternalReviewAnalysis({
    super.key,
    required this.review,
    required this.analysisStatus,
  });
  final ExternalReview review;
  final String analysisStatus;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final level = review.level?.trim();
    final hasResult =
        analysisStatus.toUpperCase() == 'DONE' &&
        (review.rti != null ||
            (level != null && level.isNotEmpty) ||
            review.reasons.isNotEmpty);
    if (!hasResult) {
      return Text(switch (analysisStatus.toUpperCase()) {
        'QUEUED' || 'RUNNING' => l.reportRunning,
        'FAILED' => l.reportFailed,
        'STALE' => l.reportStale,
        'DISABLED' => l.reportDisabled,
        'DONE' => l.reviewAnalysisMissing,
        'NOT_ANALYZED' => l.reportBefore,
        _ => l.reportUnavailable,
      }, style: Theme.of(context).textTheme.bodySmall);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResultBadges(review: review),
        if (review.reasons.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              review.reasons.first,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        TextButton.icon(
          icon: const Icon(Icons.fact_check_outlined, size: 18),
          label: Text(l.reportDetails),
          onPressed: () => showProductReport(
            context,
            ExternalReviewAnalysisDetails(review: review),
          ),
        ),
      ],
    );
  }
}

/// Shared by the per-review dialog and the product report; opens no API request.
class ExternalReviewAnalysisDetails extends StatelessWidget {
  const ExternalReviewAnalysisDetails({super.key, required this.review});
  final ExternalReview review;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SelectableText(review.content),
      const SizedBox(height: AppSpacing.sm),
      _ResultBadges(review: review),
      if (review.reasons.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppLocalizations.of(context).reportReasons,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        for (final reason in review.reasons)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: SelectableText('• $reason'),
          ),
      ],
    ],
  );
}

class _ResultBadges extends StatelessWidget {
  const _ResultBadges({required this.review});
  final ExternalReview review;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final level = review.level?.trim();
    final (label, color) = switch (level?.toLowerCase()) {
      'safe' => (l.reviewAnalysisSafe, AppColors.success),
      'warn' || 'suspicious' => (l.reviewAnalysisWarn, AppColors.warning),
      'danger' => (l.reviewAnalysisDanger, AppColors.error),
      _ => (level, AppColors.textSecondary),
    };
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        if (review.rti != null) Chip(label: Text('RTI ${review.rti}')),
        if (label != null && label.isNotEmpty)
          Chip(
            label: Text(label, style: TextStyle(color: color)),
            side: BorderSide(color: color.withValues(alpha: .3)),
            backgroundColor: color.withValues(alpha: .08),
          ),
      ],
    );
  }
}

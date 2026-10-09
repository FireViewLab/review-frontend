import 'package:re_view_front/shared/widgets/review_analysis_section.dart';
import 'package:re_view_front/shared/widgets/review_photo_view.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';
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
            title: l.reviewResultTitle,
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
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final images = validReviewImages(review.images);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.reviewIndividualScope,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ReviewAnalysisSection(
          title: l.reviewOriginal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (review.author?.trim().isNotEmpty == true) ...[
                Text(
                  review.author!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              SelectableText(
                review.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.7),
              ),
              if (images.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (_, index) => ImagePreviewThumbnail(
                      imageUrls: images,
                      index: index,
                      size: 80,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ReviewAnalysisSection(
          title: l.reviewResultTitle,
          child: _ResultBadges(review: review, prominent: true),
        ),
        if (review.reasons.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ReviewAnalysisSection(
            title: l.reportReasons,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final reason in review.reasons)
                  ReviewEvidenceText(text: reason),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ResultBadges extends StatelessWidget {
  const _ResultBadges({required this.review, this.prominent = false});
  final ExternalReview review;
  final bool prominent;
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
        if (review.rti != null)
          if (prominent)
            Text(
              'RTI ${review.rti}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            )
          else
            Chip(label: Text('RTI ${review.rti}')),
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

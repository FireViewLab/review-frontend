import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/rti_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/review_report/presentation/providers/review_report_dep_providers.dart';

class RtiDialogFooter extends ConsumerWidget {
  const RtiDialogFooter({
    super.key,
    required this.onClose,
    required this.review,
    this.productId,
    this.productName = '',
  });

  final VoidCallback onClose;
  final ProductReview review;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alreadyReported = ref
        .watch(reportedReviewIdsProvider)
        .contains(review.id);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 13,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context).detailDisclaimer,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: onClose,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: Text(
              AppLocalizations.of(context).reportClose,
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: () => showRtiCriteriaDialog(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: Text(
              AppLocalizations.of(context).detailCriteria,
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: alreadyReported
                ? () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          AppLocalizations.of(
                            context,
                          ).reportAlreadyReportedTitle,
                        ),
                        content: Text(
                          AppLocalizations.of(
                            context,
                          ).reportAlreadyReportedDescription,
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppLocalizations.of(context).actionConfirm,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                : () {
                    Navigator.of(context).pop();
                    context.goNamed(
                      RouteNames.reviewReport,
                      extra: {
                        'reviewId': review.id,
                        'productId': productId,
                        'productName': productName,
                        'reviewContent': review.content,
                        'rtiScore': review.analysisDisplay.isV2
                            ? null
                            : review.rtiScore?.toDouble(),
                        'rtiGrade': review.analysisDisplay.isV2
                            ? null
                            : review.rtiLabel,
                      },
                    );
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: alreadyReported
                    ? AppColors.textTertiary
                    : AppColors.error,
              ),
              foregroundColor: alreadyReported
                  ? AppColors.textTertiary
                  : AppColors.error,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: Text(
              alreadyReported
                  ? AppLocalizations.of(context).detailReported
                  : AppLocalizations.of(context).detailReportReview,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared: Section Card ─────────────────────────────────────────────────────

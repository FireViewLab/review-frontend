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
              '분석 결과는 참고용이며 최종 판단은 여러 리뷰를 함께 확인해주세요.',
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
            child: const Text('닫기', style: TextStyle(fontSize: 13)),
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
            child: const Text('분석 기준', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: alreadyReported
                ? () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('이미 신고한 리뷰'),
                        content: const Text(
                          '이 리뷰는 이미 신고하셨습니다.\n중복 신고는 접수되지 않아요.',
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
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
                        'rtiScore': review.rtiScore?.toDouble(),
                        'rtiGrade': review.rtiLabel,
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
              alreadyReported ? '신고 완료' : '리뷰 신고',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared: Section Card ─────────────────────────────────────────────────────

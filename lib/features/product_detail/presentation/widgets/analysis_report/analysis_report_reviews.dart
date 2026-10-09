// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Review List Section
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportReviewListSection extends StatelessWidget {
  const AnalysisReportReviewListSection({
    required this.reviews,
    required this.isAnalyzing,
  });

  final List<ProductReview> reviews;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '최신 리뷰 순서',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                if (isAnalyzing)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'AI 분석 중',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (reviews.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Text(
                    '분석된 리뷰가 없습니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              for (var i = 0; i < reviews.length; i++) ...[
                AnalysisReportReviewRow(review: reviews[i]),
                if (i < reviews.length - 1)
                  const Divider(color: AppColors.border, height: AppSpacing.lg),
              ],
          ],
        ),
      ),
    );
  }
}

class AnalysisReportReviewRow extends StatelessWidget {
  const AnalysisReportReviewRow({required this.review});
  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final rtiColor = _parseColor(review.rtiColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (review.createdAt.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      review.createdAt,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round() ? Icons.star : Icons.star_outline,
                    size: 11,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                review.content,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (review.reasons.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  children:
                      ReviewEvidenceFormatter.list(context, review.reasons)
                          .take(2)
                          .map(
                            (r) => DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.errorSoft,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                child: Text(
                                  r,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AnalysisReportRtiBadge(
          score: review.rtiScore,
          label: review.rtiLabel,
          color: rtiColor,
        ),
      ],
    );
  }

  static Color _parseColor(String? hex) {
    try {
      return Color(
        int.parse('FF${(hex ?? '').replaceAll('#', '')}', radix: 16),
      );
    } catch (_) {
      return AppColors.textSecondary;
    }
  }
}

class AnalysisReportRtiBadge extends StatelessWidget {
  const AnalysisReportRtiBadge({
    required this.score,
    required this.label,
    required this.color,
  });

  final int? score;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            score == null ? '분석 전' : 'RTI $score',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
          if (score != null && label?.isNotEmpty == true) ...[
            const SizedBox(width: 4),
            Container(width: 1, height: 9, color: color.withValues(alpha: 0.3)),
            const SizedBox(width: 4),
            Text(
              label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

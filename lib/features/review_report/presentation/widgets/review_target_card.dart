import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';

class ReviewTargetCard extends StatelessWidget {
  const ReviewTargetCard({
    super.key,
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    this.onGoToAnalysis,
  });

  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final VoidCallback? onGoToAnalysis;

  bool get _isDanger {
    final g = rtiGrade.toUpperCase();
    return g == 'DANGER' || g == 'SUSPICIOUS';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '신고 대상 리뷰',
      description: '신고하려는 상품과 리뷰가 맞는지 확인해주세요.',
      trailing: rtiScore > 0
          ? _RtiBadge(isDanger: _isDanger, score: rtiScore)
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(score: rtiScore, isDanger: _isDanger),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (reviewContent.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '"$reviewContent"',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (onGoToAnalysis != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    InkWell(
                      onTap: onGoToAnalysis,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '분석 팝업에서 이동',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.score, required this.isDanger});

  final double score;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.error : AppColors.primary;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score > 0 ? score.toStringAsFixed(0) : '-',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: 18,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'RTI',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RtiBadge extends StatelessWidget {
  const _RtiBadge({required this.isDanger, required this.score});

  final bool isDanger;
  final double score;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.error : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isDanger
            ? '위험 리뷰 · RTI ${score.toStringAsFixed(0)}'
            : 'RTI ${score.toStringAsFixed(0)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

class RtiSummaryCard extends StatelessWidget {
  const RtiSummaryCard({
    super.key,
    required this.rtiSummary,
    required this.onDetailPressed,
  });

  final RtiSummary? rtiSummary;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    final rtiSummary = this.rtiSummary;
    if (rtiSummary == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Text('분석 전'),
      );
    }
    if (!rtiSummary.hasReviewMetrics) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'RTI ${rtiSummary.rtiScore}${rtiSummary.rtiLabel.isEmpty ? "" : " · ${rtiSummary.rtiLabel}"}',
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '리뷰 신뢰도 요약',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Icon(Icons.info_outline, size: 16, color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Re:view AI가 ${formatSearchCount(rtiSummary.analyzedReviewCount)}개 리뷰를 분석한 결과입니다.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 480;
              final metrics = [
                _MetricData(
                  label: 'RTI 점수',
                  value: rtiSummary.rtiScore.toString(),
                  badge: rtiSummary.rtiLabel,
                  description: rtiSummary.rtiSubLabel,
                  isPositive: rtiSummary.rtiScore >= 70,
                ),
                _MetricData(
                  label: '실사용 리뷰 비율',
                  value: '${(rtiSummary.realReviewRatio * 100).round()}%',
                  badge: rtiSummary.realReviewLabel,
                  description: '실사용 경험 기반',
                  isPositive: rtiSummary.realReviewRatio >= 0.7,
                ),
                _MetricData(
                  label: '광고성 의심 비율',
                  value: '${(rtiSummary.adSuspicionRatio * 100).round()}%',
                  badge: rtiSummary.adSuspicionLabel,
                  description: rtiSummary.adSuspicionLabel == '낮음'
                      ? '광고성 낮음'
                      : '광고성 의심',
                  isPositive: rtiSummary.adSuspicionRatio <= 0.15,
                ),
                _MetricData(
                  label: '반복 표현 비율',
                  value: '${(rtiSummary.repetitionRatio * 100).round()}%',
                  badge: rtiSummary.repetitionLabel,
                  description: rtiSummary.repetitionLabel == '낮음'
                      ? '자연스러운 표현'
                      : '반복 표현 많음',
                  isPositive: rtiSummary.repetitionRatio <= 0.15,
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: metrics
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _MetricTile(metric: m),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: metrics
                    .map(
                      (m) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxs,
                          ),
                          child: _MetricTile(metric: m),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.small,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      rtiSummary.summaryMessage,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onDetailPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '자세히 보기',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.badge,
    required this.description,
    required this.isPositive,
  });

  final String label;
  final String value;
  final String badge;
  final String description;
  final bool isPositive;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    final color = metric.isPositive ? AppColors.success : AppColors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              metric.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                child: Text(
                  metric.badge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          metric.description,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Analysis Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportSummaryCard extends StatelessWidget {
  const AnalysisReportSummaryCard({
    required this.rtiSummary,
    required this.reviews,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final RtiSummary rtiSummary;
  final List<ProductReview> reviews;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    final reasonCounts = <String, int>{};
    for (final r in reviews) {
      for (final s in r.reasons) {
        if (s.isNotEmpty) reasonCounts[s] = (reasonCounts[s] ?? 0) + 1;
      }
    }
    final topReasons =
        (reasonCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .take(4)
            .map((e) => e.key)
            .toList();

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
            Text(
              '분석 요약',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Stat grid 2x2
            Row(
              children: [
                Expanded(
                  child: AnalysisReportStatTile(
                    label: '분석 리뷰',
                    value: '${rtiSummary.analyzedReviewCount}개',
                    icon: Icons.reviews_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AnalysisReportStatTile(
                    label: '평균 RTI',
                    value: '${rtiSummary.rtiScore}점',
                    icon: Icons.verified_user_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AnalysisReportStatTile(
                    label: '위험 리뷰',
                    value: '$dangerCount개',
                    icon: Icons.warning_amber_outlined,
                    valueColor: AppColors.error,
                    iconColor: AppColors.error,
                    bgColor: AppColors.error.withValues(alpha: 0.06),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AnalysisReportStatTile(
                    label: '신뢰 리뷰',
                    value: '$safeCount개',
                    icon: Icons.check_circle_outline,
                    valueColor: AppColors.success,
                    iconColor: AppColors.success,
                    bgColor: AppColors.success.withValues(alpha: 0.06),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSpacing.md),
            Text(
              '주요 신호',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            topReasons.isEmpty
                ? Text(
                    '분석 신호 없음',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  )
                : Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: ReviewEvidenceFormatter.list(
                      context,
                      topReasons,
                    ).map((r) => AnalysisReportSignalChip(label: r)).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class AnalysisReportStatTile extends StatelessWidget {
  const AnalysisReportStatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.iconColor,
    this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final Color? iconColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.surfaceMuted,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: iconColor ?? AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalysisReportSignalChip extends StatelessWidget {
  const AnalysisReportSignalChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            size: 10,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

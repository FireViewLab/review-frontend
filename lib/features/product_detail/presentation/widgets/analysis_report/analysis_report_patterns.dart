// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pattern Section
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportPatternData {
  const AnalysisReportPatternData({required this.label, required this.count});
  final String label;
  final int count;
}

class AnalysisReportPatternSection extends StatelessWidget {
  const AnalysisReportPatternSection({required this.patterns});
  final List<AnalysisReportPatternData> patterns;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

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
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.errorSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '리뷰 이유 패턴',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '반복적으로 나타나는 의심 패턴입니다.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            isNarrow
                ? Column(
                    children: patterns
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: AnalysisReportPatternTile(pattern: p),
                          ),
                        )
                        .toList(),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < patterns.length; i += 2) ...[
                        Row(
                          children: [
                            Expanded(
                              child: AnalysisReportPatternTile(
                                pattern: patterns[i],
                              ),
                            ),
                            if (i + 1 < patterns.length) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: AnalysisReportPatternTile(
                                  pattern: patterns[i + 1],
                                ),
                              ),
                            ] else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                        if (i + 2 < patterns.length)
                          const SizedBox(height: AppSpacing.xs),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class AnalysisReportPatternTile extends StatelessWidget {
  const AnalysisReportPatternTile({required this.pattern});
  final AnalysisReportPatternData pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            const Icon(Icons.error_outline, size: 16, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${pattern.count}개 리뷰에서 감지',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.error.withValues(alpha: 0.65),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_trend_chart.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Trend Section
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportTrendSection extends StatefulWidget {
  const AnalysisReportTrendSection({
    required this.trend,
    required this.isAnalyzing,
  });
  final List<AnalysisTrendPoint> trend;
  final bool isAnalyzing;

  @override
  State<AnalysisReportTrendSection> createState() =>
      AnalysisReportTrendSectionState();
}

class AnalysisReportTrendSectionState
    extends State<AnalysisReportTrendSection> {
  int _selectedDays = 30;

  List<AnalysisTrendPoint> get _filtered {
    if (widget.trend.isEmpty) return [];
    final cutoff = DateTime.now().subtract(Duration(days: _selectedDays));
    final filtered = widget.trend.where((p) {
      try {
        return DateTime.parse(p.date).isAfter(cutoff);
      } catch (_) {
        return true;
      }
    }).toList();
    return filtered.isEmpty ? widget.trend : filtered;
  }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '위험도 추이',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '상품 리뷰의 평균 RTI와 위험 리뷰 비율 변화를 보여줘요.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Period tabs
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [7, 30, 90].map((d) {
                        final selected = _selectedDays == d;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDays = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                              boxShadow: selected
                                  ? [
                                      const BoxShadow(
                                        color: AppColors.shadow,
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              '$d일',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: selected
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary,
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Chart area
            if (widget.isAnalyzing && widget.trend.isEmpty)
              Shimmer.fromColors(
                enabled: !MediaQuery.disableAnimationsOf(context),
                baseColor: const Color(0xFFE5E7EB),
                highlightColor: const Color(0xFFF9FAFB),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              )
            else if (widget.trend.isEmpty)
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 36,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'AI 분석 완료 후 위험도 추이를 확인할 수 있습니다',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: AnalysisReportTrendChart(points: _filtered),
              ),
            if (widget.trend.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  AnalysisReportLegendDot(
                    color: AppColors.primary,
                    label: '평균 RTI',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AnalysisReportLegendDash(
                    color: const Color(0xFFF97316),
                    label: '위험 리뷰 비율',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AnalysisReportLegendDot extends StatelessWidget {
  const AnalysisReportLegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 3, color: color),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class AnalysisReportLegendDash extends StatelessWidget {
  const AnalysisReportLegendDash({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
              width: 6,
              height: 2,
              margin: const EdgeInsets.only(right: 2),
              color: color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

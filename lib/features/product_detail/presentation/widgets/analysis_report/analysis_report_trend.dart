import 'package:re_view_front/l10n/generated/app_localizations.dart';
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shimmer/shimmer.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/presentation/formatters/analysis_trend_period.dart';
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final points = filterAnalysisTrendByPeriod(
      widget.trend,
      now: now,
      days: _selectedDays,
    );
    final l10n = AppLocalizations.of(context);
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
                        AppLocalizations.of(context).detailTrend,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).detailTrendDescription,
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
                              AppLocalizations.of(context).adminPeriodDays(d),
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
                baseColor: AppColors.border,
                highlightColor: const Color(0xFFF9FAFB),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              )
            else if (points.isEmpty)
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 36,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.detailTrendEmptyPeriod,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (points.length == 1)
              _SingleTrendObservation(observation: points.single)
            else ...[
              SizedBox(
                height: 200,
                child: AnalysisReportTrendChart(points: points, today: now),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  AnalysisReportLegendDot(
                    color: AppColors.primary,
                    label: AppLocalizations.of(context).detailAverageRti,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AnalysisReportLegendDash(
                    color: const Color(0xFFF97316),
                    label: AppLocalizations.of(context).detailRiskyReviewRatio,
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

class _SingleTrendObservation extends StatelessWidget {
  const _SingleTrendObservation({required this.observation});

  final DatedAnalysisTrendPoint observation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = DateFormat.yMMMd(
      l10n.localeName,
    ).format(observation.localDate);
    final score = observation.point.averageRti;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            Text(date, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Flexible(child: Text(l10n.detailTrendSingleScore(score))),
              ],
            ),
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

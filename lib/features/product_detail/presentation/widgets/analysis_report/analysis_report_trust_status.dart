// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Trust Status Card (Right)
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportTrustStatusCard extends StatelessWidget {
  const AnalysisReportTrustStatusCard({
    required this.detail,
    required this.rtiSummary,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.isAnalyzing,
  });

  final ProductDetail detail;
  final RtiSummary rtiSummary;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    final total = safeCount + warnCount + dangerCount;
    final (riskColor, riskBg, riskLabel, riskTitle) = _resolveRisk(
      rtiSummary.rtiScore,
    );

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '전체 리뷰 신뢰 상태',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: riskColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      riskLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              riskTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Score + description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular score
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: riskBg,
                    border: Border.all(color: riskColor, width: 2.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rtiSummary.rtiScore.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: riskColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        'RTI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: riskColor.withValues(alpha: 0.75),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _buildDescription(rtiSummary, detail.trustSignals),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Distribution bars
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                AnalysisReportDistRow(
                  label: '신뢰',
                  count: safeCount,
                  total: total,
                  color: AppColors.success,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
                const SizedBox(height: 10),
                AnalysisReportDistRow(
                  label: '의심',
                  count: warnCount,
                  total: total,
                  color: AppColors.warning,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
                const SizedBox(height: 10),
                AnalysisReportDistRow(
                  label: '위험',
                  count: dangerCount,
                  total: total,
                  color: AppColors.error,
                  isAnalyzing: isAnalyzing && total == 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _buildDescription(
    RtiSummary rtiSummary,
    List<TrustSignal> signals,
  ) {
    if (signals.isNotEmpty) {
      final negSignals = signals.where((s) => !s.isPositive).toList();
      if (negSignals.isNotEmpty) {
        return '${negSignals.map((s) => s.label).take(2).join('과 ')} 등 의심 신호가 감지되었어요. 구매 전 신뢰 리뷰를 꼼꼼히 확인하는 것을 권장합니다.';
      }
    }
    return '${rtiSummary.analyzedReviewCount}개 리뷰를 AI가 분석했습니다. 신뢰도 점수와 분포를 참고하여 구매를 결정하세요.';
  }

  static (Color, Color, String, String) _resolveRisk(int score) {
    if (score >= 70) {
      return (
        AppColors.success,
        AppColors.successSoft,
        '신뢰 구간',
        '신뢰할 수 있는 상품입니다',
      );
    } else if (score >= 40) {
      return (
        AppColors.warning,
        AppColors.warningSoft,
        '의심 구간',
        '주의가 필요한 상품입니다',
      );
    } else {
      return (
        AppColors.error,
        AppColors.errorSoft,
        '위험 구간',
        '리뷰 신뢰도가 낮은 상품입니다',
      );
    }
  }
}

class AnalysisReportDistRow extends StatelessWidget {
  const AnalysisReportDistRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    required this.isAnalyzing,
  });

  final String label;
  final int count;
  final int total;
  final Color color;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    final pctText = '${(pct * 100).round()}%';

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: isAnalyzing
              ? Shimmer.fromColors(
                  enabled: !MediaQuery.disableAnimationsOf(context),
                  baseColor: const Color(0xFFE5E7EB),
                  highlightColor: const Color(0xFFF9FAFB),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: pct,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.12),
                    minHeight: 8,
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 34,
          child: Text(
            pctText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_trust_status.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_summary.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_actions.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_product_hero.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_trend.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_patterns.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_reviews.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Report Content
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportContent extends StatelessWidget {
  const AnalysisReportContent({
    required this.productId,
    required this.detail,
    required this.reviews,
    required this.isAnalyzing,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.trend,
    required this.onBackToProduct,
  });

  final int productId;
  final ProductDetail detail;
  final List<ProductReview> reviews;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<AnalysisTrendPoint> trend;
  final VoidCallback onBackToProduct;

  @override
  Widget build(BuildContext context) {
    if (detail.rtiSummary == null || !detail.rtiSummary!.hasReviewMetrics) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('분석 전'),
            TextButton(
              onPressed: onBackToProduct,
              child: const Text('상품으로 돌아가기'),
            ),
          ],
        ),
      );
    }
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    final topPatterns = _aggregateTopPatterns(reviews);

    // Derive distribution from reviews' rtiScore when analysis counts not yet available
    final int effSafe, effWarn, effDanger;
    if (safeCount + warnCount + dangerCount == 0 && reviews.isNotEmpty) {
      int s = 0, w = 0, d = 0;
      for (final r in reviews) {
        if (r.rtiScore <= 0) continue;
        if (r.rtiScore >= 70) {
          s++;
        } else if (r.rtiScore >= 40) {
          w++;
        } else {
          d++;
        }
      }
      effSafe = s;
      effWarn = w;
      effDanger = d;
    } else {
      effSafe = safeCount;
      effWarn = warnCount;
      effDanger = dangerCount;
    }

    final rightColumn = Column(
      children: [
        AnalysisReportTrustStatusCard(
          detail: detail,
          rtiSummary: detail.rtiSummary!,
          safeCount: effSafe,
          warnCount: effWarn,
          dangerCount: effDanger,
          isAnalyzing: isAnalyzing,
        ),
        const SizedBox(height: AppSpacing.md),
        AnalysisReportSummaryCard(
          rtiSummary: detail.rtiSummary!,
          reviews: reviews,
          safeCount: effSafe,
          warnCount: effWarn,
          dangerCount: effDanger,
        ),
        const SizedBox(height: AppSpacing.md),
        AnalysisReportRecommendedActionsCard(onGoToReviews: onBackToProduct),
      ],
    );

    final leftColumn = Column(
      children: [
        AnalysisReportProductHeroCard(
          detail: detail,
          isAnalyzing: isAnalyzing,
          onBack: onBackToProduct,
        ),
        const SizedBox(height: AppSpacing.lg),
        AnalysisReportTrendSection(trend: trend, isAnalyzing: isAnalyzing),
        if (topPatterns.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AnalysisReportPatternSection(patterns: topPatterns),
        ],
        const SizedBox(height: AppSpacing.lg),
        AnalysisReportReviewListSection(
          reviews: reviews,
          isAnalyzing: isAnalyzing,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalysisReportBackButton(onPressed: onBackToProduct),
        const SizedBox(height: AppSpacing.md),
        if (isNarrow)
          Column(
            children: [
              AnalysisReportProductHeroCard(
                detail: detail,
                isAnalyzing: isAnalyzing,
                onBack: onBackToProduct,
              ),
              const SizedBox(height: AppSpacing.md),
              AnalysisReportTrustStatusCard(
                detail: detail,
                rtiSummary: detail.rtiSummary!,
                safeCount: effSafe,
                warnCount: effWarn,
                dangerCount: effDanger,
                isAnalyzing: isAnalyzing,
              ),
              const SizedBox(height: AppSpacing.md),
              AnalysisReportSummaryCard(
                rtiSummary: detail.rtiSummary!,
                reviews: reviews,
                safeCount: effSafe,
                warnCount: effWarn,
                dangerCount: effDanger,
              ),
              const SizedBox(height: AppSpacing.md),
              AnalysisReportTrendSection(
                trend: trend,
                isAnalyzing: isAnalyzing,
              ),
              const SizedBox(height: AppSpacing.md),
              AnalysisReportRecommendedActionsCard(
                onGoToReviews: onBackToProduct,
              ),
              if (topPatterns.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                AnalysisReportPatternSection(patterns: topPatterns),
              ],
              const SizedBox(height: AppSpacing.lg),
              AnalysisReportReviewListSection(
                reviews: reviews,
                isAnalyzing: isAnalyzing,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 58, child: leftColumn),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(width: 320, child: rightColumn),
            ],
          ),
      ],
    );
  }

  static List<AnalysisReportPatternData> _aggregateTopPatterns(
    List<ProductReview> reviews,
  ) {
    final counts = <String, int>{};
    for (final review in reviews) {
      for (final reason in review.reasons) {
        if (reason.isNotEmpty) {
          counts[reason] = (counts[reason] ?? 0) + 1;
        }
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted
        .take(4)
        .map((e) => AnalysisReportPatternData(label: e.key, count: e.value))
        .toList();
  }
}

class AnalysisReportBackButton extends StatelessWidget {
  const AnalysisReportBackButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.textSecondary,
      ),
      icon: const Icon(Icons.arrow_back_ios, size: 13),
      label: Text(
        '상품 페이지로 돌아가기',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

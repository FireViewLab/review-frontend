import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_score_gauge.dart';
import 'admin_dashboard_card.dart';
import 'admin_dashboard_chart.dart';

class AdminDashboardPerformanceSection extends StatelessWidget {
  const AdminDashboardPerformanceSection({
    super.key,
    required this.performance,
    required this.days,
  });

  final AdminModelPerformance performance;
  final int days;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1200;
    final distribution = AdminDashboardDistributionCard(
      distribution: performance.rtiDistribution,
      total: performance.totalAnalyzedReviews,
    );
    final average = AdminDashboardAverageRtiCard(
      score: performance.averageRtiScore,
    );
    final agreement = AdminDashboardAgreementCard(
      stats: performance.userAgreement,
    );
    final feedback = AdminDashboardFeedbackStatsCard(
      stats: performance.feedbackStats,
    );

    Widget pair(Widget a, Widget b, {int flexA = 1, int flexB = 1}) => wide
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: flexA, child: a),
                const SizedBox(width: AppSpacing.md),
                Expanded(flex: flexB, child: b),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              a,
              const SizedBox(height: AppSpacing.md),
              b,
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        pair(distribution, average, flexA: 2),
        const SizedBox(height: AppSpacing.md),
        AdminDashboardTrendCard(trend: performance.dailyTrend, days: days),
        const SizedBox(height: AppSpacing.md),
        pair(agreement, feedback),
      ],
    );
  }
}

class AdminDashboardDistributionCard extends StatelessWidget {
  const AdminDashboardDistributionCard({
    super.key,
    required this.distribution,
    required this.total,
  });

  final RtiDistribution distribution;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminDashboardCard(
      title: l10n.adminRtiDistribution,
      trailing: Text(
        l10n.adminAnalyzedCount(formatAdminCount(total)),
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
      child: Column(
        children: [
          AdminDashboardRatioRow(
            label: l10n.adminSafe,
            color: AppColors.success,
            count: distribution.safeCount,
            percent: distribution.safePercent,
          ),
          AdminDashboardRatioRow(
            label: l10n.adminSuspicious,
            color: AppColors.warning,
            count: distribution.suspiciousCount,
            percent: distribution.suspiciousPercent,
          ),
          AdminDashboardRatioRow(
            label: l10n.adminDanger,
            color: AppColors.error,
            count: distribution.dangerCount,
            percent: distribution.dangerPercent,
          ),
        ],
      ),
    );
  }
}

class AdminDashboardAverageRtiCard extends StatelessWidget {
  const AdminDashboardAverageRtiCard({super.key, required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminDashboardCard(
      title: l10n.adminAverageRti,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminScoreGauge(score: score),
        ],
      ),
    );
  }
}

class AdminDashboardAgreementCard extends StatelessWidget {
  const AdminDashboardAgreementCard({super.key, required this.stats});

  final UserAgreementStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final disagreeRate = stats.totalFeedbacks == 0
        ? 0.0
        : 100 - stats.agreementRate;
    return AdminDashboardCard(
      title: l10n.adminUserAgreement,
      trailing: Text(
        l10n.adminFeedbackCount(formatAdminCount(stats.totalFeedbacks)),
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
      child: Column(
        children: [
          AdminDashboardRatioRow(
            label: l10n.adminAgree,
            color: AppColors.primary,
            count: stats.agreementCount,
            percent: stats.agreementRate,
          ),
          AdminDashboardRatioRow(
            label: l10n.adminDisagree,
            color: AppColors.textTertiary,
            count: stats.disagreementCount,
            percent: disagreeRate,
          ),
        ],
      ),
    );
  }
}

class AdminDashboardFeedbackStatsCard extends StatelessWidget {
  const AdminDashboardFeedbackStatsCard({super.key, required this.stats});

  final AnalysisFeedbackStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total =
        stats.submitted + stats.underReview + stats.resolved + stats.rejected;
    double percent(int count) => total == 0 ? 0 : count * 100 / total;
    return AdminDashboardCard(
      title: l10n.adminFeedbackStats,
      trailing: Text(
        l10n.adminResolutionRate(stats.resolutionRate.toStringAsFixed(1)),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      child: Column(
        children: [
          AdminDashboardRatioRow(
            label: l10n.adminFeedbackSubmitted,
            color: AppColors.info,
            count: stats.submitted,
            percent: percent(stats.submitted),
          ),
          AdminDashboardRatioRow(
            label: l10n.adminUnderReview,
            color: AppColors.warning,
            count: stats.underReview,
            percent: percent(stats.underReview),
          ),
          AdminDashboardRatioRow(
            label: l10n.adminApplied,
            color: AppColors.success,
            count: stats.resolved,
            percent: percent(stats.resolved),
          ),
          AdminDashboardRatioRow(
            label: l10n.adminDismissed,
            color: AppColors.textTertiary,
            count: stats.rejected,
            percent: percent(stats.rejected),
          ),
        ],
      ),
    );
  }
}

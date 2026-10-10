import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_dashboard_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_score_gauge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

const _periodOptions = [7, 30, 90];

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminDashboardViewModelProvider);
    final vm = ref.read(adminDashboardViewModelProvider.notifier);

    return AdminPageScaffold(
      title: l10n.adminDashboardTitle,
      subtitle: l10n.adminDashboardSubtitle,
      scrollable: true,
      actions: [
        IconButton(
          tooltip: l10n.adminRefresh,
          onPressed: vm.refresh,
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.textSecondary,
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AsyncSection(
            value: state.summary,
            onRetry: vm.refresh,
            height: 220,
            builder: (summary) => _SummaryGrid(summary: summary),
          ),
          const SizedBox(height: AppSpacing.xl),
          // 좁은 화면에서는 기간 선택기가 제목 아래로 내려간다.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                l10n.adminModelPerformance,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SegmentedButton<int>(
                segments: [
                  for (final days in _periodOptions)
                    ButtonSegment(
                      value: days,
                      label: Text(l10n.adminPeriodDays(days)),
                    ),
                ],
                selected: {state.days},
                showSelectedIcon: false,
                onSelectionChanged: (selection) => vm.setDays(selection.first),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _AsyncSection(
            value: state.performance,
            onRetry: vm.refresh,
            height: 480,
            builder: (performance) =>
                _PerformanceSection(performance: performance, days: state.days),
          ),
        ],
      ),
    );
  }
}

class _AsyncSection<T> extends StatelessWidget {
  const _AsyncSection({
    required this.value,
    required this.onRetry,
    required this.height,
    required this.builder,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;

  /// 로딩·오류 상태에서 자리를 잡아 두는 높이.
  final double height;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (value) {
      AsyncData(:final value) => builder(value),
      AsyncError(:final error) => SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error.toString(),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(onPressed: onRetry, child: Text(l10n.adminRetry)),
            ],
          ),
        ),
      ),
      _ => SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cards = [
      _KpiItem(
        icon: Icons.rate_review_outlined,
        color: AppColors.primary,
        label: l10n.adminTotalReviews,
        value: summary.totalReviews,
        helper: l10n.adminTotalReviewsHelper,
      ),
      _KpiItem(
        icon: Icons.report_gmailerrorred_outlined,
        color: AppColors.warning,
        label: l10n.adminSuspiciousReviews,
        value: summary.suspiciousReviewCount,
        route: RoutePaths.adminReviews,
      ),
      _KpiItem(
        icon: Icons.dangerous_outlined,
        color: AppColors.error,
        label: l10n.adminRiskyReviews,
        value: summary.dangerReviewCount,
        route: RoutePaths.adminReviews,
      ),
      _KpiItem(
        icon: Icons.flag_outlined,
        color: AppColors.warning,
        label: l10n.adminPendingReports,
        value: summary.pendingReports,
        route: RoutePaths.adminReports,
      ),
      _KpiItem(
        icon: Icons.feedback_outlined,
        color: AppColors.info,
        label: l10n.adminPendingFeedbacks,
        value: summary.pendingAnalysisFeedbacks,
        route: RoutePaths.adminAnalysisFeedbacks,
      ),
      _KpiItem(
        icon: Icons.group_outlined,
        color: AppColors.success,
        label: l10n.adminTotalUsers,
        value: summary.totalUsers,
        route: RoutePaths.adminUsers,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900 ? 3 : 2;
        final width =
            (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final item in cards)
              SizedBox(
                width: width,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: item.route == null
                      ? null
                      : () => context.go(item.route!),
                  child: AdminKpiCard(
                    icon: item.icon,
                    iconColor: item.color,
                    label: item.label,
                    value: formatAdminCount(item.value),
                    helper: item.helper ?? l10n.adminOpenSection,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _KpiItem {
  const _KpiItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.helper,
    this.route,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int value;
  final String? helper;
  final String? route;
}

class _PerformanceSection extends StatelessWidget {
  const _PerformanceSection({required this.performance, required this.days});

  final AdminModelPerformance performance;
  final int days;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1200;
    final distribution = _DistributionCard(
      distribution: performance.rtiDistribution,
      total: performance.totalAnalyzedReviews,
    );
    final average = _AverageRtiCard(score: performance.averageRtiScore);
    final agreement = _AgreementCard(stats: performance.userAgreement);
    final feedback = _FeedbackStatsCard(stats: performance.feedbackStats);

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
        _TrendCard(trend: performance.dailyTrend, days: days),
        const SizedBox(height: AppSpacing.md),
        pair(agreement, feedback),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

/// 비율 막대와 범례를 한 줄씩 그리는 공통 행.
class _RatioRow extends StatelessWidget {
  const _RatioRow({
    required this.label,
    required this.color,
    required this.count,
    required this.percent,
  });

  final String label;
  final Color color;
  final int count;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                minHeight: 10,
                color: color,
                backgroundColor: AppColors.surfaceMuted,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 120,
            child: Text(
              l10n.adminCountPercent(
                formatAdminCount(count),
                percent.toStringAsFixed(1),
              ),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution, required this.total});

  final RtiDistribution distribution;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Card(
      title: l10n.adminRtiDistribution,
      trailing: Text(
        l10n.adminAnalyzedCount(formatAdminCount(total)),
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
      child: Column(
        children: [
          _RatioRow(
            label: l10n.adminSafe,
            color: AppColors.success,
            count: distribution.safeCount,
            percent: distribution.safePercent,
          ),
          _RatioRow(
            label: l10n.adminSuspicious,
            color: AppColors.warning,
            count: distribution.suspiciousCount,
            percent: distribution.suspiciousPercent,
          ),
          _RatioRow(
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

class _AverageRtiCard extends StatelessWidget {
  const _AverageRtiCard({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Card(
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

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.trend, required this.days});

  final List<DailyRtiTrend> trend;
  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Card(
      title: l10n.adminDailyTrendTitle(days),
      child: trend.isEmpty
          ? SizedBox(
              height: 160,
              child: Center(
                child: Text(
                  l10n.adminTrendEmpty,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          : _TrendChart(trend: trend),
    );
  }
}

/// 막대 높이는 평균 RTI(0~100), 막대 위 숫자는 분석 건수다.
class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});

  final List<DailyRtiTrend> trend;

  static const double _chartHeight = 160;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 막대가 많으면 날짜 라벨을 건너뛰어 겹치지 않게 한다.
    final labelEvery = (trend.length / 10).ceil().clamp(1, 30);
    return SizedBox(
      height: _chartHeight + 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (index, point) in trend.indexed)
            Expanded(
              child: Tooltip(
                message: l10n.adminTrendTooltip(
                  formatAdminDate(point.date),
                  point.averageRti.toStringAsFixed(1),
                  formatAdminCount(point.reviewCount),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height:
                            (point.averageRti / 100).clamp(0.02, 1.0) *
                            _chartHeight,
                        decoration: BoxDecoration(
                          color: _barColor(point.averageRti),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.xs),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      SizedBox(
                        height: 16,
                        child: index % labelEvery == 0
                            ? FittedBox(
                                child: Text(
                                  '${point.date.month}/${point.date.day}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// RTI 등급 색 (안전 70 이상, 의심 40 이상, 그 아래 위험).
  Color _barColor(double rti) {
    if (rti >= 70) return AppColors.success;
    if (rti >= 40) return AppColors.warning;
    return AppColors.error;
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({required this.stats});

  final UserAgreementStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final disagreeRate = stats.totalFeedbacks == 0
        ? 0.0
        : 100 - stats.agreementRate;
    return _Card(
      title: l10n.adminUserAgreement,
      trailing: Text(
        l10n.adminFeedbackCount(formatAdminCount(stats.totalFeedbacks)),
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
      child: Column(
        children: [
          _RatioRow(
            label: l10n.adminAgree,
            color: AppColors.primary,
            count: stats.agreementCount,
            percent: stats.agreementRate,
          ),
          _RatioRow(
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

class _FeedbackStatsCard extends StatelessWidget {
  const _FeedbackStatsCard({required this.stats});

  final AnalysisFeedbackStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total =
        stats.submitted + stats.underReview + stats.resolved + stats.rejected;
    double percent(int count) => total == 0 ? 0 : count * 100 / total;
    return _Card(
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
          _RatioRow(
            label: l10n.adminFeedbackSubmitted,
            color: AppColors.info,
            count: stats.submitted,
            percent: percent(stats.submitted),
          ),
          _RatioRow(
            label: l10n.adminUnderReview,
            color: AppColors.warning,
            count: stats.underReview,
            percent: percent(stats.underReview),
          ),
          _RatioRow(
            label: l10n.adminApplied,
            color: AppColors.success,
            count: stats.resolved,
            percent: percent(stats.resolved),
          ),
          _RatioRow(
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

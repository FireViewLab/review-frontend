import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_dashboard_providers.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'admin_dashboard_performance.dart';

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
            builder: (performance) => AdminDashboardPerformanceSection(
              performance: performance,
              days: state.days,
            ),
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

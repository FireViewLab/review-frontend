import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_analysis_feedback_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/analysis_feedback_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/analysis_feedback_status_tone.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminAnalysisFeedbacksPage extends ConsumerWidget {
  const AdminAnalysisFeedbacksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminAnalysisFeedbackViewModelProvider);
    final vm = ref.read(adminAnalysisFeedbackViewModelProvider.notifier);

    return AdminPageScaffold(
      title: l10n.adminMenuAnalysisFeedbacks,
      subtitle: l10n.adminFeedbacksSubtitle,
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusTabs(
                  current: state.statusFilter,
                  onSelect: vm.selectStatus,
                ),
                const SizedBox(height: AppSpacing.lg),
                _KpiRow(state: state),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: _TableArea(state: state, vm: vm)),
              ],
            ),
          ),
          if (state.selected != null) ...[
            const SizedBox(width: AppSpacing.lg),
            AnalysisFeedbackDetailPanel(
              feedback: state.selected!,
              onClose: vm.clearSelection,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.current, required this.onSelect});

  final AnalysisFeedbackStatus? current;
  final ValueChanged<AnalysisFeedbackStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = <(String, AnalysisFeedbackStatus?)>[
      (l10n.adminAll, null),
      for (final s in AnalysisFeedbackStatus.values)
        (s.localizedLabel(l10n), s),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final (label, status) in tabs)
            _TabItem(
              label: label,
              active: current == status,
              onTap: () => onSelect(status),
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.state});

  final AdminAnalysisFeedbackState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String valueFor(AnalysisFeedbackStatus? s) {
      final count = state.countFor(s);
      return count == null ? '-' : formatAdminCount(count);
    }

    final cards = <Widget>[
      AdminKpiCard(
        icon: Icons.description_outlined,
        iconColor: AppColors.primary,
        label: l10n.adminTotalFeedbacks,
        value: valueFor(null),
        helper: l10n.adminAllTime,
      ),
      AdminKpiCard(
        icon: Icons.outbox_outlined,
        iconColor: AppColors.info,
        label: l10n.adminFeedbackSubmitted,
        value: valueFor(AnalysisFeedbackStatus.submitted),
        helper: l10n.adminFeedbackSubmitted,
      ),
      AdminKpiCard(
        icon: Icons.hourglass_empty_rounded,
        iconColor: AppColors.warning,
        label: l10n.adminUnderReview,
        value: valueFor(AnalysisFeedbackStatus.underReview),
        helper: l10n.adminUnderReview,
      ),
      AdminKpiCard(
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.success,
        label: l10n.adminFeedbackResolved,
        value: valueFor(AnalysisFeedbackStatus.resolved),
        helper: l10n.adminFeedbackResolved,
      ),
      AdminKpiCard(
        icon: Icons.cancel_outlined,
        iconColor: AppColors.error,
        label: l10n.adminFeedbackRejected,
        value: valueFor(AnalysisFeedbackStatus.rejected),
        helper: l10n.adminFeedbackRejected,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

class _TableArea extends StatelessWidget {
  const _TableArea({required this.state, required this.vm});

  final AdminAnalysisFeedbackState state;
  final AdminAnalysisFeedbackViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(onPressed: vm.refresh, child: Text(l10n.adminRetry)),
          ],
        ),
      );
    }

    final columns = [
      AdminTableColumn(label: l10n.adminFeedbackId, flex: 3),
      AdminTableColumn(label: l10n.adminReviewId, flex: 3),
      AdminTableColumn(label: l10n.adminProductName, flex: 3),
      AdminTableColumn(label: l10n.adminFeedbackType, flex: 3),
      AdminTableColumn(label: l10n.adminUserJudgment, flex: 3),
      AdminTableColumn(label: l10n.adminStatus, flex: 2),
      AdminTableColumn(label: l10n.adminCreatedAt, flex: 3),
    ];

    final rows = [
      for (final f in state.items)
        AdminTableRowData(
          id: f.feedbackId,
          cells: [
            _cell('FB-${f.feedbackId}', strong: true),
            _cell('RWV-${f.reviewId}'),
            _cell(f.productName),
            _cell(
              f.feedbackTypeDescription.isEmpty
                  ? f.feedbackType
                  : f.feedbackTypeDescription,
            ),
            _cell(analysisUserJudgmentLabel(f.userJudgment, l10n)),
            f.status == null
                ? _cell('-')
                : Align(
                    alignment: Alignment.centerLeft,
                    child: AdminStatusBadge(
                      label: f.status!.localizedLabel(l10n),
                      tone: f.status!.tone,
                    ),
                  ),
            _cell(formatAdminDateTime(f.createdAt)),
          ],
        ),
    ];

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: columns,
        rows: rows,
        selectedId: state.selected?.feedbackId,
        onRowTap: (row) {
          final item = state.items.firstWhere((f) => f.feedbackId == row.id);
          vm.selectItem(item);
        },
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: l10n.adminFeedbacksEmpty,
      ),
    );
  }

  Widget _cell(String text, {bool strong = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary,
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

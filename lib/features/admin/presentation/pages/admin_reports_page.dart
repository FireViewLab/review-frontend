import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_report_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_bulk_action_bar.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_filter_field.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_status_tone.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminReportsPage extends ConsumerWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminReportViewModelProvider);
    final vm = ref.read(adminReportViewModelProvider.notifier);

    return AdminPageScaffold(
      title: l10n.adminMenuReports,
      subtitle: l10n.adminReportsSubtitle,
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
                _FilterBar(state: state, vm: vm),
                const SizedBox(height: AppSpacing.lg),
                _KpiRow(state: state),
                const SizedBox(height: AppSpacing.lg),
                _BulkBar(state: state, vm: vm),
                const SizedBox(height: AppSpacing.sm),
                Expanded(child: _TableArea(state: state, vm: vm)),
              ],
            ),
          ),
          if (state.selected != null) ...[
            const SizedBox(width: AppSpacing.lg),
            ReportDetailPanel(
              report: state.selected!,
              onClose: vm.clearSelection,
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        AdminDropdownField<ReportStatus?>(
          label: l10n.adminStatus,
          value: state.statusFilter,
          width: 180,
          items: [
            AdminDropdownItem(value: null, label: l10n.adminAll),
            AdminDropdownItem(
              value: ReportStatus.pending,
              label: l10n.adminReportPending,
            ),
            AdminDropdownItem(
              value: ReportStatus.underReview,
              label: l10n.adminUnderReview,
            ),
            AdminDropdownItem(
              value: ReportStatus.accepted,
              label: l10n.adminReportAccepted,
            ),
            AdminDropdownItem(
              value: ReportStatus.rejected,
              label: l10n.adminReportRejected,
            ),
          ],
          onChanged: vm.selectStatus,
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.state});

  final AdminReportState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String valueFor(ReportStatus? s) {
      final count = state.countFor(s);
      return count == null ? '-' : formatAdminCount(count);
    }

    final cards = <Widget>[
      AdminKpiCard(
        icon: Icons.description_outlined,
        iconColor: AppColors.primary,
        label: l10n.adminTotalReports,
        value: valueFor(null),
        helper: l10n.adminReportsCountHelper,
      ),
      AdminKpiCard(
        icon: Icons.hourglass_empty_rounded,
        iconColor: AppColors.warning,
        label: l10n.adminReportPending,
        value: valueFor(ReportStatus.pending),
        helper: l10n.adminPendingReportsHelper,
      ),
      AdminKpiCard(
        icon: Icons.person_search_outlined,
        iconColor: AppColors.info,
        label: l10n.adminUnderReview,
        value: valueFor(ReportStatus.underReview),
        helper: l10n.adminUnderReviewReportsHelper,
      ),
      AdminKpiCard(
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.success,
        label: l10n.adminReportAccepted,
        value: valueFor(ReportStatus.accepted),
        helper: l10n.adminAcceptedReportsHelper,
      ),
      AdminKpiCard(
        icon: Icons.cancel_outlined,
        iconColor: AppColors.error,
        label: l10n.adminReportRejected,
        value: valueFor(ReportStatus.rejected),
        helper: l10n.adminRejectedReportsHelper,
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

class _BulkBar extends StatelessWidget {
  const _BulkBar({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

  Future<void> _bulkUpdate(BuildContext context, ReportStatus status) async {
    final l10n = AppLocalizations.of(context);
    final total = state.selectedIds.length;
    final messenger = ScaffoldMessenger.of(context);
    final failed = await vm.bulkUpdateStatus(status);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          failed == 0
              ? l10n.adminBulkSuccess(total)
              : l10n.adminBulkFailure(total, failed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = state.selectedIds.isNotEmpty && !state.isUpdating;
    return AdminBulkActionBar(
      selectedCount: state.selectedIds.length,
      actions: [
        AdminBulkActionButton(
          icon: Icons.check_circle_outline_rounded,
          label: l10n.adminAcceptReports,
          enabled: enabled,
          onPressed: () => _bulkUpdate(context, ReportStatus.accepted),
        ),
        AdminBulkActionButton(
          icon: Icons.cancel_outlined,
          label: l10n.adminRejectReports,
          enabled: enabled,
          onPressed: () => _bulkUpdate(context, ReportStatus.rejected),
        ),
        AdminBulkActionButton(
          icon: Icons.person_search_outlined,
          label: l10n.adminUnderReview,
          enabled: enabled,
          onPressed: () => _bulkUpdate(context, ReportStatus.underReview),
        ),
      ],
    );
  }
}

class _TableArea extends StatelessWidget {
  const _TableArea({required this.state, required this.vm});

  final AdminReportState state;
  final AdminReportViewModel vm;

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
      AdminTableColumn(label: l10n.adminReportId, flex: 3),
      AdminTableColumn(label: l10n.adminReviewId, flex: 3),
      AdminTableColumn(label: l10n.adminProductName, flex: 3),
      AdminTableColumn(label: l10n.adminReportReason, flex: 3),
      AdminTableColumn(label: l10n.adminReportContent, flex: 4),
      AdminTableColumn(label: l10n.adminEvidence, flex: 2),
      AdminTableColumn(label: l10n.adminStatus, flex: 2),
      AdminTableColumn(label: l10n.adminReportedAt, flex: 3),
    ];

    final rows = [
      for (final r in state.items)
        AdminTableRowData(
          id: r.reportId,
          cells: [
            _cell('RPT-${r.reportId}', strong: true),
            _cell(r.externalReviewId ?? (r.reviewId == null ? '—' : 'RWV-${r.reviewId}')),
            _cell(r.productName),
            _cell(r.reasonDescription.isEmpty ? r.reason : r.reasonDescription),
            _cell(r.detail),
            Align(
              alignment: Alignment.centerLeft,
              child: AdminStatusBadge(
                label: r.includeAiEvidence
                    ? l10n.adminIncluded
                    : l10n.adminNotIncluded,
                tone: r.includeAiEvidence
                    ? AdminBadgeTone.success
                    : AdminBadgeTone.neutral,
              ),
            ),
            r.status == null
                ? _cell('-')
                : Align(
                    alignment: Alignment.centerLeft,
                    child: AdminStatusBadge(
                      label: r.status!.localizedLabel(l10n),
                      tone: r.status!.tone,
                    ),
                  ),
            _cell(formatAdminDateTime(r.createdAt)),
          ],
        ),
    ];

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: columns,
        rows: rows,
        selectable: true,
        selectedIds: state.selectedIds.cast<Object>(),
        onRowSelected: (id, selected) => vm.toggleRow(id as int, selected),
        onSelectAll: vm.toggleAll,
        selectedId: state.selected?.reportId,
        onRowTap: (row) {
          final item = state.items.firstWhere((r) => r.reportId == row.id);
          vm.selectItem(item);
        },
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: l10n.adminReportsEmpty,
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

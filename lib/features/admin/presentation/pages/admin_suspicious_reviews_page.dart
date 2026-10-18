import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_suspicious_review_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_filter_field.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_kpi_card.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/suspicious_review_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/trust_grade_tone.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class AdminSuspiciousReviewsPage extends ConsumerWidget {
  const AdminSuspiciousReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminSuspiciousReviewViewModelProvider);
    final vm = ref.read(adminSuspiciousReviewViewModelProvider.notifier);

    return AdminPageScaffold(
      title: l10n.adminMenuSuspiciousReviews,
      subtitle: l10n.adminSuspiciousReviewsSubtitle,
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
                _KpiRow(total: state.totalElements, isLoading: state.isLoading),
                const SizedBox(height: AppSpacing.lg),
                Expanded(child: _TableArea(state: state, vm: vm)),
              ],
            ),
          ),
          if (state.selected != null) ...[
            const SizedBox(width: AppSpacing.lg),
            SuspiciousReviewDetailPanel(
              review: state.selected!,
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

  final AdminSuspiciousReviewState state;
  final AdminSuspiciousReviewViewModel vm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        AdminDropdownField<int>(
          label: l10n.adminRtiUpperBound,
          value: state.maxRti,
          width: 180,
          items: [
            AdminDropdownItem(value: 50, label: l10n.adminScoreBelow(50)),
            AdminDropdownItem(value: 70, label: l10n.adminScoreBelow(70)),
            AdminDropdownItem(value: 85, label: l10n.adminScoreBelow(85)),
            AdminDropdownItem(value: 100, label: l10n.adminAll),
          ],
          onChanged: (v) => vm.setMaxRti(v ?? 50),
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.total, required this.isLoading});

  final int total;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        SizedBox(
          width: 260,
          child: AdminKpiCard(
            icon: Icons.flag_outlined,
            iconColor: AppColors.warning,
            label: l10n.adminTotalSuspiciousReviews,
            value: isLoading ? '-' : formatAdminCount(total),
            helper: l10n.adminCurrentFilter,
          ),
        ),
      ],
    );
  }
}

class _TableArea extends StatelessWidget {
  const _TableArea({required this.state, required this.vm});

  final AdminSuspiciousReviewState state;
  final AdminSuspiciousReviewViewModel vm;

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
      AdminTableColumn(label: l10n.adminRtiScore, flex: 2),
      AdminTableColumn(label: l10n.adminTrustGrade, flex: 2),
      AdminTableColumn(label: l10n.adminReviewContent, flex: 5),
      AdminTableColumn(label: l10n.adminProductName, flex: 3),
      AdminTableColumn(label: l10n.adminRating, flex: 2),
      AdminTableColumn(label: l10n.adminVerifiedPurchase, flex: 2),
      AdminTableColumn(label: l10n.adminWrittenAt, flex: 3),
    ];

    final rows = [
      for (final r in state.items)
        AdminTableRowData(
          id: r.reviewId,
          cells: [
            _cell(r.rtiScore.toStringAsFixed(0), strong: true),
            r.trustGrade == null
                ? _cell('-')
                : Align(
                    alignment: Alignment.centerLeft,
                    child: AdminStatusBadge(
                      label: r.trustGrade!.localizedLabel(l10n),
                      tone: r.trustGrade!.tone,
                    ),
                  ),
            _cell(r.content),
            _cell(r.productName),
            _cell('★ ${r.rating}'),
            Align(
              alignment: Alignment.centerLeft,
              child: AdminStatusBadge(
                label: r.isVerifiedPurchase
                    ? l10n.adminVerified
                    : l10n.adminNotVerified,
                tone: r.isVerifiedPurchase
                    ? AdminBadgeTone.success
                    : AdminBadgeTone.neutral,
              ),
            ),
            _cell(formatAdminDate(r.writtenAt)),
          ],
        ),
    ];

    return SingleChildScrollView(
      child: AdminDataTable(
        columns: columns,
        rows: rows,
        selectedId: state.selected?.reviewId,
        onRowTap: (row) {
          final item = state.items.firstWhere((r) => r.reviewId == row.id);
          vm.selectItem(item);
        },
        totalPages: state.totalPages,
        currentPage: state.page,
        onPageChanged: vm.changePage,
        emptyMessage: l10n.adminSuspiciousReviewsEmpty,
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

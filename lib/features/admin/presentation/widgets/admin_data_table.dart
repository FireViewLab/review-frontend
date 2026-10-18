import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class AdminTableColumn {
  const AdminTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
    this.sortKey,
  });

  final String label;
  final int flex;
  final Alignment alignment;

  /// 정렬 키. null이 아니면 헤더가 정렬 가능 컬럼으로 동작한다.
  final String? sortKey;
}

class AdminTableRowData {
  const AdminTableRowData({required this.id, required this.cells});

  final Object id;
  final List<Widget> cells;
}

const double _checkboxColumnWidth = 44;

class AdminDataTable extends StatelessWidget {
  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.selectedId,
    this.onRowTap,
    this.totalPages,
    this.currentPage,
    this.onPageChanged,
    this.emptyMessage,
    this.selectable = false,
    this.selectedIds,
    this.onRowSelected,
    this.onSelectAll,
    this.sortKey,
    this.sortAscending = true,
    this.onSort,
  });

  final List<AdminTableColumn> columns;
  final List<AdminTableRowData> rows;
  final Object? selectedId;
  final ValueChanged<AdminTableRowData>? onRowTap;
  final int? totalPages;
  final int? currentPage;
  final ValueChanged<int>? onPageChanged;
  final String? emptyMessage;

  /// 다중 선택용 체크박스 컬럼 노출 여부.
  final bool selectable;
  final Set<Object>? selectedIds;
  final void Function(Object id, bool selected)? onRowSelected;
  final ValueChanged<bool>? onSelectAll;

  /// 현재 활성 정렬 컬럼 키 / 방향 / 변경 콜백.
  final String? sortKey;
  final bool sortAscending;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    final selected = selectedIds ?? const {};
    final allSelected = rows.isNotEmpty && rows.every((r) => selected.contains(r.id));
    final someSelected = rows.any((r) => selected.contains(r.id));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            columns: columns,
            selectable: selectable,
            allSelected: allSelected,
            someSelected: someSelected,
            onSelectAll: onSelectAll,
            sortKey: sortKey,
            sortAscending: sortAscending,
            onSort: onSort,
          ),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Text(
                  emptyMessage ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...rows.map(
              (row) => _Row(
                columns: columns,
                row: row,
                isSelected: selectedId != null && selectedId == row.id,
                isChecked: selected.contains(row.id),
                selectable: selectable,
                onCheckChanged: onRowSelected == null
                    ? null
                    : (value) => onRowSelected!(row.id, value),
                onTap: onRowTap == null ? null : () => onRowTap!(row),
              ),
            ),
          if (totalPages != null && currentPage != null)
            _Pagination(
              total: totalPages!,
              current: currentPage!,
              onChanged: onPageChanged,
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.columns,
    required this.selectable,
    required this.allSelected,
    required this.someSelected,
    required this.onSelectAll,
    required this.sortKey,
    required this.sortAscending,
    required this.onSort,
  });

  final List<AdminTableColumn> columns;
  final bool selectable;
  final bool allSelected;
  final bool someSelected;
  final ValueChanged<bool>? onSelectAll;
  final String? sortKey;
  final bool sortAscending;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (selectable)
            SizedBox(
              width: _checkboxColumnWidth,
              child: Checkbox(
                value: allSelected ? true : (someSelected ? null : false),
                tristate: true,
                onChanged: onSelectAll == null
                    ? null
                    : (value) => onSelectAll!(value ?? false),
              ),
            ),
          for (final col in columns)
            Expanded(
              flex: col.flex,
              child: _HeaderCell(
                column: col,
                isActive: col.sortKey != null && col.sortKey == sortKey,
                ascending: sortAscending,
                onSort: onSort,
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.isActive,
    required this.ascending,
    required this.onSort,
  });

  final AdminTableColumn column;
  final bool isActive;
  final bool ascending;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      column.label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isActive ? AppColors.primary : AppColors.textSecondary,
      ),
    );

    final sortable = column.sortKey != null && onSort != null;
    final content = sortable
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              text,
              const SizedBox(width: 2),
              Icon(
                isActive
                    ? (ascending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded)
                    : Icons.unfold_more_rounded,
                size: 13,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ],
          )
        : text;

    return Align(
      alignment: column.alignment,
      child: sortable
          ? InkWell(
              onTap: () => onSort!(column.sortKey!),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: content,
              ),
            )
          : content,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.columns,
    required this.row,
    required this.isSelected,
    required this.isChecked,
    required this.selectable,
    required this.onCheckChanged,
    required this.onTap,
  });

  final List<AdminTableColumn> columns;
  final AdminTableRowData row;
  final bool isSelected;
  final bool isChecked;
  final bool selectable;
  final ValueChanged<bool>? onCheckChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryLight : AppColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              if (selectable)
                SizedBox(
                  width: _checkboxColumnWidth,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: onCheckChanged == null
                        ? null
                        : (value) => onCheckChanged!(value ?? false),
                  ),
                ),
              for (var i = 0; i < columns.length; i++)
                Expanded(
                  flex: columns[i].flex,
                  child: Align(
                    alignment: columns[i].alignment,
                    child: i < row.cells.length
                        ? row.cells[i]
                        : const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.total,
    required this.current,
    required this.onChanged,
  });

  final int total;
  final int current;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (total <= 1) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PageArrow(
            icon: Icons.chevron_left_rounded,
            enabled: current > 0,
            onTap: () => onChanged?.call(current - 1),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${current + 1} / $total',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PageArrow(
            icon: Icons.chevron_right_rounded,
            enabled: current < total - 1,
            onTap: () => onChanged?.call(current + 1),
          ),
        ],
      ),
    );
  }
}

class _PageArrow extends StatelessWidget {
  const _PageArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
        ),
      ),
    );
  }
}

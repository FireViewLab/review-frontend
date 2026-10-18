import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 테이블 위에 놓이는 일괄 처리 툴바.
///
/// 선택 개수를 표시하고, 우측(또는 옆)에 일괄 액션 버튼들([actions])을 배치한다.
class AdminBulkActionBar extends StatelessWidget {
  const AdminBulkActionBar({
    super.key,
    required this.selectedCount,
    required this.actions,
  });

  final int selectedCount;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasSelection = selectedCount > 0;
    return Row(
      children: [
        Text(
          l10n.adminSelectedCount(selectedCount),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: hasSelection ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: actions,
          ),
        ),
      ],
    );
  }
}

/// 일괄 액션용 아웃라인 버튼(아이콘 + 라벨). [enabled]가 false면 비활성.
class AdminBulkActionButton extends StatelessWidget {
  const AdminBulkActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.textPrimary : AppColors.textTertiary;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

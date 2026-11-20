import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class CartListHeader extends StatelessWidget {
  const CartListHeader({
    super.key,
    required this.totalCount,
    required this.selectedCount,
    required this.isAllSelected,
    required this.onToggleSelectAll,
    required this.onDeleteSelected,
  });

  final int totalCount;
  final int selectedCount;
  final bool isAllSelected;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: AppSpacing.xs,
        children: [
          GestureDetector(
            onTap: onToggleSelectAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isAllSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isAllSelected
                            ? AppColors.primary
                            : AppColors.borderStrong,
                        width: 1.5,
                      ),
                    ),
                    child: isAllSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColors.onPrimary,
                            size: 13,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '전체 선택 ($selectedCount/$totalCount)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _HeaderButton(
            label: '선택 삭제',
            onTap: selectedCount > 0 ? onDeleteSelected : null,
          ),
          const SizedBox(width: AppSpacing.xs),
          _HeaderButton(
            label: '찜한 상품으로 이동',
            onTap: () => context.go(RoutePaths.wishlist),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: onTap == null
              ? AppColors.textTertiary
              : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          decorationColor: onTap == null
              ? AppColors.textTertiary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class Pagination extends StatelessWidget {
  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 2).clamp(1, totalPages);
    final end = (currentPage + 2).clamp(1, totalPages);
    final pages = [
      if (start > 1) 1,
      for (var page = start; page <= end; page++) page,
      if (end < totalPages) totalPages,
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: AppSpacing.xxs,
      children: [
        PageButton(
          icon: Icons.chevron_left,
          selected: false,
          enabled: currentPage > 1,
          onPressed: () => onPageSelected(currentPage - 1),
        ),
        for (var index = 0; index < pages.length; index++) ...[
          if (index > 0 && pages[index] - pages[index - 1] > 1) const Text('…'),
          PageButton(
            label: '${pages[index]}',
            selected: pages[index] == currentPage,
            enabled: true,
            onPressed: () => onPageSelected(pages[index]),
          ),
        ],
        PageButton(
          icon: Icons.chevron_right,
          selected: false,
          enabled: currentPage < totalPages,
          onPressed: () => onPageSelected(currentPage + 1),
        ),
      ],
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({
    super.key,
    this.label,
    this.icon,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: SizedBox.square(
        dimension: 40,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: selected ? AppColors.primary : AppColors.surface,
            foregroundColor: selected
                ? AppColors.onPrimary
                : AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
          ),
          child: icon == null ? Text(label!) : Icon(icon, size: 18),
        ),
      ),
    );
  }
}

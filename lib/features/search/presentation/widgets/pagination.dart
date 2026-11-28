import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

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
    if (totalPages < 2) return const SizedBox.shrink();
    final activePage = currentPage.clamp(1, totalPages);
    final l10n = AppLocalizations.of(context);
    final previous = _PageButton(
      onPressed: activePage > 1 ? () => onPageSelected(activePage - 1) : null,
      child: const Icon(Icons.chevron_left, size: 18),
    );
    final next = _PageButton(
      onPressed: activePage < totalPages
          ? () => onPageSelected(activePage + 1)
          : null,
      child: const Icon(Icons.chevron_right, size: 18),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              previous,
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  l10n.searchPaginationPosition(activePage, totalPages),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              next,
            ],
          );
        }

        final pageNumber = NumberFormat.decimalPattern(l10n.localeName);
        final start = (activePage - 2).clamp(1, totalPages);
        final end = (activePage + 2).clamp(1, totalPages);
        final pages = [
          if (start > 1) 1,
          for (var page = start; page <= end; page++) page,
          if (end < totalPages) totalPages,
        ];

        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xxs,
          runSpacing: AppSpacing.xxs,
          children: [
            previous,
            for (var i = 0; i < pages.length; i++) ...[
              if (i > 0 && pages[i] - pages[i - 1] > 1) const Text('…'),
              _PageButton(
                key: ValueKey(pages[i]),
                selected: pages[i] == activePage,
                onPressed: () => onPageSelected(pages[i]),
                child: Text(pageNumber.format(pages[i])),
              ),
            ],
            next,
          ],
        );
      },
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.selected = false,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.square(48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        backgroundColor: selected ? AppColors.primary : AppColors.surface,
        foregroundColor: selected ? AppColors.onPrimary : AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
      ),
      child: child,
    );
  }
}

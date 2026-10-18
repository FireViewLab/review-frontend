import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class SelectBox extends StatelessWidget {
  const SelectBox({
    super.key,
    required this.label,
    required this.selectedBrand,
    required this.brands,
    required this.onSelected,
  });

  final String label;
  final String? selectedBrand;
  final List<String> brands;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: AppLocalizations.of(context).searchFilterSelectSeller,
      initialValue: selectedBrand ?? '',
      onSelected: (value) => onSelected(value.isEmpty ? null : value),
      color: AppColors.surface,
      elevation: 10,
      constraints: const BoxConstraints(minWidth: 210, maxWidth: 230),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: '',
          height: 36,
          child: SelectMenuItemLabel(
            label: AppLocalizations.of(context).searchFilterAllSellers,
            selected: selectedBrand == null,
          ),
        ),
        for (final brand in brands)
          PopupMenuItem<String>(
            value: brand,
            height: 36,
            child: SelectMenuItemLabel(
              label: brand,
              selected: selectedBrand == brand,
            ),
          ),
      ],
      child: SelectControl(label: label, selected: selectedBrand != null),
    );
  }
}

class SelectControl extends StatelessWidget {
  const SelectControl({super.key, required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFF),
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class SelectMenuItemLabel extends StatelessWidget {
  const SelectMenuItemLabel({
    super.key,
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        if (selected)
          const Icon(Icons.check, size: 15, color: AppColors.primary),
      ],
    );
  }
}

import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_section_widgets.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_price_widgets.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_select_widgets.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    this.onShowResults,
    required this.state,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    required this.selectedReviewConditions,
    required this.selectedAttributeFilters,
    required this.selectedBrand,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.resultCount,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onAttributeToggled,
    required this.onBrandSelected,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onResetFilters,
    this.compact = false,
  });

  final SearchResultsState state;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final Set<String> selectedAttributeFilters;
  final String? selectedBrand;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final int resultCount;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final ValueChanged<String> onAttributeToggled;
  final ValueChanged<String?> onBrandSelected;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final VoidCallback onResetFilters;
  final bool compact;
  final VoidCallback? onShowResults;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: const Color(0x080F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).searchFilterTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onResetFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(AppLocalizations.of(context).searchFilterReset),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: AppLocalizations.of(context).searchFilterCategory,
              children: [
                for (final item in state.categoryFilters)
                  CheckboxRow(
                    label: item.label,
                    trailing: '${item.count}',
                    selected: selectedCategories.contains(item.label),
                    onChanged: () => onCategoryToggled(item.label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: AppLocalizations.of(context).searchFilterPriceRange,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RangeEndpoint(
                      label: minPriceController.text.isNotEmpty
                          ? AppLocalizations.of(
                              context,
                            ).searchFilterPriceAmount(minPriceController.text)
                          : '-',
                    ),
                    RangeEndpoint(
                      label: maxPriceController.text.isNotEmpty
                          ? AppLocalizations.of(
                              context,
                            ).searchFilterPriceAmount(maxPriceController.text)
                          : '-',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                PriceRangeSlider(
                  products: state.sourceProducts,
                  minPriceController: minPriceController,
                  maxPriceController: maxPriceController,
                  onChanged: onPriceChanged,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: PriceBox(
                        controller: minPriceController,
                        onChanged: onPriceChanged,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: Text('~'),
                    ),
                    Expanded(
                      child: PriceBox(
                        controller: maxPriceController,
                        onChanged: onPriceChanged,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(AppLocalizations.of(context).searchFilterWon),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final item in state.priceRanges)
                      PriceRangeChip(
                        label: _localizedFilterLabel(context, item.label),
                        selected: selectedPriceRanges.contains(item.label),
                        onPressed: () => onPriceRangeToggled(item.label),
                      ),
                  ],
                ),
              ],
            ),

            const Divider(height: AppSpacing.lg),
            ExpandableFilterSection(
              title: AppLocalizations.of(context).searchFilterSeller,
              children: [
                SelectBox(
                  label:
                      selectedBrand ??
                      AppLocalizations.of(context).searchFilterSellerHint,
                  selectedBrand: selectedBrand,
                  brands: state.sourceProducts
                      .map(
                        (p) => normalizeSearchPlatform(
                          p.platform ??
                              p.dataPlatform ??
                              p.externalRef?.platform,
                        ),
                      )
                      .whereType<String>()
                      .toSet()
                      .toList(),
                  onSelected: onBrandSelected,
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: AppLocalizations.of(context).searchFilterRtiScore,
              trailing: state.isRtiFilterActive
                  ? AppLocalizations.of(
                      context,
                    ).searchFilterMinimumScore(selectedRtiMinimum.round())
                  : AppLocalizations.of(context).searchFilterAllRti,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RangeEndpoint(
                      label: AppLocalizations.of(
                        context,
                      ).searchFilterZeroPoints,
                    ),
                    RangeEndpoint(
                      label: AppLocalizations.of(
                        context,
                      ).searchFilterHundredPoints,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbColor: AppColors.surface,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    overlayColor: AppColors.primary.withValues(alpha: 0.12),
                    thumbShape: const OutlinedRoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      borderWidth: 2,
                      borderColor: AppColors.primary,
                    ),
                  ),
                  child: Slider(
                    value: selectedRtiMinimum,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: onRtiMinimumChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ScaleLabel(label: '0'),
                    ScaleLabel(label: '50'),
                    ScaleLabel(label: '75'),
                    ScaleLabel(label: '100'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    PriceRangeChip(
                      label: AppLocalizations.of(
                        context,
                      ).searchFilterEightyMinimum,
                      selected:
                          state.isRtiFilterActive &&
                          selectedRtiMinimum.round() == 80,
                      onPressed: () => onRtiMinimumChanged(80),
                    ),
                    PriceRangeChip(
                      label: AppLocalizations.of(
                        context,
                      ).searchFilterNinetyMinimum,
                      selected:
                          state.isRtiFilterActive &&
                          selectedRtiMinimum.round() == 90,
                      onPressed: () => onRtiMinimumChanged(90),
                    ),
                    PriceRangeChip(
                      label: AppLocalizations.of(
                        context,
                      ).searchFilterNinetyFiveMinimum,
                      selected:
                          state.isRtiFilterActive &&
                          selectedRtiMinimum.round() == 95,
                      onPressed: () => onRtiMinimumChanged(95),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: AppLocalizations.of(context).searchFilterInfoStatus,
              children: [
                for (final label in const ['분석 전만', '가격 정보 없음만'])
                  CheckboxRow(
                    label: _localizedFilterLabel(context, label),
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: AppLocalizations.of(context).searchFilterReviewConditions,
              children: [
                for (final label in const ['리뷰 50개 이상'])
                  CheckboxRow(
                    label: _localizedFilterLabel(context, label),
                    selected: selectedReviewConditions.contains(label),
                    onChanged: () => onReviewConditionToggled(label),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onShowResults,
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).searchFilterShowResults(resultCount),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _localizedFilterLabel(BuildContext context, String label) {
  final l10n = AppLocalizations.of(context);
  return switch (label) {
    '분석 전만' => l10n.searchFilterUnanalyzedOnly,
    '가격 정보 없음만' => l10n.searchFilterMissingPriceOnly,
    '리뷰 50개 이상' => l10n.searchFilterMinimumReviews,
    '1만원 이하' => l10n.searchFilterUnderTenThousand,
    '10~30만원' => l10n.searchFilterTenToThirtyThousand,
    '30만원 이상' => l10n.searchFilterAboveThreeHundredThousand,
    _ => label,
  };
}

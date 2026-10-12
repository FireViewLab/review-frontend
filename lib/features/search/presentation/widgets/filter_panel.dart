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
                  '필터',
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
                  child: const Text('초기화'),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: '카테고리',
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
              title: '가격대',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RangeEndpoint(
                      label: minPriceController.text.isNotEmpty
                          ? '${minPriceController.text}원'
                          : '-',
                    ),
                    RangeEndpoint(
                      label: maxPriceController.text.isNotEmpty
                          ? '${maxPriceController.text}원'
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
                    const Text('원'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final item in state.priceRanges)
                      PriceRangeChip(
                        label: item.label,
                        selected: selectedPriceRanges.contains(item.label),
                        onPressed: () => onPriceRangeToggled(item.label),
                      ),
                  ],
                ),
              ],
            ),

            const Divider(height: AppSpacing.lg),
            ExpandableFilterSection(
              title: '판매처',
              children: [
                SelectBox(
                  label: selectedBrand ?? '판매처를 선택하세요',
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
              title: 'RTI 신뢰 점수',
              trailing: state.isRtiFilterActive
                  ? '${selectedRtiMinimum.round()}점 이상'
                  : '전체 (분석 전 포함)',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    RangeEndpoint(label: '0점'),
                    RangeEndpoint(label: '100점'),
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
                      label: '80점 이상',
                      selected:
                          state.isRtiFilterActive &&
                          selectedRtiMinimum.round() == 80,
                      onPressed: () => onRtiMinimumChanged(80),
                    ),
                    PriceRangeChip(
                      label: '90점 이상',
                      selected:
                          state.isRtiFilterActive &&
                          selectedRtiMinimum.round() == 90,
                      onPressed: () => onRtiMinimumChanged(90),
                    ),
                    PriceRangeChip(
                      label: '95점 이상',
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
              title: '정보 상태',
              children: [
                for (final label in const ['분석 전만', '가격 정보 없음만'])
                  CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: '리뷰 조건',
              children: [
                for (final label in const ['리뷰 50개 이상'])
                  CheckboxRow(
                    label: label,
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
                child: Text('$resultCount개 결과 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

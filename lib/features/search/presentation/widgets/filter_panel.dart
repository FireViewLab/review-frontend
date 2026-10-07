import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

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
                  products: state.products,
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
              title: '브랜드',
              children: [
                SelectBox(
                  label: selectedBrand ?? '브랜드를 선택하세요',
                  selectedBrand: selectedBrand,
                  brands: state.products
                      .map((p) => p.platform)
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
              trailing: '${selectedRtiMinimum.round()}점 이상',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    RangeEndpoint(label: '0%'),
                    RangeEndpoint(label: '100%'),
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
                      label: '80% 이상',
                      selected: selectedRtiMinimum.round() == 80,
                      onPressed: () => onRtiMinimumChanged(80),
                    ),
                    PriceRangeChip(
                      label: '90% 이상',
                      selected: selectedRtiMinimum.round() == 90,
                      onPressed: () => onRtiMinimumChanged(90),
                    ),
                    PriceRangeChip(
                      label: '95% 이상',
                      selected: selectedRtiMinimum.round() == 95,
                      onPressed: () => onRtiMinimumChanged(95),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: '배송',
              children: [
                for (final label in const ['로켓배송/오늘출발', '무료배송', '정기배송 가능'])
                  CheckboxRow(
                    label: label,
                    selected: selectedAttributeFilters.contains(label),
                    onChanged: () => onAttributeToggled(label),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            FilterSection(
              title: '판매처 유형',
              children: [
                for (final label in const ['공식몰', '스토어'])
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
                for (final label in const [
                  '리뷰 50개 이상',
                  '사진 포함',
                  '최근 30일 리뷰 포함',
                ])
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

class FilterSection extends StatelessWidget {
  const FilterSection({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...children,
      ],
    );
  }
}

class ExpandableFilterSection extends StatelessWidget {
  const ExpandableFilterSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: AppSpacing.xs),
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
        iconColor: AppColors.textPrimary,
        collapsedIconColor: AppColors.textPrimary,
        children: children,
      ),
    );
  }
}

class CheckboxRow extends StatelessWidget {
  const CheckboxRow({
    super.key,
    required this.label,
    required this.onChanged,
    this.trailing,
    this.selected = false,
  });

  final String label;
  final VoidCallback onChanged;
  final String? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      borderRadius: AppRadius.small,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            FilterCheckboxMark(selected: selected),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FilterCheckboxMark extends StatelessWidget {
  const FilterCheckboxMark({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderStrong,
          width: 1.4,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 10, color: AppColors.onPrimary)
          : null,
    );
  }
}

class PriceBox extends StatelessWidget {
  const PriceBox({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) => onChanged(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.borderStrong),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.borderStrong),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class PriceRangeChip extends StatelessWidget {
  const PriceRangeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: AppRadius.small,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.small,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.small,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderStrong,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class RangeEndpoint extends StatelessWidget {
  const RangeEndpoint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 11,
      ),
    );
  }
}

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({
    super.key,
    required this.products,
    required this.minPriceController,
    required this.maxPriceController,
    required this.onChanged,
  });

  final List<SearchResultProduct> products;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final dataBounds = _priceBounds(products);
    final chartBounds = (0, dataBounds.$2);
    final minBound = chartBounds.$1.toDouble();
    final maxBound = chartBounds.$2.toDouble();
    final bins = _priceBins(products, chartBounds);
    final maxBin = bins.reduce((value, element) {
      return value > element ? value : element;
    });
    final currentMin =
        _parseControllerPrice(minPriceController.text) ?? dataBounds.$1;
    final currentMax =
        _parseControllerPrice(maxPriceController.text) ?? dataBounds.$2;
    final start = currentMin.clamp(chartBounds.$1, chartBounds.$2).toDouble();
    final end = currentMax.clamp(chartBounds.$1, chartBounds.$2).toDouble();
    final values = RangeValues(
      start <= end ? start : end,
      end >= start ? end : start,
    );

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 8,
            right: 8,
            bottom: 24,
            child: KeyedSubtree(
              key: const ValueKey('price-histogram-bars'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var index = 0; index < bins.length; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: PriceHistogramBar(
                          height: _barHeight(bins[index], maxBin),
                          active: _binOverlapsSelection(
                            index,
                            bins.length,
                            chartBounds,
                            values,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 22,
            child: Row(
              children: [
                for (var index = 0; index < bins.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color:
                              _binOverlapsSelection(
                                index,
                                bins.length,
                                chartBounds,
                                values,
                              )
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned.fill(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 0,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: AppColors.surface,
                overlayColor: AppColors.primary.withValues(alpha: 0.12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 8,
                  elevation: 0,
                  pressedElevation: 0,
                ),
              ),
              child: RangeSlider(
                values: values,
                min: minBound,
                max: maxBound <= minBound ? minBound + 1 : maxBound,
                onChanged: (next) {
                  minPriceController.text = next.start
                      .round()
                      .clamp(chartBounds.$1, chartBounds.$2)
                      .toString();
                  maxPriceController.text = next.end
                      .round()
                      .clamp(chartBounds.$1, chartBounds.$2)
                      .toString();
                  onChanged();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> _priceBins(List<SearchResultProduct> products, (int, int) bounds) {
    const binCount = 18;
    final bins = List<int>.filled(binCount, 0);
    if (products.isEmpty) {
      return bins;
    }

    final span = (bounds.$2 - bounds.$1).clamp(1, 1 << 31);
    for (final product in products) {
      final normalized = (product.price - bounds.$1) / span;
      final rawIndex = (normalized * (binCount - 1)).round();
      final index = rawIndex.clamp(0, binCount - 1);
      bins[index]++;
    }
    return bins;
  }

  double _barHeight(int count, int maxCount) {
    if (maxCount <= 0) {
      return 6;
    }
    return 5 + 18 * count / maxCount;
  }

  bool _binOverlapsSelection(
    int index,
    int binCount,
    (int, int) bounds,
    RangeValues values,
  ) {
    final span = bounds.$2 - bounds.$1;
    final binStart = bounds.$1 + span * index / binCount;
    final binEnd = bounds.$1 + span * (index + 1) / binCount;
    return binEnd >= values.start && binStart <= values.end;
  }

  (int, int) _priceBounds(List<SearchResultProduct> products) {
    if (products.isEmpty) {
      return (0, 700000);
    }

    final prices = products.map((product) => product.price);
    final minPrice = prices.reduce((value, element) {
      return value < element ? value : element;
    });
    final maxPrice = prices.reduce((value, element) {
      return value > element ? value : element;
    });

    return (minPrice, maxPrice == minPrice ? minPrice + 1 : maxPrice);
  }

  int? _parseControllerPrice(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return int.tryParse(normalized);
  }
}

class PriceHistogramBar extends StatelessWidget {
  const PriceHistogramBar({
    super.key,
    required this.height,
    required this.active,
  });

  final double height;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.5)
              : const Color(0xFFE8EEF8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
    );
  }
}

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
    return PopupMenuButton<String?>(
      tooltip: '브랜드 선택',
      initialValue: selectedBrand,
      onSelected: onSelected,
      color: AppColors.surface,
      elevation: 10,
      constraints: const BoxConstraints(minWidth: 210, maxWidth: 230),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String?>(
          value: null,
          height: 36,
          child: SelectMenuItemLabel(
            label: '전체 브랜드',
            selected: selectedBrand == null,
          ),
        ),
        for (final brand in brands)
          PopupMenuItem<String?>(
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

class ScaleLabel extends StatelessWidget {
  const ScaleLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class OutlinedRoundSliderThumbShape extends SliderComponentShape {
  const OutlinedRoundSliderThumbShape({
    required this.enabledThumbRadius,
    required this.borderWidth,
    required this.borderColor,
  });

  final double enabledThumbRadius;
  final double borderWidth;
  final Color borderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      enabledThumbRadius,
      Paint()..color = sliderTheme.thumbColor ?? AppColors.surface,
    );
    canvas.drawCircle(
      center,
      enabledThumbRadius - borderWidth / 2,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }
}

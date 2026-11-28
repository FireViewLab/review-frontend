import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

class PriceBox extends StatefulWidget {
  const PriceBox({
    super.key,
    required this.controller,
    required this.onChanged,
    this.keepVisibleOnFocus = false,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool keepVisibleOnFocus;

  @override
  State<PriceBox> createState() => _PriceBoxState();
}

class _PriceBoxState extends State<PriceBox> {
  late final _focusNode = FocusNode()..addListener(_scheduleReveal);
  double _keyboardInset = 0;
  bool _revealScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.keepVisibleOnFocus) return;

    final inset = MediaQuery.viewInsetsOf(context).bottom;
    if (inset > _keyboardInset) _scheduleReveal();
    _keyboardInset = inset;
  }

  void _scheduleReveal() {
    if (!widget.keepVisibleOnFocus ||
        !_focusNode.hasFocus ||
        _revealScheduled) {
      return;
    }
    _revealScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealScheduled = false;
      if (!mounted || !_focusNode.hasFocus) return;
      Scrollable.ensureVisible(
        context,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        // 음수·소수·문자가 들어가면 필터와 슬라이더 값이 어긋나므로 숫자만 받는다.
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        onChanged: (_) => widget.onChanged(),
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
  const RangeEndpoint({super.key, required this.label, this.textAlign});

  final String label;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 11,
      ),
    );
  }
}

class PriceRangeSlider extends StatefulWidget {
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

  /// 손을 뗐을 때와 입력칸을 바꿨을 때만 불린다. 끄는 동안은 슬라이더와
  /// 입력칸만 움직이고 결과 계산은 하지 않는다.
  final VoidCallback onChanged;

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  // 가격 분포는 상품 목록이 바뀔 때만 다시 계산한다.
  late (int, int) _dataBounds;
  late List<int> _bins;
  late int _maxBin;

  /// 끄는 중인 값. 끄지 않을 때는 입력칸 값을 따른다.
  RangeValues? _dragValues;

  (int, int) get _chartBounds => (0, _dataBounds.$2);

  @override
  void initState() {
    super.initState();
    _computeDistribution();
    widget.minPriceController.addListener(_handleControllerChanged);
    widget.maxPriceController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(PriceRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.products, widget.products)) {
      _computeDistribution();
    }
    if (oldWidget.minPriceController != widget.minPriceController) {
      oldWidget.minPriceController.removeListener(_handleControllerChanged);
      widget.minPriceController.addListener(_handleControllerChanged);
    }
    if (oldWidget.maxPriceController != widget.maxPriceController) {
      oldWidget.maxPriceController.removeListener(_handleControllerChanged);
      widget.maxPriceController.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.minPriceController.removeListener(_handleControllerChanged);
    widget.maxPriceController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    // 입력칸을 직접 고치거나 초기화하면 슬라이더 위치도 따라간다.
    if (_dragValues == null && mounted) setState(() {});
  }

  void _computeDistribution() {
    _dataBounds = _priceBounds(widget.products);
    _bins = _priceBins(widget.products, _chartBounds);
    _maxBin = _bins.reduce((value, element) {
      return value > element ? value : element;
    });
  }

  RangeValues _controllerValues() {
    final chartBounds = _chartBounds;
    final currentMin =
        _parseControllerPrice(widget.minPriceController.text) ?? _dataBounds.$1;
    final currentMax =
        _parseControllerPrice(widget.maxPriceController.text) ?? _dataBounds.$2;
    final start = currentMin.clamp(chartBounds.$1, chartBounds.$2).toDouble();
    final end = currentMax.clamp(chartBounds.$1, chartBounds.$2).toDouble();
    return RangeValues(start <= end ? start : end, end >= start ? end : start);
  }

  void _writeControllers(RangeValues next) {
    final chartBounds = _chartBounds;
    widget.minPriceController.text = next.start
        .round()
        .clamp(chartBounds.$1, chartBounds.$2)
        .toString();
    widget.maxPriceController.text = next.end
        .round()
        .clamp(chartBounds.$1, chartBounds.$2)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final chartBounds = _chartBounds;
    final minBound = chartBounds.$1.toDouble();
    final maxBound = chartBounds.$2.toDouble();
    final bins = _bins;
    final maxBin = _maxBin;
    final values = _dragValues ?? _controllerValues();

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
                  setState(() => _dragValues = next);
                  _writeControllers(next);
                },
                onChangeEnd: (next) {
                  _writeControllers(next);
                  setState(() => _dragValues = null);
                  widget.onChanged();
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
      if (product.price == null) continue;
      final normalized = (product.price! - bounds.$1) / span;
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

    final prices = products
        .map((product) => product.price)
        .whereType<int>()
        .toList();
    if (prices.isEmpty) return (0, 1);
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

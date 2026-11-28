import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

const productCardImageAspectRatio = 4 / 3;

class ProductCardRow extends StatelessWidget {
  const ProductCardRow({
    super.key,
    required this.columns,
    required this.cards,
    this.spacing = AppSpacing.sm,
  });

  final int columns;
  final List<Widget> cards;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (columns == 1) return cards.single;

    // Only cards in this row share a height. Empty slots keep the final row's
    // cards the same width as the other rows.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < columns; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(
              key: i < cards.length ? cards[i].key : null,
              child: i < cards.length ? cards[i] : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

class ProductCardRows extends StatelessWidget {
  const ProductCardRows({
    super.key,
    required this.columns,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = AppSpacing.sm,
  });

  final int columns;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var start = 0; start < itemCount; start += columns)
          Padding(
            padding: EdgeInsets.only(top: start == 0 ? 0 : spacing),
            child: ProductCardRow(
              columns: columns,
              spacing: spacing,
              cards: [
                for (var i = start; i < start + columns && i < itemCount; i++)
                  itemBuilder(context, i),
              ],
            ),
          ),
      ],
    );
  }
}

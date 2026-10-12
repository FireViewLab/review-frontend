import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';

enum ProductDetailTab { review, priceComparison, info }

class ProductDetailTabBar extends StatelessWidget {
  const ProductDetailTabBar({
    super.key,
    required this.detail,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final ProductDetail detail;
  final ProductDetailTab selectedTab;
  final ValueChanged<ProductDetailTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        ProductDetailTab.review,
        detail.reviewCount == null
            ? '리뷰'
            : '리뷰 ${_formatTabCount(detail.reviewCount!)}',
      ),
      (ProductDetailTab.priceComparison, '가격비교 ${detail.totalSellerCount}'),
      (ProductDetailTab.info, '상품 정보'),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: tabs.map((entry) {
          final (tab, label) = entry;
          final isSelected = tab == selectedTab;
          return ProductDetailTabItem(
            label: label,
            isSelected: isSelected,
            onTap: () => onTabChanged(tab),
          );
        }).toList(),
      ),
    );
  }

  String _formatTabCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    }
    return count.toString();
  }
}

class ProductDetailTabItem extends StatelessWidget {
  const ProductDetailTabItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

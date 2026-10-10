// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_picks.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_benefits.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_assets.dart';

class HomeHeaderCategorySideNav extends StatelessWidget {
  const HomeHeaderCategorySideNav({
    required this.selectedCategory,
    required this.onAllPressed,
    required this.onCategoryPressed,
  });

  final ProductCategory? selectedCategory;
  final VoidCallback onAllPressed;
  final ValueChanged<ProductCategory> onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeaderCategorySideNavItem(
                label: '전체보기',
                isSelected: selectedCategory == null,
                onTap: onAllPressed,
              ),
              for (final category in productCategoryTree)
                HomeHeaderCategorySideNavItem(
                  label: category.label,
                  isSelected: selectedCategory?.id == category.id,
                  onTap: () => onCategoryPressed(category),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeaderCategorySideNavItem extends StatelessWidget {
  const HomeHeaderCategorySideNavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 28,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: AppColors.primary) : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class HomeHeaderAllCategoryOverview extends StatelessWidget {
  const HomeHeaderAllCategoryOverview({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = productCategoryTree.take(10).toList(growable: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모든 카테고리를 한눈에',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '리뷰 데이터 기반 인기 상품과 카테고리를 확인해보세요.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 155,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return HomeHeaderCategoryOverviewTile(
                      category: category,
                      onTap: () => onCategorySelected(category.label),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 3,
          child: HomeHeaderPopularCategoryAndPickPreview(
            products: products,
            onCategorySelected: onCategorySelected,
          ),
        ),
      ],
    );
  }
}

class HomeHeaderSelectedCategoryView extends StatelessWidget {
  const HomeHeaderSelectedCategoryView({
    required this.category,
    required this.onCategorySelected,
  });

  final ProductCategory category;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final columns = category.children.take(5).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in columns) ...[
                Expanded(
                  child: HomeHeaderMiddleCategoryColumn(
                    category: child,
                    onCategorySelected: onCategorySelected,
                  ),
                ),
                if (child != columns.last)
                  const VerticalDivider(width: 1, color: AppColors.border),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        HomeHeaderCategoryBenefitStrip(category: category),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => onCategorySelected(category.label),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            ),
            child: Text('${category.label} 전체보기  >'),
          ),
        ),
      ],
    );
  }
}

class HomeHeaderMiddleCategoryColumn extends StatelessWidget {
  const HomeHeaderMiddleCategoryColumn({
    required this.category,
    required this.onCategorySelected,
  });

  final ProductCategory category;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onCategorySelected(category.label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 96,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final item in category.children.take(6))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: HomeHeaderSubCategoryItem(
                        label: item.label,
                        onTap: () => onCategorySelected(item.label),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  child: HomeHeaderCategoryAssetImage(
                    assetPath: homeHeaderCategoryAssetPath(category.id),
                    height: 210,
                    scale: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeaderCategoryOverviewTile extends StatelessWidget {
  const HomeHeaderCategoryOverviewTile({
    required this.category,
    required this.onTap,
  });

  final ProductCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HomeHeaderCategoryAssetImage(
                    assetPath: homeHeaderCategoryAssetPath(category.id),
                    scale: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                category.children.take(2).map((item) => item.label).join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeaderSubCategoryItem extends StatefulWidget {
  const HomeHeaderSubCategoryItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<HomeHeaderSubCategoryItem> createState() =>
      HomeHeaderSubCategoryItemState();
}

class HomeHeaderSubCategoryItemState extends State<HomeHeaderSubCategoryItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _hovered ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            decoration: _hovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

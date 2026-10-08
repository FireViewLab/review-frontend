import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_panel.dart';
import 'package:re_view_front/features/search/presentation/widgets/pagination.dart';
import 'package:re_view_front/features/search/presentation/widgets/review_comparison_banner.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class ResultColumn extends StatelessWidget {
  const ResultColumn({
    super.key,
    required this.state,
    required this.products,
    required this.sortOption,
    required this.viewMode,
    required this.currentPage,
    required this.pageSize,
    required this.onSortChanged,
    required this.onPageSelected,
    required this.onPageSizeChanged,
    required this.onViewModeChanged,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final SearchSortOption sortOption;
  final SearchViewMode viewMode;
  final int currentPage;
  final int pageSize;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSelected;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<SearchViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ProductGrid.columnsForWidth(constraints.maxWidth);
        final totalPages = products.isEmpty
            ? 1
            : (products.length / pageSize).ceil();
        final activePage = currentPage < 1
            ? 1
            : currentPage > totalPages
            ? totalPages
            : currentPage;
        final pageStart = (activePage - 1) * pageSize;
        final pageEnd = pageStart + pageSize > products.length
            ? products.length
            : pageStart + pageSize;
        final pageProducts = products.sublist(pageStart, pageEnd);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (products.isNotEmpty && constraints.maxWidth >= 760) ...[
              ReviewComparisonBanner(products: products),
              const SizedBox(height: AppSpacing.md),
            ],
            ResultToolbar(
              resultCount: products.length,
              sortOption: sortOption,
              viewMode: viewMode,
              pageSize: pageSize,
              onSortChanged: onSortChanged,
              onPageSizeChanged: onPageSizeChanged,
              onViewModeChanged: onViewModeChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            if (products.isEmpty)
              const SizedBox(
                height: 360,
                child: AppEmptyView(
                  title: '필터에 맞는 상품이 없어요',
                  message: '필터를 초기화하거나 조건을 조금 넓혀보세요.',
                ),
              )
            else ...[
              if (viewMode == SearchViewMode.grid)
                ProductGrid(products: pageProducts, columns: columns)
              else
                ProductList(products: pageProducts),
              if (totalPages > 1) ...[
                const SizedBox(height: AppSpacing.lg),
                Pagination(
                  currentPage: activePage,
                  totalPages: totalPages,
                  onPageSelected: onPageSelected,
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key, required this.products, required this.columns});

  final List<SearchResultProduct> products;
  final int columns;

  static int columnsForWidth(double width) {
    return width >= 1500
        ? 5
        : width >= 1180
        ? 4
        : width >= 820
        ? 3
        : width >= 560
        ? 2
        : 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact =
        ref.watch(confirmedDisplayPreferencesProvider)?.cardDensity ==
        'COMPACT';
    final cardHeight = switch (columns) {
      1 => 520.0,
      2 => 490.0,
      3 => 465.0,
      4 => 445.0,
      _ => 425.0,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: compact ? cardHeight - 32 : cardHeight,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return RepaintBoundary(
          key: ValueKey('search-product-card-${product.id}'),
          child: SearchProductCard(product: product),
        );
      },
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.products});

  final List<SearchResultProduct> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('search-product-list'),
      children: [
        for (final product in products) ...[
          RepaintBoundary(
            key: ValueKey('search-product-list-tile-${product.id}'),
            child: SearchProductListTile(product: product),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class SearchProductGridSkeleton extends StatelessWidget {
  const SearchProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = ProductGrid.columnsForWidth(constraints.maxWidth);
          final cardHeight = switch (columns) {
            1 => 520.0,
            2 => 490.0,
            3 => 465.0,
            4 => 445.0,
            _ => 425.0,
          };
          final itemCount = columns * 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisExtent: cardHeight,
            ),
            itemBuilder: (context, _) => const _SearchCardSkeleton(),
          );
        },
      ),
    );
  }
}

class _SearchCardSkeleton extends StatelessWidget {
  const _SearchCardSkeleton();

  @override
  Widget build(BuildContext context) {
    // 카드 배경은 투명 → ShimmerBox(흰색)만 shimmer 적용돼 내부 구조가 보임
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 영역
            const Expanded(child: ShimmerBox()),
            // 텍스트 영역
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 56, height: 11, radius: 3),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 13, child: ShimmerBox(radius: 3)),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 110, height: 13, radius: 3),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 96, height: 12, radius: 3),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 68, height: 19, radius: 3),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: const [
                      ShimmerBox(width: 36, height: 36, radius: 6),
                      SizedBox(width: AppSpacing.xs),
                      ShimmerBox(width: 36, height: 36, radius: 6),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ShimmerBox(radius: 6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultToolbar extends StatelessWidget {
  const ResultToolbar({
    super.key,
    required this.resultCount,
    required this.sortOption,
    required this.viewMode,
    required this.pageSize,
    required this.onSortChanged,
    required this.onPageSizeChanged,
    required this.onViewModeChanged,
  });

  final int resultCount;
  final SearchSortOption sortOption;
  final SearchViewMode viewMode;
  final int pageSize;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<SearchViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      SearchSortOption.accuracy,
      SearchSortOption.priceLow,
      SearchSortOption.rti,
      SearchSortOption.reviewCount,
      SearchSortOption.priceHigh,
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SortSegmentedControl(
                options: options,
                selectedOption: sortOption,
                onChanged: onSortChanged,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$resultCount개 결과',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ViewModeButton(
                  icon: Icons.grid_view_rounded,
                  tooltip: '카드형 보기',
                  selected: viewMode == SearchViewMode.grid,
                  onPressed: () => onViewModeChanged(SearchViewMode.grid),
                ),
                ViewModeButton(
                  icon: Icons.view_list_rounded,
                  tooltip: '리스트형 보기',
                  selected: viewMode == SearchViewMode.list,
                  onPressed: () => onViewModeChanged(SearchViewMode.list),
                ),
                const SizedBox(width: AppSpacing.xs),
                PageSizeButton(
                  pageSize: pageSize,
                  onChanged: onPageSizeChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SortSegmentedControl extends StatelessWidget {
  const SortSegmentedControl({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  final List<SearchSortOption> options;
  final SearchSortOption selectedOption;
  final ValueChanged<SearchSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 36,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                '정렬',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in options)
                  SortSegment(
                    label: option.label,
                    selected: option == selectedOption,
                    onPressed: () => onChanged(option),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SortSegment extends StatelessWidget {
  const SortSegment({
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
    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: selected
              ? AppColors.primaryLight
              : Colors.transparent,
          foregroundColor: selected ? AppColors.primary : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          textStyle: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        child: Text(label, softWrap: false),
      ),
    );
  }
}

class ViewModeButton extends StatelessWidget {
  const ViewModeButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: 32,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: selected
                ? AppColors.primaryLight
                : AppColors.surface,
            foregroundColor: selected
                ? AppColors.primary
                : AppColors.textSecondary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
          ),
          icon: Icon(icon, size: 17),
        ),
      ),
    );
  }
}

class PageSizeButton extends StatelessWidget {
  const PageSizeButton({
    super.key,
    required this.pageSize,
    required this.onChanged,
  });

  final int pageSize;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const pageSizes = [30, 60];

    return PopupMenuButton<int>(
      tooltip: '페이지당 상품 수',
      initialValue: pageSize,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final size in pageSizes)
          PopupMenuItem(
            value: size,
            child: SelectMenuItemLabel(
              label: '$size개씩 보기',
              selected: size == pageSize,
            ),
          ),
      ],
      child: SmallToolbarButton(
        label: '$pageSize개씩 보기',
        icon: Icons.keyboard_arrow_down_rounded,
      ),
    );
  }
}

class SmallToolbarButton extends StatelessWidget {
  const SmallToolbarButton({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_panel.dart';
import 'package:re_view_front/features/search/presentation/widgets/result_column.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_summary.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class SearchResultsBody extends StatelessWidget {
  const SearchResultsBody({
    super.key,
    required this.state,
    required this.products,
    required this.selectedQuickFilter,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    required this.selectedReviewConditions,
    required this.selectedAttributeFilters,
    required this.selectedBrand,
    required this.minPriceController,
    required this.maxPriceController,
    required this.selectedRtiMinimum,
    required this.sortOption,
    required this.viewMode,
    required this.currentPage,
    required this.pageSize,
    required this.onQuickFilterSelected,
    required this.onCategoryToggled,
    required this.onPriceRangeToggled,
    required this.onReviewConditionToggled,
    required this.onAttributeToggled,
    required this.onBrandSelected,
    required this.onPriceChanged,
    required this.onRtiMinimumChanged,
    required this.onSortChanged,
    required this.onPageSelected,
    required this.onPageSizeChanged,
    required this.onViewModeChanged,
    required this.onResetFilters,
  });

  final SearchResultsState state;
  final List<SearchResultProduct> products;
  final String selectedQuickFilter;
  final Set<String> selectedCategories;
  final Set<String> selectedPriceRanges;
  final Set<String> selectedReviewConditions;
  final Set<String> selectedAttributeFilters;
  final String? selectedBrand;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final double selectedRtiMinimum;
  final SearchSortOption sortOption;
  final SearchViewMode viewMode;
  final int currentPage;
  final int pageSize;
  final ValueChanged<String> onQuickFilterSelected;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onPriceRangeToggled;
  final ValueChanged<String> onReviewConditionToggled;
  final ValueChanged<String> onAttributeToggled;
  final ValueChanged<String?> onBrandSelected;
  final VoidCallback onPriceChanged;
  final ValueChanged<double> onRtiMinimumChanged;
  final ValueChanged<SearchSortOption> onSortChanged;
  final ValueChanged<int> onPageSelected;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<SearchViewMode> onViewModeChanged;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const _SearchResultsSkeleton();
    }

    if (state.hasError) {
      return SizedBox(
        height: 420,
        child: AppErrorView(message: state.errorMessage!, retryLabel: '다시 검색'),
      );
    }

    final resultsKey = GlobalKey();
    void showResults() {
      final target = resultsKey.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 250),
          alignment: 0,
        );
      }
    }

    final useSingleColumn =
        context.isMobile || MediaQuery.sizeOf(context).width < 1080;

    if (useSingleColumn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchSummary(state: state),
          const SizedBox(height: AppSpacing.lg),
          QuickFilterRow(
            filters: state.quickFilters,
            selectedFilter: selectedQuickFilter,
            onSelected: onQuickFilterSelected,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.isEmpty)
            SearchEmptyState(state: state)
          else ...[
            FilterPanel(
              onShowResults: showResults,
              state: state,
              selectedCategories: selectedCategories,
              selectedPriceRanges: selectedPriceRanges,
              selectedReviewConditions: selectedReviewConditions,
              selectedAttributeFilters: selectedAttributeFilters,
              selectedBrand: selectedBrand,
              minPriceController: minPriceController,
              maxPriceController: maxPriceController,
              selectedRtiMinimum: selectedRtiMinimum,
              resultCount: products.length,
              compact: true,
              onCategoryToggled: onCategoryToggled,
              onPriceRangeToggled: onPriceRangeToggled,
              onReviewConditionToggled: onReviewConditionToggled,
              onAttributeToggled: onAttributeToggled,
              onBrandSelected: onBrandSelected,
              onPriceChanged: onPriceChanged,
              onRtiMinimumChanged: onRtiMinimumChanged,
              onResetFilters: onResetFilters,
            ),
            const SizedBox(height: AppSpacing.md),
            ResultColumn(
              key: resultsKey,
              state: state,
              products: products,
              sortOption: sortOption,
              viewMode: viewMode,
              currentPage: currentPage,
              pageSize: pageSize,
              onSortChanged: onSortChanged,
              onPageSelected: onPageSelected,
              onPageSizeChanged: onPageSizeChanged,
              onViewModeChanged: onViewModeChanged,
            ),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 252,
          child: FilterPanel(
            onShowResults: showResults,
            state: state,
            selectedCategories: selectedCategories,
            selectedPriceRanges: selectedPriceRanges,
            selectedReviewConditions: selectedReviewConditions,
            selectedAttributeFilters: selectedAttributeFilters,
            selectedBrand: selectedBrand,
            minPriceController: minPriceController,
            maxPriceController: maxPriceController,
            selectedRtiMinimum: selectedRtiMinimum,
            resultCount: products.length,
            onCategoryToggled: onCategoryToggled,
            onPriceRangeToggled: onPriceRangeToggled,
            onReviewConditionToggled: onReviewConditionToggled,
            onAttributeToggled: onAttributeToggled,
            onBrandSelected: onBrandSelected,
            onPriceChanged: onPriceChanged,
            onRtiMinimumChanged: onRtiMinimumChanged,
            onResetFilters: onResetFilters,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchSummary(state: state),
              const SizedBox(height: AppSpacing.lg),
              QuickFilterRow(
                filters: state.quickFilters,
                selectedFilter: selectedQuickFilter,
                onSelected: onQuickFilterSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isEmpty)
                SearchEmptyState(state: state)
              else
                ResultColumn(
                  key: resultsKey,
                  state: state,
                  products: products,
                  sortOption: sortOption,
                  viewMode: viewMode,
                  currentPage: currentPage,
                  pageSize: pageSize,
                  onSortChanged: onSortChanged,
                  onPageSelected: onPageSelected,
                  onPageSizeChanged: onPageSizeChanged,
                  onViewModeChanged: onViewModeChanged,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Skeleton ────────────────────────────────────────────────────────────────

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    final isMobile =
        context.isMobile || MediaQuery.sizeOf(context).width < 1080;

    return ShimmerWrapper(child: isMobile ? _buildMobile() : _buildWide());
  }

  Widget _buildWide() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 252, child: _FilterSidebarSkeleton()),
        const SizedBox(width: AppSpacing.xl),
        const Expanded(child: _ResultsAreaSkeleton()),
      ],
    );
  }

  Widget _buildMobile() {
    return const _ResultsAreaSkeleton();
  }
}

class _FilterSidebarSkeleton extends StatelessWidget {
  const _FilterSidebarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "필터 / 초기화" 헤더 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ShimmerBox(width: 36, height: 16, radius: 4),
            ShimmerBox(width: 36, height: 14, radius: 4),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // 필터 섹션 반복
        for (var i = 0; i < 5; i++) ...[
          _FilterSectionSkeleton(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _FilterSectionSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 섹션 제목
        const ShimmerBox(width: 72, height: 14, radius: 4),
        const SizedBox(height: AppSpacing.sm),
        // 체크박스 행 3개
        for (var i = 0; i < 3; i++) ...[
          Row(
            children: const [
              ShimmerBox(width: 16, height: 16, radius: 3),
              SizedBox(width: AppSpacing.xs),
              ShimmerBox(width: 80, height: 13, radius: 4),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

class _ResultsAreaSkeleton extends StatelessWidget {
  const _ResultsAreaSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 검색 요약 ("갤럭시 검색 결과 102개 상품")
        const ShimmerBox(width: 200, height: 22, radius: 4),
        const SizedBox(height: AppSpacing.xs),
        const ShimmerBox(width: 280, height: 14, radius: 4),
        const SizedBox(height: AppSpacing.lg),
        // 퀵 필터 칩 행
        Row(
          children: const [
            ShimmerBox(width: 72, height: 32, radius: 999),
            SizedBox(width: AppSpacing.xs),
            ShimmerBox(width: 64, height: 32, radius: 999),
            SizedBox(width: AppSpacing.xs),
            ShimmerBox(width: 80, height: 32, radius: 999),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // 툴바 행 (정렬 탭들 + 결과 수 + 보기 전환)
        Row(
          children: const [
            ShimmerBox(width: 48, height: 32, radius: 6),
            SizedBox(width: AppSpacing.xs),
            ShimmerBox(width: 56, height: 32, radius: 6),
            SizedBox(width: AppSpacing.xs),
            ShimmerBox(width: 48, height: 32, radius: 6),
            Spacer(),
            ShimmerBox(width: 60, height: 16, radius: 4),
            SizedBox(width: AppSpacing.sm),
            ShimmerBox(width: 72, height: 32, radius: 6),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // 상품 그리드
        const SearchProductGridSkeleton(),
      ],
    );
  }
}

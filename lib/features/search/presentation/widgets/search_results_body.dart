import 'package:re_view_front/core/error/failure.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/filter_panel.dart';
import 'package:re_view_front/features/search/presentation/widgets/result_column.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_summary.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class SearchResultsBody extends StatelessWidget {
  const SearchResultsBody({
    super.key,
    this.resultsKey,
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
    this.onRetry,
    this.failure,
  });

  final GlobalKey? resultsKey;
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
  final VoidCallback? onRetry;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SliverToBoxAdapter(child: _SearchResultsSkeleton());
    }
    if (failure != null || state.hasError) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 420,
          child: AppErrorView(
            message: state.errorMessage,
            failure: failure,
            retryLabel: AppLocalizations.of(context).failureSearchRetry,
            onRetry: onRetry,
          ),
        ),
      );
    }
    void showResults() {
      final target = resultsKey?.currentContext;
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
    Widget filters({bool compact = false, VoidCallback? onShowResults}) =>
        FilterPanel(
          onShowResults: onShowResults ?? showResults,
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
          compact: compact,
          onCategoryToggled: onCategoryToggled,
          onPriceRangeToggled: onPriceRangeToggled,
          onReviewConditionToggled: onReviewConditionToggled,
          onAttributeToggled: onAttributeToggled,
          onBrandSelected: onBrandSelected,
          onPriceChanged: onPriceChanged,
          onRtiMinimumChanged: onRtiMinimumChanged,
          onResetFilters: onResetFilters,
        );
    final results = SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
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
              if (useSingleColumn && !state.isSourceEmpty) ...[
                // 휴대폰 폭에서는 긴 패널 대신 버튼을 두고 같은 패널을 시트로 연다.
                if (context.isMobile)
                  _MobileFilterBar(
                    activeCount: _activeFilterCount,
                    onResetFilters: onResetFilters,
                    panelBuilder: (onShowResults) =>
                        filters(compact: true, onShowResults: onShowResults),
                    onShowResults: showResults,
                  )
                else
                  filters(compact: true),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
        if (state.isSourceEmpty)
          SliverToBoxAdapter(child: SearchEmptyState(state: state))
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
            onResetFilters: onResetFilters,
          ),
      ],
    );
    if (useSingleColumn) return results;
    return SliverCrossAxisGroup(
      slivers: [
        SliverConstrainedCrossAxis(
          maxExtent: 252,
          sliver: SliverToBoxAdapter(child: filters()),
        ),
        const SliverConstrainedCrossAxis(
          maxExtent: AppSpacing.xl,
          sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
        ),
        SliverCrossAxisExpanded(flex: 1, sliver: results),
      ],
    );
  }
}

extension on SearchResultsBody {
  int get _activeFilterCount =>
      selectedCategories.length +
      selectedPriceRanges.length +
      selectedReviewConditions.length +
      selectedAttributeFilters.length +
      (selectedBrand == null ? 0 : 1) +
      (state.isRtiFilterActive ? 1 : 0);
}

// ─── Mobile filter sheet ─────────────────────────────────────────────────────

typedef _FilterPanelBuilder = Widget Function(VoidCallback onShowResults);

/// 휴대폰 폭의 필터 버튼. 시트가 열린 동안에도 화면 상태가 바뀌면
/// 최신 패널을 다시 그리도록 빌더를 [ValueNotifier]로 넘긴다.
class _MobileFilterBar extends StatefulWidget {
  const _MobileFilterBar({
    required this.activeCount,
    required this.onResetFilters,
    required this.panelBuilder,
    required this.onShowResults,
  });

  final int activeCount;
  final VoidCallback onResetFilters;
  final _FilterPanelBuilder panelBuilder;
  final VoidCallback onShowResults;

  @override
  State<_MobileFilterBar> createState() => _MobileFilterBarState();
}

class _MobileFilterBarState extends State<_MobileFilterBar> {
  late final _panel = ValueNotifier<_FilterPanelBuilder>(widget.panelBuilder);

  @override
  void didUpdateWidget(_MobileFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 빌드 중에 시트를 다시 그리게 하지 않도록 프레임이 끝난 뒤 넘긴다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _panel.value = widget.panelBuilder;
    });
  }

  @override
  void dispose() {
    _panel.dispose();
    super.dispose();
  }

  Future<void> _openSheet() async {
    var showResults = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: ValueListenableBuilder<_FilterPanelBuilder>(
            valueListenable: _panel,
            builder: (context, build, _) => build(() {
              showResults = true;
              Navigator.of(sheetContext).pop();
            }),
          ),
        ),
      ),
    );
    if (showResults && mounted) widget.onShowResults();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = widget.activeCount;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _openSheet,
            icon: const Icon(Icons.tune, size: 18),
            label: Text(
              count > 0
                  ? '${l10n.searchFilterTitle} $count'
                  : l10n.searchFilterTitle,
            ),
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: widget.onResetFilters,
            child: Text(l10n.searchFilterReset),
          ),
        ],
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

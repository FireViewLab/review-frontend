import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_results_body.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class SearchResultsPage extends ConsumerStatefulWidget {
  const SearchResultsPage({
    required this.query,
    this.categoryId,
    this.categoryLabel,
    this.initialSort,
    super.key,
  });

  final String query;
  final String? categoryId;
  final String? categoryLabel;

  /// 헤더 정렬 메뉴(베스트·신상품·리뷰랭킹)로 들어오면 그 정렬로 시작한다.
  final SearchSortOption? initialSort;

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedPriceRanges = {};
  final Set<String> _selectedReviewConditions = {};
  final Set<String> _selectedAttributeFilters = {};
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  String _selectedQuickFilter = '전체';
  String? _selectedBrand;
  late SearchSortOption _sortOption =
      widget.initialSort ?? SearchSortOption.accuracy;
  SearchViewMode _viewMode = SearchViewMode.grid;
  double _selectedRtiMinimum = 50;
  bool _isPriceFilterActive = false;
  bool _isRtiFilterActive = false;
  int _currentPage = 1;
  int _pageSize = 30;
  String? _lastPriceRangeQuery;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _triggerSearch();
  }

  @override
  void didUpdateWidget(SearchResultsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.categoryId != widget.categoryId ||
        oldWidget.categoryLabel != widget.categoryLabel ||
        oldWidget.initialSort != widget.initialSort) {
      _resetFilters();
      _triggerSearch();
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    Future.microtask(
      () => ref
          .read(searchViewModelProvider.notifier)
          .search(
            _effectiveSearchQuery,
            allowEmpty: widget.categoryId != null || widget.initialSort != null,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchResubmissionProvider, (_, _) {
      _resetFilters();
      _triggerSearch();
    });
    final searchState = ref.watch(searchViewModelProvider);
    final products = _resolveProducts(searchState);
    final totalCount = _resolveTotalCount(searchState, products);
    final filteredProducts = _sortProducts(_filterProducts(products));
    final effectiveTotalCount = widget.categoryId == null
        ? totalCount
        : filteredProducts.length;

    _syncInitialPriceRange(products, _effectiveSearchQuery);

    final uiState = SearchResultsState(
      query: _displayQuery,
      products: filteredProducts,
      quickFilters: _buildQuickFilters(
        widget.categoryId == null ? products : filteredProducts,
        effectiveTotalCount ?? filteredProducts.length,
      ),
      categoryFilters: _buildCategoryFilters(
        widget.categoryId == null ? products : filteredProducts,
      ),
      priceRanges: _buildPriceRanges(products),
      totalCount: effectiveTotalCount,
      isLoading: searchState.isLoading,
      errorMessage: searchState is SearchFailure
          ? searchState.failure.message
          : null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1760,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.lg,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: SearchResultsBody(
                state: uiState,
                products: uiState.products,
                selectedQuickFilter: _selectedQuickFilter,
                selectedCategories: _selectedCategories,
                selectedPriceRanges: _selectedPriceRanges,
                selectedReviewConditions: _selectedReviewConditions,
                selectedAttributeFilters: _selectedAttributeFilters,
                selectedBrand: _selectedBrand,
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
                selectedRtiMinimum: _selectedRtiMinimum,
                sortOption: _sortOption,
                viewMode: _viewMode,
                onQuickFilterSelected: _handleQuickFilterSelected,
                onCategoryToggled: _toggleCategory,
                onPriceRangeToggled: _togglePriceRange,
                onReviewConditionToggled: _toggleReviewCondition,
                onAttributeToggled: _toggleAttributeFilter,
                onBrandSelected: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _currentPage = 1;
                  });
                },
                currentPage: _currentPage,
                pageSize: _pageSize,
                onPriceChanged: _handleManualPriceChanged,
                onRtiMinimumChanged: (value) {
                  setState(() {
                    _selectedRtiMinimum = value;
                    _isRtiFilterActive = true;
                    _currentPage = 1;
                  });
                },
                onSortChanged: (value) {
                  if (value == _sortOption) return;
                  setState(() {
                    _sortOption = value;
                    _currentPage = 1;
                  });
                },
                onPageSelected: (page) {
                  if (page == _currentPage) return;
                  setState(() => _currentPage = page);
                },
                onPageSizeChanged: (pageSize) {
                  if (pageSize == _pageSize) return;
                  setState(() {
                    _pageSize = pageSize;
                    _currentPage = 1;
                  });
                },
                onViewModeChanged: (viewMode) {
                  if (viewMode == _viewMode) return;
                  setState(() => _viewMode = viewMode);
                },
                onResetFilters: _resetFilters,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<SearchFilterChipData> _buildQuickFilters(
    List<SearchResultProduct> products,
    int totalCount,
  ) {
    final categorySet = <String>{};
    for (final p in products) {
      final label = _categoryLabelForProduct(p);
      if (label.isNotEmpty) {
        categorySet.add(label);
      }
    }
    return [
      SearchFilterChipData(label: '전체', count: totalCount),
      const SearchFilterChipData(label: 'RTI 80+', count: 0),
      for (final cat in categorySet)
        SearchFilterChipData(
          label: cat,
          count: products
              .where((p) => _categoryLabelForProduct(p) == cat)
              .length,
        ),
    ];
  }

  List<SearchFilterChipData> _buildPriceRanges(
    List<SearchResultProduct> products,
  ) {
    if (products.isEmpty) return const [];
    return const [
      SearchFilterChipData(label: '1만원 이하', count: 0),
      SearchFilterChipData(label: '10~30만원', count: 0),
      SearchFilterChipData(label: '30만원 이상', count: 0),
    ];
  }

  List<SearchFilterChipData> _buildCategoryFilters(
    List<SearchResultProduct> products,
  ) {
    final counts = <String, int>{};
    for (final p in products) {
      final label = _categoryLabelForProduct(p);
      if (label.isEmpty) continue;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts.entries
        .map((e) => SearchFilterChipData(label: e.key, count: e.value))
        .toList();
  }

  List<SearchResultProduct> _resolveProducts(SearchState state) {
    return switch (state) {
      SearchSuccess(:final products) => products,
      _ => const [],
    };
  }

  int? _resolveTotalCount(
    SearchState state,
    List<SearchResultProduct> products,
  ) {
    return switch (state) {
      SearchSuccess(:final totalCount) => totalCount,
      _ => null,
    };
  }

  void _handleQuickFilterSelected(String label) {
    setState(() {
      _selectedQuickFilter = label;
      _currentPage = 1;
      switch (label) {
        case '전체':
          _sortOption = SearchSortOption.accuracy;
          _selectedRtiMinimum = 50;
          _isRtiFilterActive = false;
          break;
        case 'RTI 80+':
          _selectedRtiMinimum = 80;
          _isRtiFilterActive = true;
          break;
      }
    });
  }

  void _toggleCategory(String label) {
    setState(() {
      _toggleSetValue(_selectedCategories, label);
      _currentPage = 1;
    });
  }

  void _togglePriceRange(String label) {
    setState(() {
      if (_selectedPriceRanges.contains(label)) {
        _selectedPriceRanges.clear();
        _isPriceFilterActive = false;
        _lastPriceRangeQuery = null;
        _syncInitialPriceRange(
          _resolveProducts(ref.read(searchViewModelProvider)),
          _effectiveSearchQuery,
        );
      } else {
        _selectedPriceRanges
          ..clear()
          ..add(label);
        final range = _priceRangeFor(label);
        _minPriceController.text = range.$1;
        _maxPriceController.text = range.$2;
        _isPriceFilterActive = true;
      }
      _currentPage = 1;
    });
  }

  void _handleManualPriceChanged() {
    setState(() {
      _selectedPriceRanges.clear();
      _isPriceFilterActive = true;
      _currentPage = 1;
    });
  }

  void _toggleReviewCondition(String label) {
    setState(() {
      _toggleSetValue(_selectedReviewConditions, label);
      _currentPage = 1;
    });
  }

  void _toggleAttributeFilter(String label) {
    setState(() {
      _toggleSetValue(_selectedAttributeFilters, label);
      _currentPage = 1;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedPriceRanges.clear();
      _isPriceFilterActive = false;
      _lastPriceRangeQuery = null;
      _selectedBrand = null;
      _selectedAttributeFilters.clear();
      _selectedReviewConditions.clear();
      _selectedQuickFilter = '전체';
      _sortOption = widget.initialSort ?? SearchSortOption.accuracy;
      _viewMode = SearchViewMode.grid;
      _selectedRtiMinimum = 50;
      _isRtiFilterActive = false;
      _currentPage = 1;
      _pageSize = 30;
    });
  }

  List<SearchResultProduct> _filterProducts(
    List<SearchResultProduct> products,
  ) {
    return products
        .where((product) {
          if (widget.categoryId != null &&
              !isProductInCategory(
                widget.categoryId!,
                productCategory: product.category,
                productCategoryDisplayName: product.categoryDisplayName,
                productName: _classificationTextFor(product),
              )) {
            return false;
          }

          if (_selectedCategories.isNotEmpty &&
              !_selectedCategories.contains(
                _categoryLabelForProduct(product),
              )) {
            return false;
          }

          if (_selectedPriceRanges.isNotEmpty &&
              !_selectedPriceRanges.any(
                (range) => _matchesPriceRange(product, range),
              )) {
            return false;
          }

          if (_isPriceFilterActive) {
            final minPrice = _parsePrice(_minPriceController.text);
            final maxPrice = _parsePrice(_maxPriceController.text);
            if (minPrice != null && product.price < minPrice) return false;
            if (maxPrice != null && product.price > maxPrice) return false;
          }

          if (_isRtiFilterActive && product.avgRti < _selectedRtiMinimum) {
            return false;
          }

          if (_selectedReviewConditions.contains('리뷰 50개 이상') &&
              product.reviewCount < 50) {
            return false;
          }

          if (_selectedQuickFilter != '전체' &&
              !_matchesQuickFilter(product, _selectedQuickFilter)) {
            return false;
          }

          return true;
        })
        .toList(growable: false);
  }

  List<SearchResultProduct> _sortProducts(List<SearchResultProduct> products) {
    final sorted = [...products];
    switch (_sortOption) {
      case SearchSortOption.accuracy:
        return sorted;
      case SearchSortOption.rti:
        sorted.sort((a, b) => b.avgRti.compareTo(a.avgRti));
      case SearchSortOption.reviewCount:
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case SearchSortOption.sales:
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case SearchSortOption.priceLow:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case SearchSortOption.priceHigh:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case SearchSortOption.newest:
        sorted.sort((a, b) => b.id.compareTo(a.id));
    }
    return sorted;
  }

  bool _matchesPriceRange(SearchResultProduct product, String label) {
    return switch (label) {
      '1만원 이하' => product.price <= 10000,
      '10~30만원' => product.price >= 100000 && product.price <= 300000,
      '30만원 이상' => product.price >= 300000,
      _ => true,
    };
  }

  (String, String) _priceRangeFor(String label) {
    return switch (label) {
      '1만원 이하' => ('0', '10000'),
      '10~30만원' => ('100000', '300000'),
      '30만원 이상' => ('300000', '700000'),
      _ => ('0', '700000'),
    };
  }

  int? _parsePrice(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }

  void _syncInitialPriceRange(
    List<SearchResultProduct> products,
    String query,
  ) {
    if (_isPriceFilterActive || _lastPriceRangeQuery == query) return;

    _lastPriceRangeQuery = query;
    if (products.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _minPriceController.clear();
        _maxPriceController.clear();
      });
      return;
    }

    final prices = products.map((p) => p.price);
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _minPriceController.text = '$minPrice';
      _maxPriceController.text = '$maxPrice';
    });
  }

  bool _matchesQuickFilter(SearchResultProduct product, String label) {
    return switch (label) {
      'RTI 80+' => product.avgRti >= 80,
      '무선' => product.name.contains('무선'),
      '노이즈캔슬링' => product.name.contains('ANC') || product.name.contains('노이즈'),
      '커널형' => product.name.contains('커널'),
      _ => _categoryLabelForProduct(product) == label,
    };
  }

  void _toggleSetValue(Set<String> values, String value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
  }

  String _categoryLabelForProduct(SearchResultProduct product) {
    return normalizedCategoryLabel(
      category: product.category,
      categoryDisplayName: product.categoryDisplayName,
      productName: _classificationTextFor(product),
    );
  }

  String _classificationTextFor(SearchResultProduct product) {
    final searchContext = _effectiveSearchQuery.trim();
    if (searchContext.isEmpty) return product.name;
    return '$searchContext ${product.name}';
  }

  String get _displayQuery {
    final searchInputQuery = _searchInputQuery;
    if (searchInputQuery.isNotEmpty) return searchInputQuery;
    return widget.query;
  }

  String get _effectiveSearchQuery => _searchInputQuery;

  String get _searchInputQuery {
    final query = widget.query.trim();
    if (query.isNotEmpty) return query;

    final categoryLabel = widget.categoryLabel?.trim();
    if (categoryLabel != null && categoryLabel.isNotEmpty) {
      return categoryLabel;
    }

    return '';
  }
}

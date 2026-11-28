import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb, mapEquals;
import 'package:re_view_front/shared/widgets/sliver_width_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/category/domain/entities/product_catalog_category.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/models/search_filter_options.dart';
import 'package:re_view_front/features/search/presentation/models/search_view_mode.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_product_derivation.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_results_body.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'dart:math' as math;

/// 검색 화면이 주소에 남기는 필터·정렬·페이지 쿼리 이름.
const searchFilterQueryKeys = {
  'order',
  'page',
  'size',
  'view',
  'min',
  'max',
  'price',
  'rti',
  'mall',
  'qf',
  'cat',
  'review',
  'attr',
};

class SearchResultsPage extends ConsumerStatefulWidget {
  const SearchResultsPage({
    required this.query,
    this.categoryId,
    this.categoryLabel,
    this.initialSort,
    this.filterParams = const {},
    super.key,
  });

  final String query;
  final String? categoryId;
  final String? categoryLabel;

  /// 헤더 정렬 메뉴(베스트·신상품·리뷰랭킹)로 들어오면 그 정렬로 시작한다.
  final SearchSortOption? initialSort;

  /// 주소에 남긴 필터·정렬·페이지 상태. 뒤로가기·새로고침 때 이 값으로 복원한다.
  final Map<String, String> filterParams;

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  final _scrollController = ScrollController();
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedPriceRanges = {};
  final Set<String> _selectedReviewConditions = {};
  final Set<String> _selectedAttributeFilters = {};
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  String _selectedQuickFilter = '전체';
  String? _selectedBrand;
  late SearchSortOption _sortOption = _supportedSort(widget.initialSort);
  SearchViewMode _viewMode = SearchViewMode.grid;
  double _selectedRtiMinimum = 50;
  bool _isPriceFilterActive = false;
  bool _isRtiFilterActive = false;
  int _currentPage = 1;
  int _pageSize = defaultSearchPageSize;
  final _resultsKey = GlobalKey();
  SearchParams? _lastPriceRangeRequest;
  Map<String, String>? _lastSyncedFilterParams;
  bool _needsUrlFacetValidation = false;
  bool _searchStartPending = false;

  final _productDerivation = SearchProductDerivation();

  // 원본 결과로만 정해지는 필터 집계는 원본 목록이 바뀔 때만 다시 만든다.
  List<SearchResultProduct>? _facetSource;
  List<SearchResultProduct> _pageProducts = const [];
  List<SearchFilterChipData> _quickFilterFacets = const [];
  List<SearchFilterChipData> _categoryFacets = const [];
  List<SearchFilterChipData> _priceRangeFacets = const [];

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _applyFilterParams(widget.filterParams);
    _triggerSearch();
  }

  @override
  void didUpdateWidget(SearchResultsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mapEquals(oldWidget.filterParams, widget.filterParams)) {
      _lastSyncedFilterParams = null;
    }
    if (oldWidget.categoryId != widget.categoryId ||
        oldWidget.categoryLabel != widget.categoryLabel) {
      _facetSource = null;
    }
    if (oldWidget.query != widget.query ||
        oldWidget.categoryId != widget.categoryId ||
        oldWidget.categoryLabel != widget.categoryLabel ||
        oldWidget.initialSort != widget.initialSort) {
      _lastSyncedFilterParams = null;
      _clearFilterState();
      _applyFilterParams(widget.filterParams);
      _triggerSearch();
      return;
    }
    // 브라우저 뒤로·앞으로 이동처럼 주소의 조건만 바뀐 경우 화면 상태를 맞춘다.
    final incoming = _pickFilterParams(widget.filterParams);
    if (!mapEquals(incoming, _pickFilterParams(oldWidget.filterParams)) &&
        !mapEquals(incoming, _filterParams())) {
      final previousRequest = _searchParams;
      _clearFilterState();
      _applyFilterParams(incoming);
      if (previousRequest != _searchParams) _triggerSearch();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _triggerSearch({bool refresh = false}) {
    _searchStartPending = true;
    Future<void>.microtask(() async {
      if (!mounted) return;
      setState(() => _searchStartPending = false);
      await _loadResults(refresh: refresh);
    });
  }

  Future<void> _loadResults({bool refresh = false}) async {
    final params = _searchParams;
    await ref
        .read(searchViewModelProvider.notifier)
        .load(
          params,
          allowEmpty: widget.categoryId != null || widget.initialSort != null,
          refresh: refresh,
        );
    if (!mounted || !params.catalog || params != _searchParams) return;

    // 공유 주소가 현재 카탈로그의 마지막 페이지를 넘으면 주소와 목록을 맞춘다.
    final state = ref.read(searchViewModelProvider);
    if (state is SearchSuccess && state.params == params) {
      final lastPage = searchPageCount(state.totalCount, params.size);
      if (_currentPage > lastPage) {
        setState(() => _currentPage = lastPage);
        _triggerSearch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchResubmissionProvider, (_, _) {
      _resetFilters();
      // 같은 검색어를 다시 제출하면 저장된 결과 대신 새로 받는다.
      _triggerSearch(refresh: true);
    });
    final searchState = ref.watch(searchViewModelProvider);
    final params = _searchParams;
    final catalogCategory = _catalogCategory;
    final hasCurrentResults =
        !_searchStartPending &&
        searchState is SearchCompleted &&
        searchState.params == params;
    final products = hasCurrentResults
        ? _resolveProducts(searchState)
        : const <SearchResultProduct>[];
    final catalogTotal =
        params.catalog && hasCurrentResults && searchState is SearchSuccess
        ? searchState.totalCount
        : null;
    if (!identical(_facetSource, products)) {
      _facetSource = products;
      _pageProducts = catalogCategory?.localFilterId == null
          ? products
          : products
                .where(
                  (product) => catalogCategory!.includes(
                    category: product.category,
                    categoryDisplayName: product.categoryDisplayName,
                    subCategory: product.subCategory,
                  ),
                )
                .toList(growable: false);
      _quickFilterFacets = _buildQuickFilters(
        _pageProducts,
        catalogTotal ?? _pageProducts.length,
      );
      _categoryFacets = _buildCategoryFilters(_pageProducts);
      _priceRangeFacets = _buildPriceRanges(_pageProducts);
    }

    // 다른 검색어의 이전 결과나 로딩·실패 상태로 공유 주소를 정리하지 않는다.
    if (_needsUrlFacetValidation && hasCurrentResults) {
      _validateUrlFacets(_pageProducts);
    }
    final filteredProducts = _productDerivation.resolve(
      _pageProducts,
      _productFilters,
      _sortOption,
    );
    final totalCount = catalogTotal ?? filteredProducts.length;
    final failure =
        !_searchStartPending &&
            searchState is SearchFailure &&
            searchState.params == params
        ? searchState.failure
        : null;

    _syncInitialPriceRange(_pageProducts, params);
    _syncFilterParamsToUrl();

    final uiState = SearchResultsState(
      query: _displayQuery,
      products: filteredProducts,
      sourceProducts: _pageProducts,
      quickFilters: _quickFilterFacets,
      categoryFilters: _categoryFacets,
      priceRanges: _priceRangeFacets,
      sortOption: _sortOption,
      isRtiFilterActive: _isRtiFilterActive,
      selectedRtiMinimum: _selectedRtiMinimum.round(),
      totalCount: totalCount,
      isCatalog: params.catalog,
      isLoading: _searchStartPending || searchState.isLoading,
      errorMessage: failure?.message,
      categoryPath: _categoryPath,
    );

    final scrollView = CustomScrollView(
      controller: _scrollController,
      physics: kIsWeb ? null : const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              params.catalog
                  ? catalogCategory?.localFilterId == null
                        ? AppLocalizations.of(context).searchCatalogPageScope
                        : AppLocalizations.of(context).searchCatalogParentScope
                  : AppLocalizations.of(
                      context,
                    ).searchLoadedProductsScope(products.length, 40),
            ),
          ),
        ),
        if (!params.catalog &&
            widget.categoryId != null &&
            products.any((p) => !_productDerivation.hasResolvedCategory(p)))
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                AppLocalizations.of(context).searchUnconfirmedCategoriesNotice,
              ),
            ),
          ),
        SliverWidthBuilder(
          builder: (context, width) {
            final inset = math.max(0.0, (width - 1760) / 2);
            final edge = context.isMobile ? AppSpacing.md : AppSpacing.xxl;
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(
                inset + edge,
                AppSpacing.lg,
                inset + edge,
                AppSpacing.xxxl,
              ),
              sliver: SearchResultsBody(
                resultsKey: _resultsKey,
                state: uiState,
                failure: failure,
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
                    _resetLocalPage();
                  });
                },
                currentPage: _currentPage,
                pageSize: _pageSize,
                onPriceChanged: _handleManualPriceChanged,
                onRtiMinimumChanged: (value) {
                  setState(() {
                    _selectedRtiMinimum = value;
                    _selectedAttributeFilters.remove('분석 전만');
                    if (_selectedQuickFilter == '분석 전') {
                      _selectedQuickFilter = '전체';
                    }
                    _isRtiFilterActive = true;
                    _resetLocalPage();
                  });
                },
                onSortChanged: (value) {
                  if (value == _sortOption) return;
                  setState(() {
                    _sortOption = value;
                    _resetLocalPage();
                  });
                },
                onPageSelected: (page) {
                  if (page == _currentPage) return;
                  setState(() => _currentPage = page);
                  if (params.catalog) {
                    _triggerSearch();
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                  }
                },
                onPageSizeChanged: (pageSize) {
                  if (pageSize == _pageSize) return;
                  setState(() {
                    _pageSize = pageSize;
                    _currentPage = 1;
                  });
                  if (params.catalog) _triggerSearch();
                },
                onViewModeChanged: (viewMode) {
                  if (viewMode == _viewMode) return;
                  setState(() => _viewMode = viewMode);
                },
                onResetFilters: _resetFilters,
                onRetry: () => _triggerSearch(refresh: true),
              ),
            );
          },
        ),
      ],
    );
    return Scaffold(
      floatingActionButton: ScrollToTopButton(controller: _scrollController),
      backgroundColor: AppColors.background,
      body: kIsWeb
          ? scrollView
          : RefreshIndicator(
              onRefresh: () => _loadResults(refresh: true),
              child: scrollView,
            ),
    );
  }

  List<SearchFilterChipData> _buildQuickFilters(
    List<SearchResultProduct> products,
    int totalCount,
  ) {
    final categorySet = <String>{};
    for (final p in products) {
      final label = _productDerivation.categoryLabel(p);
      if (label.isNotEmpty) {
        categorySet.add(label);
      }
    }
    return [
      SearchFilterChipData(label: '전체', count: totalCount),
      SearchFilterChipData(
        label: 'RTI 80+',
        count: products
            .where(
              (p) =>
                  !p.analysisDisplay.isV2 &&
                  p.analysisDisplay.score != null &&
                  p.analysisDisplay.score! >= 80,
            )
            .length,
      ),
      SearchFilterChipData(
        label: '분석 전',
        count: products
            .where(
              (p) => !p.analysisDisplay.isV2 && p.analysisDisplay.score == null,
            )
            .length,
      ),
      for (final cat in categorySet)
        SearchFilterChipData(
          label: cat,
          count: products
              .where((p) => _productDerivation.categoryLabel(p) == cat)
              .length,
        ),
    ];
  }

  List<SearchFilterChipData> _buildPriceRanges(
    List<SearchResultProduct> products,
  ) {
    if (products.isEmpty) return const [];
    return [
      for (final label in searchPriceRanges.keys)
        SearchFilterChipData(
          label: label,
          count: products
              .where((p) => _productDerivation.matchesPriceRange(p, label))
              .length,
        ),
    ];
  }

  List<SearchFilterChipData> _buildCategoryFilters(
    List<SearchResultProduct> products,
  ) {
    final counts = <String, int>{};
    for (final p in products) {
      final label = _productDerivation.categoryLabel(p);
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

  void _handleQuickFilterSelected(String label) {
    setState(() {
      _selectedQuickFilter = label;
      _resetLocalPage();
      switch (label) {
        case '전체':
          _sortOption = SearchSortOption.accuracy;
          _selectedRtiMinimum = 50;
          _isRtiFilterActive = false;
          break;
        case '분석 전':
          _isRtiFilterActive = false;
          break;
        case 'RTI 80+':
          _selectedAttributeFilters.remove('분석 전만');
          _selectedRtiMinimum = 80;
          _isRtiFilterActive = true;
          break;
      }
    });
  }

  void _toggleCategory(String label) {
    setState(() {
      _toggleSetValue(_selectedCategories, label);
      _resetLocalPage();
    });
  }

  void _togglePriceRange(String label) {
    setState(() {
      if (_selectedPriceRanges.contains(label)) {
        _selectedPriceRanges.clear();
        _isPriceFilterActive = false;
        _lastPriceRangeRequest = null;
        _syncInitialPriceRange(_pageProducts, _searchParams);
      } else {
        _selectedPriceRanges
          ..clear()
          ..add(label);
        _setPriceBounds(searchPriceRanges[label]!);
      }
      _resetLocalPage();
    });
  }

  void _handleManualPriceChanged() {
    setState(() {
      _selectedPriceRanges.clear();
      _isPriceFilterActive = true;
      _resetLocalPage();
    });
  }

  void _toggleReviewCondition(String label) {
    setState(() {
      _toggleSetValue(_selectedReviewConditions, label);
      _resetLocalPage();
    });
  }

  void _toggleAttributeFilter(String label) {
    setState(() {
      _toggleSetValue(_selectedAttributeFilters, label);
      if (label == '분석 전만' && _selectedAttributeFilters.contains(label)) {
        _isRtiFilterActive = false;
        _selectedQuickFilter = '전체';
      }
      _resetLocalPage();
    });
  }

  void _resetFilters() {
    setState(() {
      final page = _currentPage;
      final size = _pageSize;
      _clearFilterState();
      if (_isCatalog) {
        _currentPage = page;
        _pageSize = size;
      }
    });
  }

  void _resetLocalPage() {
    if (!_isCatalog) _currentPage = 1;
  }

  void _clearFilterState() {
    _selectedCategories.clear();
    _selectedPriceRanges.clear();
    _isPriceFilterActive = false;
    _lastPriceRangeRequest = null;
    _selectedBrand = null;
    _selectedAttributeFilters.clear();
    _selectedReviewConditions.clear();
    _selectedQuickFilter = '전체';
    _sortOption = _supportedSort(widget.initialSort);
    _viewMode = SearchViewMode.grid;
    _selectedRtiMinimum = 50;
    _isRtiFilterActive = false;
    _currentPage = 1;
    _pageSize = defaultSearchPageSize;
    _needsUrlFacetValidation = false;
  }

  // ─── 주소 쿼리와 필터 상태 ────────────────────────────────────────────────
  // 'sort'는 헤더 메뉴의 진입 정렬이므로 그대로 두고, 화면에서 고른 정렬은
  // 'order'로 따로 남긴다. 기본값과 같은 항목은 주소에 넣지 않는다.

  static const _listSeparator = '|';

  Map<String, String> _pickFilterParams(Map<String, String> params) => {
    for (final entry in params.entries)
      if (searchFilterQueryKeys.contains(entry.key)) entry.key: entry.value,
  };

  Map<String, String> _filterParams() {
    String join(Set<String> values) =>
        (values.toList()..sort()).join(_listSeparator);
    final (min, max) = _normalizedPriceBounds(
      _minPriceController.text,
      _maxPriceController.text,
    );
    return {
      if (_sortOption != _supportedSort(widget.initialSort))
        'order': _sortOption.name,
      if (_currentPage != 1) 'page': '$_currentPage',
      if (_pageSize != defaultSearchPageSize) 'size': '$_pageSize',
      if (_viewMode != SearchViewMode.grid) 'view': _viewMode.name,
      if (_selectedPriceRanges.isNotEmpty)
        'price': join(_selectedPriceRanges)
      else if (_isPriceFilterActive) ...{
        'min': ?min?.toString(),
        'max': ?max?.toString(),
      },
      if (_isRtiFilterActive) 'rti': '${_selectedRtiMinimum.round()}',
      'mall': ?_selectedBrand,
      if (_selectedQuickFilter != '전체') 'qf': _selectedQuickFilter,
      if (_selectedCategories.isNotEmpty) 'cat': join(_selectedCategories),
      if (_selectedReviewConditions.isNotEmpty)
        'review': join(_selectedReviewConditions),
      if (_selectedAttributeFilters.isNotEmpty)
        'attr': join(_selectedAttributeFilters),
    };
  }

  /// 주소의 값을 화면 상태에 넣는다. setState 안이나 initState에서 부른다.
  void _applyFilterParams(Map<String, String> params) {
    Set<String> split(String? value) => value == null || value.isEmpty
        ? <String>{}
        : value.split(_listSeparator).where((v) => v.isNotEmpty).toSet();
    int? positive(String? value) {
      final parsed = int.tryParse(value ?? '');
      return parsed != null && parsed > 0 ? parsed : null;
    }

    final order = SearchSortOption.values
        .where((o) => o.name == params['order'])
        .firstOrNull;
    if (order != null) _sortOption = _supportedSort(order);
    _currentPage = positive(params['page']) ?? 1;
    final size = int.tryParse(params['size'] ?? '') ?? defaultSearchPageSize;
    _pageSize = searchPageSizes.contains(size) ? size : defaultSearchPageSize;
    _viewMode = params['view'] == SearchViewMode.list.name
        ? SearchViewMode.list
        : SearchViewMode.grid;

    final price = split(
      params['price'],
    ).where(searchPriceRanges.containsKey).firstOrNull;
    if (price != null) _selectedPriceRanges.add(price);
    final bounds =
        searchPriceRanges[price] ??
        _normalizedPriceBounds(params['min'], params['max']);
    if (bounds != (null, null)) _setPriceBounds(bounds);

    final rti = int.tryParse(params['rti'] ?? '');
    if (rti != null) {
      _selectedRtiMinimum = rti.clamp(0, 100).toDouble();
      _isRtiFilterActive = true;
    }
    final mall = params['mall'];
    _selectedBrand = mall == null || mall.isEmpty ? null : mall;
    _selectedQuickFilter = params['qf'] ?? '전체';
    _selectedCategories.addAll(split(params['cat']));
    _needsUrlFacetValidation =
        _selectedBrand != null ||
        _selectedQuickFilter != '전체' ||
        _selectedCategories.isNotEmpty;
    _selectedReviewConditions.addAll(
      split(params['review']).where(searchReviewConditions.contains),
    );
    _selectedAttributeFilters.addAll(
      split(params['attr']).where(searchAttributeFilters.contains),
    );
  }

  void _validateUrlFacets(List<SearchResultProduct> products) {
    _needsUrlFacetValidation = false;

    if (!_quickFilterFacets.any(
      (facet) => facet.label == _selectedQuickFilter,
    )) {
      _selectedQuickFilter = '전체';
    }
    final categories = _categoryFacets.map((facet) => facet.label).toSet();
    _selectedCategories.retainAll(categories);
    final brand = normalizeSearchPlatform(_selectedBrand);
    _selectedBrand =
        brand != null &&
            products.any((product) => product.normalizedPlatform == brand)
        ? brand
        : null;
  }

  /// 화면 상태가 주소와 다르면 방문 기록을 늘리지 않고 주소만 바꾼다.
  void _syncFilterParamsToUrl() {
    final desired = _filterParams();
    if (mapEquals(desired, _pickFilterParams(widget.filterParams)) ||
        mapEquals(desired, _lastSyncedFilterParams)) {
      return;
    }
    _lastSyncedFilterParams = desired;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = GoRouter.maybeOf(context);
      if (router == null) return;
      final current = _filterParams();
      if (mapEquals(current, _pickFilterParams(widget.filterParams))) return;
      // 검색어·카테고리 같은 나머지 값은 현재 주소에서 그대로 가져온다.
      final location = GoRouterState.of(context).uri;
      final params = {
        for (final entry in location.queryParameters.entries)
          if (!searchFilterQueryKeys.contains(entry.key))
            entry.key: entry.value,
        ...current,
      };
      Router.neglect(
        context,
        () => router.go(
          Uri(path: location.path, queryParameters: params).toString(),
        ),
      );
    });
  }

  SearchProductFilters get _productFilters => (
    categories: _selectedCategories,
    priceRanges: _selectedPriceRanges,
    rules: (
      categoryId: _isCatalog ? null : widget.categoryId,
      platform: _selectedBrand,
      priceBounds: _isPriceFilterActive
          ? _normalizedPriceBounds(
              _minPriceController.text,
              _maxPriceController.text,
            )
          : (null, null),
      quickFilter: _selectedQuickFilter,
      unanalyzedOnly: _selectedAttributeFilters.contains('분석 전만'),
      missingPriceOnly: _selectedAttributeFilters.contains('가격 정보 없음만'),
      minimumRti: _isRtiFilterActive ? _selectedRtiMinimum : null,
      minimumReviews: _selectedReviewConditions.contains('리뷰 50개 이상'),
    ),
  );

  void _setPriceBounds((int?, int?) bounds) {
    final (min, max) = bounds;
    _minPriceController.text = min == null ? '' : '$min';
    _maxPriceController.text = max == null ? '' : '$max';
    _isPriceFilterActive = true;
  }

  (int?, int?) _normalizedPriceBounds(String? min, String? max) {
    final lower = _parsePrice(min);
    final upper = _parsePrice(max);
    // 슬라이더와 검색 결과에 같은 가격 범위를 적용한다.
    if (lower != null && upper != null && lower > upper) return (upper, lower);
    return (lower, upper);
  }

  int? _parsePrice(String? value) {
    final parsed = int.tryParse(value?.replaceAll(',', '').trim() ?? '');
    return parsed != null && parsed >= 0 ? parsed : null;
  }

  void _syncInitialPriceRange(
    List<SearchResultProduct> products,
    SearchParams params,
  ) {
    if (_isPriceFilterActive || _lastPriceRangeRequest == params) return;

    // 로딩 중 빈 목록에서 query를 기록하면 실제 결과가 와도 가격 범위를
    // 다시 잡지 않으므로, 가격이 있는 결과를 받았을 때만 기록한다.
    final prices = products.map((p) => p.price).whereType<int>().toList();
    if (prices.isEmpty) {
      if (_minPriceController.text.isEmpty &&
          _maxPriceController.text.isEmpty) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isPriceFilterActive || _searchParams != params) return;
        _minPriceController.clear();
        _maxPriceController.clear();
      });
      return;
    }
    _lastPriceRangeRequest = params;
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          _isPriceFilterActive ||
          _lastPriceRangeRequest != params) {
        return;
      }
      _minPriceController.text = '$minPrice';
      _maxPriceController.text = '$maxPrice';
    });
  }

  void _toggleSetValue(Set<String> values, String value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
  }

  List<SearchCategoryCrumb> get _categoryPath {
    final categoryId = widget.categoryId;
    if (widget.query.trim().isNotEmpty) return const [];
    final resolved = _resolvedBrowseCategory;
    if (resolved != null) {
      return [
        for (final category in resolved.path)
          SearchCategoryCrumb(id: category.id, label: category.label),
      ];
    }
    final label = widget.categoryLabel?.trim() ?? '';
    return label.isEmpty || categoryId == null
        ? const []
        : [SearchCategoryCrumb(id: categoryId, label: label)];
  }

  String get _displayQuery {
    final searchInputQuery = _searchInputQuery;
    if (searchInputQuery.isNotEmpty) return searchInputQuery;
    return widget.query;
  }

  ResolvedProductCategory? get _resolvedBrowseCategory =>
      resolveCatalogCategory(
        widget.categoryId,
        displayName: widget.categoryLabel,
      );

  ProductCatalogCategory? get _catalogCategory {
    if (widget.query.trim().isNotEmpty) return null;
    final category = _resolvedBrowseCategory;
    return category == null
        ? null
        : ProductCatalogCategory.forCategory(category);
  }

  // 홈과 카테고리 메뉴의 '전체 상품 보기'는 추천순으로 진입한다.
  bool get _isCatalog =>
      widget.query.trim().isEmpty &&
      (_resolvedBrowseCategory != null ||
          widget.initialSort == SearchSortOption.accuracy);

  SearchParams get _searchParams => _isCatalog
      ? SearchParams(
          query: '',
          catalog: true,
          category: _catalogCategory?.code,
          page: _currentPage - 1,
          size: _pageSize,
        )
      : SearchParams(query: _searchInputQuery);

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

SearchSortOption _supportedSort(SearchSortOption? option) =>
    option == SearchSortOption.sales || option == SearchSortOption.newest
    ? SearchSortOption.accuracy
    : option ?? SearchSortOption.accuracy;

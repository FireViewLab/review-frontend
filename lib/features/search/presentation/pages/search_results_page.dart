import 'package:flutter/foundation.dart' show kIsWeb, mapEquals;
import 'package:re_view_front/shared/widgets/sliver_width_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  int _pageSize = 30;
  final _resultsKey = GlobalKey();
  String? _lastPriceRangeQuery;
  Map<String, String>? _lastSyncedFilterParams;

  // 상품 단위 카테고리 해석은 결과가 바뀌지 않는 한 같으므로 상품 객체에 붙여 둔다.
  final _categoryLabelCache = Expando<String>('categoryLabel');
  final _resolvedCategoryCache = Expando<bool>('resolvedCategory');
  Expando<bool> _inCategoryCache = Expando<bool>('inCategory');

  // 원본 결과로만 정해지는 필터 집계는 원본 목록이 바뀔 때만 다시 만든다.
  List<SearchResultProduct>? _facetSource;
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
    if (oldWidget.categoryId != widget.categoryId) {
      _inCategoryCache = Expando<bool>('inCategory');
    }
    if (oldWidget.query != widget.query ||
        oldWidget.categoryId != widget.categoryId ||
        oldWidget.categoryLabel != widget.categoryLabel ||
        oldWidget.initialSort != widget.initialSort) {
      _lastSyncedFilterParams = null;
      _resetFilters();
      _applyFilterParams(widget.filterParams);
      _triggerSearch();
      return;
    }
    // 브라우저 뒤로·앞으로 이동처럼 주소의 조건만 바뀐 경우 화면 상태를 맞춘다.
    final incoming = _pickFilterParams(widget.filterParams);
    if (!mapEquals(incoming, _pickFilterParams(oldWidget.filterParams)) &&
        !mapEquals(incoming, _filterParams())) {
      setState(() {
        _clearFilterState();
        _applyFilterParams(incoming);
      });
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _triggerSearch({bool refresh = false}) {
    Future.microtask(
      () => ref
          .read(searchViewModelProvider.notifier)
          .search(
            _effectiveSearchQuery,
            allowEmpty: widget.categoryId != null || widget.initialSort != null,
            refresh: refresh,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchResubmissionProvider, (_, _) {
      _resetFilters();
      // 같은 검색어를 다시 제출하면 저장된 결과 대신 새로 받는다.
      _triggerSearch(refresh: true);
    });
    final searchState = ref.watch(searchViewModelProvider);
    final products = _resolveProducts(searchState);

    if (!identical(_facetSource, products)) {
      _facetSource = products;
      _quickFilterFacets = _buildQuickFilters(products, products.length);
      _categoryFacets = _buildCategoryFilters(products);
      _priceRangeFacets = _buildPriceRanges(products);
    }
    final filteredProducts = _sortProducts(_filterProducts(products));
    final effectiveTotalCount = filteredProducts.length;

    _syncInitialPriceRange(products, _effectiveSearchQuery);
    _syncFilterParamsToUrl();

    final uiState = SearchResultsState(
      query: _displayQuery,
      products: filteredProducts,
      sourceProducts: products,
      quickFilters: _quickFilterFacets,
      categoryFilters: _categoryFacets,
      priceRanges: _priceRangeFacets,
      sortOption: _sortOption,
      isRtiFilterActive: _isRtiFilterActive,
      selectedRtiMinimum: _selectedRtiMinimum.round(),
      totalCount: effectiveTotalCount,
      isLoading: searchState.isLoading,
      errorMessage: searchState is SearchFailure
          ? searchState.failure.message
          : null,
      categoryPath: _categoryPath,
    );

    final scrollView = CustomScrollView(
      physics: kIsWeb ? null : const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              '현재 불러온 ${products.length}개 상품에서 필터·정렬합니다. 키워드 검색은 최대 40개 결과이며 전체 쇼핑몰 상품 검색 필터가 아닙니다. 배송·판매량·출시일·사진 리뷰 정보는 제공되지 않아 해당 조건은 지원하지 않습니다.',
            ),
          ),
        ),
        if (widget.categoryId != null &&
            products.any((p) => !_hasResolvedCategory(p)))
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                '쇼핑몰 상품은 카테고리 이름으로 검색하며, 분류가 확정되지 않은 결과도 함께 표시합니다. 상세 분류는 쇼핑몰 원문을 확인해 주세요.',
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
                    _selectedAttributeFilters.remove('분석 전만');
                    if (_selectedQuickFilter == '분석 전') {
                      _selectedQuickFilter = '전체';
                    }
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
                onRetry: () => _triggerSearch(refresh: true),
              ),
            );
          },
        ),
      ],
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      body: kIsWeb
          ? scrollView
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(searchViewModelProvider.notifier)
                    .search(
                      _effectiveSearchQuery,
                      allowEmpty:
                          widget.categoryId != null ||
                          widget.initialSort != null,
                      refresh: true,
                    );
              },
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
      final label = _categoryLabelForProduct(p);
      if (label.isNotEmpty) {
        categorySet.add(label);
      }
    }
    return [
      SearchFilterChipData(label: '전체', count: totalCount),
      SearchFilterChipData(
        label: 'RTI 80+',
        count: products
            .where((p) => p.avgRti != null && p.avgRti! >= 80)
            .length,
      ),
      SearchFilterChipData(
        label: '분석 전',
        count: products.where((p) => p.avgRti == null).length,
      ),
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
    return [
      SearchFilterChipData(
        label: '1만원 이하',
        count: products.where((p) => _matchesPriceRange(p, '1만원 이하')).length,
      ),
      SearchFilterChipData(
        label: '10~30만원',
        count: products.where((p) => _matchesPriceRange(p, '10~30만원')).length,
      ),
      SearchFilterChipData(
        label: '30만원 이상',
        count: products.where((p) => _matchesPriceRange(p, '30만원 이상')).length,
      ),
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
      if (label == '분석 전만' && _selectedAttributeFilters.contains(label)) {
        _isRtiFilterActive = false;
        _selectedQuickFilter = '전체';
      }
      _currentPage = 1;
    });
  }

  void _resetFilters() {
    setState(_clearFilterState);
  }

  void _clearFilterState() {
    _selectedCategories.clear();
    _selectedPriceRanges.clear();
    _isPriceFilterActive = false;
    _lastPriceRangeQuery = null;
    _selectedBrand = null;
    _selectedAttributeFilters.clear();
    _selectedReviewConditions.clear();
    _selectedQuickFilter = '전체';
    _sortOption = _supportedSort(widget.initialSort);
    _viewMode = SearchViewMode.grid;
    _selectedRtiMinimum = 50;
    _isRtiFilterActive = false;
    _currentPage = 1;
    _pageSize = 30;
  }

  // ─── 주소 쿼리와 필터 상태 ────────────────────────────────────────────────
  // 'sort'는 헤더 메뉴의 진입 정렬이므로 그대로 두고, 화면에서 고른 정렬은
  // 'order'로 따로 남긴다. 기본값과 같은 항목은 주소에 넣지 않는다.

  static const _listSeparator = '|';

  Map<String, String> _pickFilterParams(Map<String, String> params) => {
    for (final entry in params.entries)
      if (searchFilterQueryKeys.contains(entry.key) && entry.value.isNotEmpty)
        entry.key: entry.value,
  };

  Map<String, String> _filterParams() {
    String join(Set<String> values) =>
        (values.toList()..sort()).join(_listSeparator);
    final min = _minPriceController.text.trim();
    final max = _maxPriceController.text.trim();
    return {
      if (_sortOption != _supportedSort(widget.initialSort))
        'order': _sortOption.name,
      if (_currentPage != 1) 'page': '$_currentPage',
      if (_pageSize != 30) 'size': '$_pageSize',
      if (_viewMode != SearchViewMode.grid) 'view': _viewMode.name,
      if (_selectedPriceRanges.isNotEmpty)
        'price': join(_selectedPriceRanges)
      else if (_isPriceFilterActive) ...{
        if (min.isNotEmpty) 'min': min,
        if (max.isNotEmpty) 'max': max,
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
    _pageSize = positive(params['size']) ?? 30;
    _viewMode = params['view'] == SearchViewMode.list.name
        ? SearchViewMode.list
        : SearchViewMode.grid;

    final priceRanges = split(params['price']);
    if (priceRanges.isNotEmpty) {
      final label = priceRanges.first;
      final range = _priceRangeFor(label);
      _selectedPriceRanges
        ..clear()
        ..add(label);
      _minPriceController.text = range.$1;
      _maxPriceController.text = range.$2;
      _isPriceFilterActive = true;
    } else {
      final min = int.tryParse(params['min'] ?? '');
      final max = int.tryParse(params['max'] ?? '');
      if (min != null || max != null) {
        _minPriceController.text = min == null ? '' : '$min';
        _maxPriceController.text = max == null ? '' : '$max';
        _isPriceFilterActive = true;
      }
    }

    final rti = int.tryParse(params['rti'] ?? '');
    if (rti != null) {
      _selectedRtiMinimum = rti.clamp(0, 100).toDouble();
      _isRtiFilterActive = true;
    }
    final mall = params['mall'];
    _selectedBrand = mall == null || mall.isEmpty ? null : mall;
    _selectedQuickFilter = params['qf'] ?? '전체';
    _selectedCategories.addAll(split(params['cat']));
    _selectedReviewConditions.addAll(split(params['review']));
    _selectedAttributeFilters.addAll(split(params['attr']));
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

  List<SearchResultProduct> _filterProducts(
    List<SearchResultProduct> products,
  ) {
    return products
        .where((product) {
          if (widget.categoryId != null &&
              _hasResolvedCategory(product) &&
              !(_inCategoryCache[product] ??= isProductInCategory(
                widget.categoryId!,
                productCategory: product.category,
                productCategoryDisplayName: product.categoryDisplayName,
                productName: '',
              ))) {
            return false;
          }

          if (_selectedBrand != null &&
              normalizeSearchPlatform(
                    product.platform ??
                        product.dataPlatform ??
                        product.externalRef?.platform,
                  ) !=
                  _selectedBrand) {
            return false;
          }
          if (_selectedAttributeFilters.contains('분석 전만') &&
              product.avgRti != null) {
            return false;
          }
          if (_selectedAttributeFilters.contains('가격 정보 없음만') &&
              product.price != null) {
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
            var minPrice = _parsePrice(_minPriceController.text);
            var maxPrice = _parsePrice(_maxPriceController.text);
            // 슬라이더는 최소>최대를 뒤집어 보여주므로 필터도 같은 범위로 맞춘다.
            if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
              (minPrice, maxPrice) = (maxPrice, minPrice);
            }
            if ((minPrice != null || maxPrice != null) &&
                product.price == null) {
              return false;
            }
            if (minPrice != null && product.price! < minPrice) return false;
            if (maxPrice != null && product.price! > maxPrice) return false;
          }

          if (_isRtiFilterActive &&
              (product.avgRti == null ||
                  product.avgRti! < _selectedRtiMinimum)) {
            return false;
          }

          if (_selectedReviewConditions.contains('리뷰 50개 이상') &&
              (product.reviewCount == null || product.reviewCount! < 50)) {
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
        sorted.sort((a, b) => (b.avgRti ?? -1).compareTo(a.avgRti ?? -1));
      case SearchSortOption.reviewCount:
        sorted.sort(
          (a, b) => (b.reviewCount ?? -1).compareTo(a.reviewCount ?? -1),
        );
      case SearchSortOption.sales:
        sorted.sort(
          (a, b) => (b.reviewCount ?? -1).compareTo(a.reviewCount ?? -1),
        );
      case SearchSortOption.priceLow:
        sorted.sort((a, b) => _comparePrice(a.price, b.price));
      case SearchSortOption.priceHigh:
        sorted.sort(
          (a, b) => _comparePrice(a.price, b.price, descending: true),
        );
      case SearchSortOption.newest:
        sorted.sort((a, b) => 0);
    }
    return sorted;
  }

  bool _matchesPriceRange(SearchResultProduct product, String label) {
    if (product.price == null) return false;
    return switch (label) {
      '1만원 이하' => product.price! <= 10000,
      '10~30만원' => product.price! >= 100000 && product.price! <= 300000,
      '30만원 이상' => product.price! >= 300000,
      _ => true,
    };
  }

  (String, String) _priceRangeFor(String label) {
    return switch (label) {
      '1만원 이하' => ('0', '10000'),
      '10~30만원' => ('100000', '300000'),
      '30만원 이상' => ('300000', ''),
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

    // 로딩 중 빈 목록에서 query를 기록하면 실제 결과가 와도 가격 범위를
    // 다시 잡지 않으므로, 가격이 있는 결과를 받았을 때만 기록한다.
    final prices = products.map((p) => p.price).whereType<int>().toList();
    if (prices.isEmpty) {
      if (_minPriceController.text.isEmpty &&
          _maxPriceController.text.isEmpty) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isPriceFilterActive) return;
        _minPriceController.clear();
        _maxPriceController.clear();
      });
      return;
    }
    _lastPriceRangeQuery = query;
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
      '분석 전' => product.avgRti == null,
      'RTI 80+' => product.avgRti != null && product.avgRti! >= 80,
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

  String _categoryLabelForProduct(SearchResultProduct product) =>
      _categoryLabelCache[product] ??= _computeCategoryLabel(product);

  String _computeCategoryLabel(SearchResultProduct product) {
    if (product.category.isEmpty) {
      return product.subCategory?.trim().isNotEmpty == true
          ? product.subCategory!
          : product.categoryDisplayName.isNotEmpty
          ? product.categoryDisplayName
          : '분류 정보 없음';
    }
    return normalizedCategoryLabel(
      category: product.category,
      categoryDisplayName: product.categoryDisplayName,
      productName: '',
    );
  }

  bool _hasResolvedCategory(SearchResultProduct product) =>
      _resolvedCategoryCache[product] ??= _computeHasResolvedCategory(product);

  bool _computeHasResolvedCategory(SearchResultProduct product) =>
      product.category.isNotEmpty &&
      resolveProductCategory(
            product.category,
            displayName: product.categoryDisplayName,
            productName: '',
          ) !=
          null;

  List<SearchCategoryCrumb> get _categoryPath {
    final categoryId = widget.categoryId;
    if (categoryId == null || widget.query.trim().isNotEmpty) return const [];
    final resolved = resolveProductCategory(categoryId);
    if (resolved != null) {
      return [
        for (final category in resolved.path)
          SearchCategoryCrumb(id: category.id, label: category.label),
      ];
    }
    final label = widget.categoryLabel?.trim() ?? '';
    return label.isEmpty
        ? const []
        : [SearchCategoryCrumb(id: categoryId, label: label)];
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

SearchSortOption _supportedSort(SearchSortOption? option) =>
    option == SearchSortOption.sales || option == SearchSortOption.newest
    ? SearchSortOption.accuracy
    : option ?? SearchSortOption.accuracy;
int _comparePrice(int? a, int? b, {bool descending = false}) {
  if (a == null) return b == null ? 0 : 1;
  if (b == null) return -1;
  return descending ? b.compareTo(a) : a.compareTo(b);
}

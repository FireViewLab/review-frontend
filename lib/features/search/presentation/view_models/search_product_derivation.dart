import 'dart:collection';

import 'package:flutter/foundation.dart' show setEquals;
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_filter_options.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

typedef SearchProductFilters = ({
  Set<String> categories,
  Set<String> priceRanges,
  ({
    String? categoryId,
    String? platform,
    (int?, int?) priceBounds,
    String quickFilter,
    bool unanalyzedOnly,
    bool missingPriceOnly,
    double? minimumRti,
    bool minimumReviews,
  })
  rules,
});

class SearchProductDerivation {
  final _categoryLabelCache = Expando<String>('categoryLabel');
  final _resolvedCategoryCache = Expando<bool>('resolvedCategory');
  Expando<bool> _inCategoryCache = Expando<bool>('inCategory');
  String? _matchingCategoryId;

  List<SearchResultProduct>? _source;
  SearchProductFilters? _lastFilters;
  List<SearchResultProduct> _filtered = const [];
  SearchSortOption? _lastSort;
  List<SearchResultProduct> _sorted = const [];

  List<SearchResultProduct> resolve(
    List<SearchResultProduct> products,
    SearchProductFilters filters,
    SearchSortOption sortOption,
  ) {
    final lastFilters = _lastFilters;
    if (!identical(_source, products) ||
        lastFilters == null ||
        lastFilters.rules != filters.rules ||
        !setEquals(lastFilters.categories, filters.categories) ||
        !setEquals(lastFilters.priceRanges, filters.priceRanges)) {
      _filtered = _filter(products, filters);
      _source = products;
      // The page updates its selections in place, so keep independent sets.
      _lastFilters = (
        categories: Set.of(filters.categories),
        priceRanges: Set.of(filters.priceRanges),
        rules: filters.rules,
      );
      _lastSort = null;
    }

    if (_lastSort != sortOption) {
      _sorted = _sort(_filtered, sortOption);
      _lastSort = sortOption;
    }
    return _sorted;
  }

  List<SearchResultProduct> _filter(
    List<SearchResultProduct> products,
    SearchProductFilters filters,
  ) {
    final (:categories, :priceRanges, :rules) = filters;
    final categoryId = rules.categoryId;
    if (_matchingCategoryId != categoryId) {
      _matchingCategoryId = categoryId;
      _inCategoryCache = Expando<bool>('inCategory');
    }
    final (minPrice, maxPrice) = rules.priceBounds;
    return List.unmodifiable(
      products.where((product) {
        if (categoryId != null &&
            hasResolvedCategory(product) &&
            !(_inCategoryCache[product] ??= isProductInCategory(
              categoryId,
              productCategory: product.category,
              productCategoryDisplayName: product.categoryDisplayName,
              productName: '',
            ))) {
          return false;
        }

        if (rules.platform != null &&
            product.normalizedPlatform != rules.platform) {
          return false;
        }
        if (rules.unanalyzedOnly &&
            (product.analysisDisplay.isV2 ||
                product.analysisDisplay.score != null)) {
          return false;
        }
        if (rules.missingPriceOnly && product.price != null) {
          return false;
        }

        if (categories.isNotEmpty &&
            !categories.contains(categoryLabel(product))) {
          return false;
        }

        if (priceRanges.isNotEmpty &&
            !priceRanges.any((range) => matchesPriceRange(product, range))) {
          return false;
        }

        final price = product.price;
        if (price == null && (minPrice != null || maxPrice != null)) {
          return false;
        }
        if (price != null &&
            ((minPrice != null && price < minPrice) ||
                (maxPrice != null && price > maxPrice))) {
          return false;
        }

        final minimumRti = rules.minimumRti;
        if (minimumRti != null &&
            (product.analysisDisplay.score == null ||
                product.analysisDisplay.score! < minimumRti)) {
          return false;
        }

        if (rules.minimumReviews &&
            (product.reviewCount == null || product.reviewCount! < 50)) {
          return false;
        }

        if (rules.quickFilter != '전체' &&
            !matchesQuickFilter(product, rules.quickFilter)) {
          return false;
        }

        return true;
      }),
    );
  }

  /// 정책 지수(v2)와 RTI(v0.5)는 척도가 달라 서로 비교하지 않는다.
  /// v2 그룹, v0.5 그룹, 점수 없음 순으로 두고 같은 그룹 안에서만 점수로 정렬한다.
  static int _compareAnalysisScore(
    SearchResultProduct a,
    SearchResultProduct b,
  ) {
    int group(SearchResultProduct product) {
      final display = product.analysisDisplay;
      if (display.score == null) return 2;
      return display.isV2 ? 0 : 1;
    }

    final byGroup = group(a).compareTo(group(b));
    if (byGroup != 0) return byGroup;
    return (b.analysisDisplay.score ?? -1).compareTo(
      a.analysisDisplay.score ?? -1,
    );
  }

  List<SearchResultProduct> _sort(
    List<SearchResultProduct> products,
    SearchSortOption sortOption,
  ) {
    final Comparator<SearchResultProduct>? compare = switch (sortOption) {
      SearchSortOption.accuracy => null,
      SearchSortOption.rti => _compareAnalysisScore,
      SearchSortOption.reviewCount || SearchSortOption.sales =>
        (a, b) => (b.reviewCount ?? -1).compareTo(a.reviewCount ?? -1),
      SearchSortOption.priceLow => (a, b) => _comparePrice(a.price, b.price),
      SearchSortOption.priceHigh => (a, b) => _comparePrice(
        a.price,
        b.price,
        descending: true,
      ),
      SearchSortOption.newest => (a, b) => 0,
    };
    if (compare == null) return products;
    final sorted = [...products]..sort(compare);
    return UnmodifiableListView(sorted);
  }

  bool matchesPriceRange(SearchResultProduct product, String label) {
    final (min, max) = searchPriceRanges[label]!;
    final price = product.price;
    return price != null &&
        (min == null || price >= min) &&
        (max == null || price <= max);
  }

  bool matchesQuickFilter(SearchResultProduct product, String label) {
    return switch (label) {
      '분석 전' =>
        !product.analysisDisplay.isV2 && product.analysisDisplay.score == null,
      'RTI 80+' =>
        !product.analysisDisplay.isV2 &&
            product.analysisDisplay.score != null &&
            product.analysisDisplay.score! >= 80,
      _ => categoryLabel(product) == label,
    };
  }

  String categoryLabel(SearchResultProduct product) =>
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

  bool hasResolvedCategory(SearchResultProduct product) =>
      _resolvedCategoryCache[product] ??= _computeHasResolvedCategory(product);

  bool _computeHasResolvedCategory(SearchResultProduct product) =>
      product.category.isNotEmpty &&
      resolveProductCategory(
            product.category,
            displayName: product.categoryDisplayName,
            productName: '',
          ) !=
          null;
}

int _comparePrice(int? a, int? b, {bool descending = false}) {
  if (a == null) return b == null ? 0 : 1;
  if (b == null) return -1;
  return descending ? b.compareTo(a) : a.compareTo(b);
}

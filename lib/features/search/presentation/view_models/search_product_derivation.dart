import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/models/search_filter_options.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

typedef SearchProductFilters = ({
  String? categoryId,
  String? platform,
  Set<String> categories,
  Set<String> priceRanges,
  (int?, int?) priceBounds,
  String quickFilter,
  bool unanalyzedOnly,
  bool missingPriceOnly,
  double? minimumRti,
  bool minimumReviews,
});

class SearchProductDerivation {
  final _categoryLabelCache = Expando<String>('categoryLabel');
  final _resolvedCategoryCache = Expando<bool>('resolvedCategory');
  Expando<bool> _inCategoryCache = Expando<bool>('inCategory');
  String? _matchingCategoryId;

  List<SearchResultProduct> filter(
    List<SearchResultProduct> products,
    SearchProductFilters filters,
  ) {
    final categoryId = filters.categoryId;
    if (_matchingCategoryId != categoryId) {
      _matchingCategoryId = categoryId;
      _inCategoryCache = Expando<bool>('inCategory');
    }
    final (minPrice, maxPrice) = filters.priceBounds;
    return products
        .where((product) {
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

          if (filters.platform != null &&
              product.normalizedPlatform != filters.platform) {
            return false;
          }
          if (filters.unanalyzedOnly &&
              (product.analysisDisplay.isV2 ||
                  product.analysisDisplay.score != null)) {
            return false;
          }
          if (filters.missingPriceOnly && product.price != null) {
            return false;
          }

          if (filters.categories.isNotEmpty &&
              !filters.categories.contains(categoryLabel(product))) {
            return false;
          }

          if (filters.priceRanges.isNotEmpty &&
              !filters.priceRanges.any(
                (range) => matchesPriceRange(product, range),
              )) {
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

          final minimumRti = filters.minimumRti;
          if (minimumRti != null &&
              (product.analysisDisplay.score == null ||
                  product.analysisDisplay.score! < minimumRti)) {
            return false;
          }

          if (filters.minimumReviews &&
              (product.reviewCount == null || product.reviewCount! < 50)) {
            return false;
          }

          if (filters.quickFilter != '전체' &&
              !matchesQuickFilter(product, filters.quickFilter)) {
            return false;
          }

          return true;
        })
        .toList(growable: false);
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

  List<SearchResultProduct> sort(
    List<SearchResultProduct> products,
    SearchSortOption sortOption,
  ) {
    final sorted = [...products];
    switch (sortOption) {
      case SearchSortOption.accuracy:
        return sorted;
      case SearchSortOption.rti:
        sorted.sort(_compareAnalysisScore);
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

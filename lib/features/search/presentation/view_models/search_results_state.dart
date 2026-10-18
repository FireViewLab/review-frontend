import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

enum SearchSortOption {
  accuracy(label: '추천순', serverKey: null),
  rti(label: 'RTI순', serverKey: 'RTI_DESC'),
  reviewCount(label: '리뷰 많은순', serverKey: 'REVIEW_COUNT_DESC'),
  sales(label: '판매 많은순', serverKey: 'SALES_DESC'),
  priceLow(label: '최저가순', serverKey: 'PRICE_ASC'),
  priceHigh(label: '높은 가격순', serverKey: 'PRICE_DESC'),
  newest(label: '신상품순', serverKey: 'NEWEST');

  const SearchSortOption({required this.label, required this.serverKey});

  final String label;
  final String? serverKey;
}

class SearchFilterChipData {
  const SearchFilterChipData({
    required this.label,
    required this.count,
    this.selected = false,
  });

  final String label;
  final int count;
  final bool selected;
}

class SearchResultsState {
  const SearchResultsState({
    required this.query,
    required this.products,
    this.sourceProducts = const [],
    required this.quickFilters,
    required this.categoryFilters,
    required this.priceRanges,
    this.totalCount,
    this.sortOption = SearchSortOption.accuracy,
    this.selectedRtiMinimum = 50,
    this.isLoading = false,
    this.isRtiFilterActive = false,
    this.errorMessage,
  });

  final String query;
  final List<SearchResultProduct> products;
  final List<SearchResultProduct> sourceProducts;
  final List<SearchFilterChipData> quickFilters;
  final List<SearchFilterChipData> categoryFilters;
  final List<SearchFilterChipData> priceRanges;
  final int? totalCount;
  final SearchSortOption sortOption;
  final int selectedRtiMinimum;
  final bool isLoading;
  final bool isRtiFilterActive;
  final String? errorMessage;

  int get displayTotalCount => totalCount ?? products.length;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => !isLoading && !hasError && products.isEmpty;
}

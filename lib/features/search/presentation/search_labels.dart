import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

String searchSortLabel(AppLocalizations l10n, SearchSortOption option) =>
    switch (option) {
      SearchSortOption.accuracy => l10n.searchSortAccuracy,
      SearchSortOption.rti => l10n.searchSortRti,
      SearchSortOption.reviewCount => l10n.searchSortReviewCount,
      SearchSortOption.sales => l10n.searchSortSales,
      SearchSortOption.priceLow => l10n.searchSortPriceLow,
      SearchSortOption.priceHigh => l10n.searchSortPriceHigh,
      SearchSortOption.newest => l10n.searchSortNewest,
    };

String searchQuickLabel(AppLocalizations l10n, String value) => switch (value) {
  '분류 정보 없음' => l10n.searchMissingClassification,
  '분석 전' => l10n.externalUnanalyzed,
  _ => value,
};

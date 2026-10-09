import 'external_product.dart';
import 'external_product_ref.dart';

/// Known public product information, independent of collection readiness.
class ProductSummary {
  const ProductSummary({
    required this.product,
    this.springProductId,
    this.catalogAnalysis,
    this.observedAt,
    this.source = ProductSummarySource.list,
  });
  final ExternalProduct product;
  final ProductCatalogAnalysis? catalogAnalysis;
  final int? springProductId;
  final DateTime? observedAt;
  final ProductSummarySource source;

  bool matches(ExternalProductRef target) => product.ref == target;
  int? get verifiedNumericId {
    final id = springProductId;
    return id != null && id > 0 && id <= 9007199254740991 ? id : null;
  }
}

enum ProductSummarySource { list, previousDetail }

/// Public summaries only; no reviews, account data or persistent storage.
class ProductSummaryCache {
  static const _ttl = Duration(minutes: 5);
  static const _capacity = 32;
  final _entries = <ExternalProductRef, (ProductSummary, DateTime)>{};
  void remember(ProductSummary summary) {
    final now = DateTime.now();
    final observed = summary.observedAt;
    if (observed != null && now.difference(observed) >= _ttl) return;
    _entries.removeWhere((_, value) => now.difference(value.$2) >= _ttl);
    _entries.remove(summary.product.ref);
    _entries[summary.product.ref] = (summary, now);
    while (_entries.length > _capacity) {
      _entries.remove(_entries.keys.first);
    }
  }

  ProductSummary? get(ExternalProductRef target) {
    final entry = _entries[target];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.$2) >= _ttl) {
      _entries.remove(target);
      return null;
    }
    return entry.$1;
  }
}

/// Aggregate supplied by the catalog API, independent of a v2 review page.
class ProductCatalogAnalysis {
  const ProductCatalogAnalysis({
    required this.averageRti,
    required this.observedAt,
    this.sampled,
    this.reviewCount,
    this.sourceReviewCount,
  });
  final double averageRti;
  final DateTime observedAt;
  final bool? sampled;
  final int? reviewCount;
  final int? sourceReviewCount;
  bool get isCurrent =>
      DateTime.now().difference(observedAt) < const Duration(minutes: 5);
}

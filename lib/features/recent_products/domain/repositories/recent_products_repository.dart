import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';

abstract interface class RecentProductsRepository {
  /// Authenticated dashboard recent history, not public catalog recommendations.
  Future<Result<List<SearchResultProduct>>> getRecentProducts();
}

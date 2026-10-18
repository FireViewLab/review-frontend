import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

abstract interface class ExternalProductRepository {
  /// [cursor]를 주면 그 뒤의 리뷰 페이지를 받는다.
  Future<Result<ExternalProductSnapshot>> getProduct(
    ExternalProductRef ref, {
    String? cursor,
  });

  Future<Result<CollectionJob>> getJob(int jobId);
}

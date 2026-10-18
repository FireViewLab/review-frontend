import 'dart:async';

import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_product_repository.dart';

const kurlyRef = ExternalProductRef(platform: 'kurly', productId: '1000146248');

const kurlyProduct = ExternalProduct(
  ref: kurlyRef,
  name: '다이브인 마스크팩',
  url: 'https://www.kurly.com/goods/1000146248',
  brand: '토리든',
  price: 17000,
  category: '뷰티 > 마스크/팩',
  reviewCount: 1318,
);

ExternalReview reviewOf(String id) =>
    ExternalReview(reviewId: id, content: '리뷰 $id', author: '김**');

ExternalProductSnapshot readyOf({
  CollectionStatus status = CollectionStatus.fresh,
  List<ExternalReview>? reviews,
  String? nextCursor,
}) => ExternalProductSnapshot(
  status: status,
  product: kurlyProduct,
  reviews: reviews ?? [reviewOf('1'), reviewOf('2')],
  nextCursor: nextCursor,
);

const queued = ExternalProductSnapshot(
  status: CollectionStatus.queued,
  job: CollectionJob(id: 9, status: CollectionJobStatus.pending),
);

const failure = FailureResult<ExternalProductSnapshot>(
  Failure(message: '오류', statusCode: 500),
);

class FakeExternalProductRepository implements ExternalProductRepository {
  /// 호출할 때마다 앞에서부터 하나씩 돌려준다. 마지막 값은 계속 쓴다.
  List<Result<ExternalProductSnapshot>> products = [Success(readyOf())];
  List<Result<CollectionJob>> jobs = [];
  Completer<Result<ExternalProductSnapshot>>? pendingProduct;
  final List<String?> cursors = [];
  final List<int> jobRequests = [];
  int _productCalls = 0;
  int _jobCalls = 0;

  @override
  Future<Result<ExternalProductSnapshot>> getProduct(
    ExternalProductRef ref, {
    String? cursor,
  }) async {
    cursors.add(cursor);
    final pending = pendingProduct;
    if (pending != null) return pending.future;
    final index = _productCalls++;
    return products[index < products.length ? index : products.length - 1];
  }

  @override
  Future<Result<CollectionJob>> getJob(int jobId) async {
    jobRequests.add(jobId);
    final index = _jobCalls++;
    return jobs[index < jobs.length ? index : jobs.length - 1];
  }
}

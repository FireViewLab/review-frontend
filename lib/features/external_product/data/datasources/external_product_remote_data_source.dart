import 'package:re_view_front/core/utils/product_image_urls.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

abstract interface class ExternalProductRemoteDataSource {
  Future<ExternalProductSnapshot> getProduct(
    ExternalProductRef ref, {
    String? cursor,
  });
  Future<CollectionJob> getJob(int jobId);
}

class ExternalProductRemoteDataSourceImpl
    implements ExternalProductRemoteDataSource {
  const ExternalProductRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const _basePath = '/api/v2/products';

  @override
  Future<ExternalProductSnapshot> getProduct(
    ExternalProductRef ref, {
    String? cursor,
  }) async {
    final response = await _apiClient.get(
      '$_basePath/${Uri.encodeComponent(ref.platform)}'
      '/${Uri.encodeComponent(ref.productId)}',
      queryParameters: {'cursor': ?cursor},
    );
    final body = _requireMap(response.data);
    final product = body['product'];
    final reviews = body['reviews'];
    final job = body['job'];
    final items = reviews is Map<String, dynamic> ? reviews['items'] : null;

    return ExternalProductSnapshot(
      status: _status(body['collectionStatus'], hasProduct: product is Map),
      product: product is Map<String, dynamic> ? _product(product, ref) : null,
      reviews: [
        if (items is List)
          for (final item in items)
            if (item is Map<String, dynamic> && item['reviewId'] != null)
              _review(item),
      ],
      nextCursor: reviews is Map<String, dynamic>
          ? _text(reviews['nextCursor'])
          : null,
      job: job is Map<String, dynamic> ? _job(job) : null,
      springProductId: (body['springProductId'] as num?)?.toInt(),
      hasAnalysis: body['analysis'] != null,
    );
  }

  @override
  Future<CollectionJob> getJob(int jobId) async {
    final response = await _apiClient.get('$_basePath/collection-jobs/$jobId');
    final job = _job(_requireMap(response.data));
    if (job == null) throw const FormatException('Invalid collection job');
    return job;
  }

  Map<String, dynamic> _requireMap(Object? data) {
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) return body;
    }
    throw const FormatException('Invalid external product response');
  }

  /// 모르는 상태 값이 와도 상품이 있으면 보여 주고, 없으면 가져오지 못한 것으로 본다.
  CollectionStatus _status(Object? value, {required bool hasProduct}) {
    return switch (value?.toString().toUpperCase()) {
      'FRESH' => CollectionStatus.fresh,
      'STALE' => CollectionStatus.stale,
      'QUEUED' => CollectionStatus.queued,
      'UNAVAILABLE' => CollectionStatus.unavailable,
      _ => hasProduct ? CollectionStatus.fresh : CollectionStatus.unavailable,
    };
  }

  ExternalProduct _product(Map<String, dynamic> json, ExternalProductRef ref) {
    return ExternalProduct(
      ref: ref,
      name: _text(json['name']) ?? '',
      url: _text(json['url']),
      brand: _text(json['brand']),
      seller: _text(json['seller']),
      price: (json['price'] as num?)?.toInt(),
      thumbnailUrl: _text(json['thumbnailUrl']),
      imageUrls: readProductImages(json),
      category: _text(json['category']),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      lastCollectedAt: DateTime.tryParse(_text(json['lastCollectedAt']) ?? ''),
    );
  }

  ExternalReview _review(Map<String, dynamic> json) {
    final images = json['images'];
    return ExternalReview(
      reviewId: json['reviewId'].toString(),
      content: _text(json['content']) ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      author: _text(json['author']),
      writtenAt: DateTime.tryParse(_text(json['writtenAt']) ?? ''),
      option: _text(json['option']),
      images: [
        if (images is List)
          for (final image in images)
            if (image is String && image.isNotEmpty) image,
      ],
      helpfulCount: (json['helpfulCount'] as num?)?.toInt(),
    );
  }

  CollectionJob? _job(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! num) return null;
    return CollectionJob(
      id: id.toInt(),
      status: switch (json['status']?.toString().toLowerCase()) {
        'succeeded' => CollectionJobStatus.succeeded,
        'partial' => CollectionJobStatus.partial,
        'failed' => CollectionJobStatus.failed,
        // pending, running 등 끝나지 않은 상태는 모두 계속 기다린다.
        _ => CollectionJobStatus.pending,
      },
      lastError: _text(json['lastError']),
    );
  }

  String? _text(Object? value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }
}

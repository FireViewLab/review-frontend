import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

/// 서버가 알려 주는 수집 상태. 네 가지 모두 HTTP 200으로 온다.
enum CollectionStatus {
  /// 최신 데이터.
  fresh,

  /// 오래됐지만 쓸 수 있는 데이터. 실패가 아니다.
  stale,

  /// 처음 보는 상품이라 지금 수집 중이다. 상품 정보가 아직 없다.
  queued,

  /// 상품이 없는 게 아니라 가져오지 못했다.
  unavailable,
}

/// 수집 작업의 진행 상태.
enum CollectionJobStatus {
  pending,
  succeeded,

  /// 상품은 수집했고 리뷰는 실패했다. 상품은 보여 줄 수 있다.
  partial,
  failed,
}

class CollectionJob {
  const CollectionJob({required this.id, required this.status, this.lastError});

  final int id;
  final CollectionJobStatus status;
  final String? lastError;

  /// 수집이 끝나 상품을 다시 조회해도 되는지.
  bool get isFinished =>
      status == CollectionJobStatus.succeeded ||
      status == CollectionJobStatus.partial;
}

/// Data 서버가 수집한 쇼핑몰 상품. 수집기가 채우지 못한 값은 null이다.
class ExternalProduct {
  const ExternalProduct({
    required this.ref,
    required this.name,
    this.url,
    this.brand,
    this.seller,
    this.price,
    this.thumbnailUrl,
    this.category,
    this.reviewCount,
    this.rating,
    this.lastCollectedAt,
  });

  final ExternalProductRef ref;
  final String name;
  final String? url;
  final String? brand;
  final String? seller;
  final int? price;
  final String? thumbnailUrl;
  final String? category;
  final int? reviewCount;

  /// 평균 별점. 쇼핑몰에 따라 수집되지 않는다.
  final double? rating;
  final DateTime? lastCollectedAt;
}

class ExternalReview {
  const ExternalReview({
    required this.reviewId,
    required this.content,
    this.rating,
    this.author,
    this.writtenAt,
    this.option,
    this.images = const [],
    this.helpfulCount = 0,
  });

  /// 쇼핑몰이 발급한 리뷰 번호. 숫자처럼 보여도 문자열이다.
  final String reviewId;
  final String content;
  final double? rating;
  final String? author;
  final DateTime? writtenAt;
  final String? option;
  final List<String> images;
  final int helpfulCount;
}

/// 상품 상세 조회 한 번의 결과.
class ExternalProductSnapshot {
  const ExternalProductSnapshot({
    required this.status,
    this.product,
    this.reviews = const [],
    this.nextCursor,
    this.job,
    this.springProductId,
    this.hasAnalysis = false,
  });

  final CollectionStatus status;

  /// [CollectionStatus.queued]·[CollectionStatus.unavailable]이면 null이다.
  final ExternalProduct? product;
  final List<ExternalReview> reviews;

  /// 다음 리뷰 페이지를 가리키는 값. null이면 마지막 페이지다.
  final String? nextCursor;
  final CollectionJob? job;

  /// 찜·장바구니 API가 받는 번호. 아직 발급되지 않았으면 null이다.
  final int? springProductId;

  /// 신뢰도 분석 결과가 왔는지. 아직 어떤 상품에도 오지 않는다.
  final bool hasAnalysis;
}

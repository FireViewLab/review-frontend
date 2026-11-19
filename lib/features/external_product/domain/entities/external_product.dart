import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/core/utils/product_image_urls.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

/// 서버가 알려 주는 수집 상태. 알 수 없는 값은 원문과 함께 보관한다.
enum CollectionStatus {
  fresh,
  stale,
  queued,
  running,
  done,
  failed,
  disabled,
  unavailable,
  unknown;

  static CollectionStatus parse(String? value) =>
      switch (value?.toUpperCase()) {
        'FRESH' => fresh,
        'STALE' => stale,
        'QUEUED' || 'PENDING' => queued,
        'RUNNING' => running,
        'DONE' => done,
        'FAILED' => failed,
        'DISABLED' => disabled,
        'UNAVAILABLE' => unavailable,
        _ => unknown,
      };

  bool get isActive => this == queued || this == running;
  bool get isTerminal => this != unknown && !isActive;
}

enum ExternalAnalysisStatus {
  pending,
  running,
  done,
  failed,
  disabled,
  unavailable,
  unknown;

  static ExternalAnalysisStatus parse(String? value) =>
      switch (value?.toUpperCase()) {
        'PENDING' || 'QUEUED' => pending,
        'RUNNING' => running,
        'DONE' => done,
        'FAILED' => failed,
        'DISABLED' => disabled,
        'UNAVAILABLE' => unavailable,
        _ => unknown,
      };

  bool get isActive => this == pending || this == running;
  bool get isTerminal => this != unknown && !isActive;
}

/// 수집 작업 및 상품·리뷰 단계의 진행 상태.
enum CollectionJobStatus {
  pending,
  queued,
  running,
  succeeded,
  done,
  partial,
  failed,
  disabled,
  unknown;

  static CollectionJobStatus parse(String? value) =>
      switch (value?.toUpperCase()) {
        'PENDING' => pending,
        'QUEUED' => queued,
        'RUNNING' => running,
        'SUCCEEDED' => succeeded,
        'DONE' => done,
        'PARTIAL' => partial,
        'FAILED' => failed,
        'DISABLED' => disabled,
        _ => unknown,
      };

  bool get isActive => this == pending || this == queued || this == running;
  bool get isTerminal => this != unknown && !isActive;
}

class CollectionJob {
  const CollectionJob({
    required this.id,
    required this.status,
    this.rawStatus,
    this.productStatus,
    this.reviewStatus,
    this.lastError,
  });

  final int id;
  final CollectionJobStatus status;
  final String? rawStatus;
  String get statusValue => rawStatus ?? status.name.toUpperCase();
  final String? productStatus;
  final String? reviewStatus;
  final String? lastError;

  CollectionJobStatus get productState =>
      CollectionJobStatus.parse(productStatus);
  CollectionJobStatus get reviewState =>
      CollectionJobStatus.parse(reviewStatus);
  bool get isActive =>
      status.isActive || productState.isActive || reviewState.isActive;
  bool get isTerminal => status.isTerminal && !isActive;

  /// 수집이 끝나 상품을 다시 조회해도 되는지.
  bool get isFinished =>
      !isActive &&
      (status == CollectionJobStatus.succeeded ||
          status == CollectionJobStatus.done ||
          status == CollectionJobStatus.partial);
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
    this.imageUrls = const [],
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
  final List<String> imageUrls;
  List<String> get galleryImages =>
      productImageUrls(primary: thumbnailUrl, additional: imageUrls);
  final String? category;
  final int? reviewCount;

  /// 평균 별점. 쇼핑몰에 따라 수집되지 않는다.
  final double? rating;
  final DateTime? lastCollectedAt;
}

class ExternalReview {
  const ExternalReview({
    this.analysis,
    required this.reviewId,
    required this.content,
    this.rating,
    this.author,
    this.writtenAt,
    this.option,
    this.images = const [],
    this.helpfulCount,
    this.rti,
    this.level,
    this.reasons = const [],
  });

  final AnalysisDisplay? analysis;
  AnalysisDisplay get analysisDisplay =>
      analysis ?? AnalysisDisplay(score: rti, level: level, reasons: reasons);

  /// 쇼핑몰이 발급한 리뷰 번호. 숫자처럼 보여도 문자열이다.
  final String reviewId;
  final String content;
  final double? rating;
  final String? author;
  final DateTime? writtenAt;
  final String? option;
  final List<String> images;
  final int? helpfulCount;
  final double? rti;
  final String? level;
  final List<String> reasons;
}

/// 상품 상세 조회 한 번의 결과.
class ExternalProductSnapshot {
  const ExternalProductSnapshot({
    required this.status,
    this.rawCollectionStatus,
    this.product,
    this.reviews = const [],
    this.nextCursor,
    this.job,
    this.springProductId,
    this.hasAnalysis = false,
    this.analysisStatus = 'UNAVAILABLE',
    this.analysis,
  });

  final CollectionStatus status;
  final String? rawCollectionStatus;
  String get collectionStatus =>
      rawCollectionStatus ?? status.name.toUpperCase();
  ExternalAnalysisStatus get analysisState =>
      ExternalAnalysisStatus.parse(analysisStatus);

  /// [CollectionStatus.queued]·[CollectionStatus.unavailable]이면 null이다.
  final ExternalProduct? product;
  final List<ExternalReview> reviews;

  /// 다음 리뷰 페이지를 가리키는 값. null이면 마지막 페이지다.
  final String? nextCursor;
  final CollectionJob? job;

  /// 찜·장바구니 API가 받는 번호. 아직 발급되지 않았으면 null이다.
  final int? springProductId;

  final String analysisStatus;
  final ExternalAnalysis? analysis;

  /// 서버가 결과 메타정보를 제공했는지.
  final bool hasAnalysis;
}

/// v2 응답의 분석 메타정보. 페이지 리뷰 평균을 상품 평균으로 만들지 않는다.
class ExternalAnalysis {
  const ExternalAnalysis({
    this.status,
    this.display,
    this.modelVersion,
    this.policyVersion,
    this.reviewCount,
    this.sampled,
    this.sourceReviewCount,
  });
  final String? status;
  final AnalysisDisplay? display;
  final String? modelVersion;
  final String? policyVersion;
  final int? reviewCount;
  final bool? sampled;
  final int? sourceReviewCount;
}

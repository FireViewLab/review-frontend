import 'package:re_view_front/features/external_product/domain/entities/product_summary.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';

enum ExternalProductPhase {
  loading,

  /// 처음 보는 상품이라 서버가 수집하는 중이다.
  collecting,
  ready,

  /// 수집에 실패했거나 서버가 가져오지 못했다.
  unavailable,

  /// 요청 자체가 실패했다.
  failure,
}

class ExternalProductState {
  const ExternalProductState({
    this.phase = ExternalProductPhase.loading,
    this.product,
    this.summary,
    this.isStale = false,
    this.hasAnalysis = false,
    this.analysisStatus = 'UNAVAILABLE',
    this.analysis,
    this.springProductId,
    this.reviews = const [],
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.isSlow = false,
    this.collectionError,
  });

  final ExternalProductPhase phase;
  final ExternalProduct? product;
  final ProductSummary? summary;
  ExternalProduct? get displayProduct => product ?? summary?.product;
  int? get displayNumericId => springProductId ?? summary?.verifiedNumericId;

  /// 오래된 데이터라 서버가 다시 수집하는 중이다. 화면은 그대로 보여 준다.
  final bool isStale;
  final bool hasAnalysis;
  final String analysisStatus;
  final ExternalAnalysis? analysis;
  final int? springProductId;
  final List<ExternalReview> reviews;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  /// 수집이 예상보다 오래 걸리고 있다.
  final bool isSlow;

  /// 수집 실패 시 서버가 알려 준 사유.
  final String? collectionError;

  bool get hasMoreReviews => nextCursor != null;

  ExternalProductState copyWith({
    ExternalProductPhase? phase,
    ProductSummary? summary,
    bool? hasAnalysis,
    String? analysisStatus,
    ExternalAnalysis? analysis,
    bool clearAnalysis = false,
    String? collectionError,
    bool clearCollectionError = false,
    List<ExternalReview>? reviews,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    bool? isSlow,
  }) {
    return ExternalProductState(
      phase: phase ?? this.phase,
      product: product,
      summary: summary ?? this.summary,
      isStale: isStale,
      hasAnalysis: hasAnalysis ?? this.hasAnalysis,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      analysis: clearAnalysis ? null : (analysis ?? this.analysis),
      springProductId: springProductId,
      reviews: reviews ?? this.reviews,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      isSlow: isSlow ?? this.isSlow,
      collectionError: clearCollectionError
          ? null
          : (collectionError ?? this.collectionError),
    );
  }
}

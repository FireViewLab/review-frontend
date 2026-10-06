import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/entities/similar_product.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailSuccess extends ProductDetailState {
  const ProductDetailSuccess({
    required this.detail,
    required this.reviews,
    required this.reviewInsight,
    required this.similarProducts,
    this.isAnalyzing = false,
    this.safeCount = 0,
    this.warnCount = 0,
    this.dangerCount = 0,
    this.trend = const [],
  });

  final ProductDetail detail;
  final List<ProductReview> reviews;
  final ReviewInsight reviewInsight;
  final List<SimilarProduct> similarProducts;
  final bool isAnalyzing;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<AnalysisTrendPoint> trend;

  ProductDetailSuccess copyWith({
    List<ProductReview>? reviews,
    bool? isAnalyzing,
    int? safeCount,
    int? warnCount,
    int? dangerCount,
    List<AnalysisTrendPoint>? trend,
    RtiSummary? rtiSummary,
    List<TrustSignal>? trustSignals,
  }) {
    final updatedDetail = (rtiSummary != null || trustSignals != null)
        ? ProductDetail(
            externalId: detail.externalId,
            dataPlatform: detail.dataPlatform,
            dataProductId: detail.dataProductId,
            subCategory: detail.subCategory,
            id: detail.id,
            name: detail.name,
            brand: detail.brand,
            sellerName: detail.sellerName,
            isOfficialSeller: detail.isOfficialSeller,
            imageUrls: detail.imageUrls,
            price: detail.price,
            deliveryInfo: detail.deliveryInfo,
            category: detail.category,
            categoryDisplayName: detail.categoryDisplayName,
            breadcrumbs: detail.breadcrumbs,
            avgRating: detail.avgRating,
            reviewCount: detail.reviewCount,
            qaCount: detail.qaCount,
            avgRti: detail.avgRti,
            rtiGrade: detail.rtiGrade,
            rtiColor: detail.rtiColor,
            specChips: detail.specChips,
            priceComparisons: detail.priceComparisons,
            totalSellerCount: detail.totalSellerCount,
            rtiSummary: rtiSummary ?? detail.rtiSummary,
            trustSignals: trustSignals ?? detail.trustSignals,
          )
        : detail;
    return ProductDetailSuccess(
      detail: updatedDetail,
      reviews: reviews ?? this.reviews,
      reviewInsight: reviewInsight,
      similarProducts: similarProducts,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      safeCount: safeCount ?? this.safeCount,
      warnCount: warnCount ?? this.warnCount,
      dangerCount: dangerCount ?? this.dangerCount,
      trend: trend ?? this.trend,
    );
  }
}

class ProductDetailFailure extends ProductDetailState {
  const ProductDetailFailure(this.failure);

  final Failure failure;
}

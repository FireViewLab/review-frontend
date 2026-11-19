import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class DashboardProduct {
  const DashboardProduct({
    this.analysis,
    required this.id,
    required this.name,
    required this.storeName,
    required this.price,
    required this.imageUrl,
    this.label,
    this.rating,
    this.reviewCount,
    this.rtiScore,
    this.summary,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  final AnalysisDisplay? analysis;
  AnalysisDisplay get analysisDisplay =>
      analysis ?? AnalysisDisplay(score: rtiScore?.toDouble(), level: null);

  final ProductSummary? summary;
  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;
  ExternalProductRef? get externalRef => ExternalProductRef.resolve(
    dataPlatform: dataPlatform,
    dataProductId: dataProductId,
    externalId: externalId,
  );
  String get detailPath => externalRef?.routePath ?? '/product/$id';
  String? get chatProductId => (externalId?.trim().isNotEmpty ?? false)
      ? externalId
      : externalRef?.externalId;
  ProductRouteContext get routeContext =>
      ProductRouteContext(chatProductId: chatProductId, summary: summary);

  /// 쇼핑몰 리뷰 수나 분석에 쓴 리뷰 수 중 하나라도 있으면 리뷰가 있는 상품이다.
  bool get hasReviews =>
      (reviewCount ?? 0) > 0 ||
      (summary?.catalogAnalysis?.reviewCount ?? 0) > 0;

  final String id;
  final String name;
  final String storeName;
  final int price;
  final String imageUrl;
  final String? label;
  final double? rating;
  final int? reviewCount;
  final int? rtiScore;
}

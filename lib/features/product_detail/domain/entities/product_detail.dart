import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class ProductDetail {
  const ProductDetail({
    required this.id,
    required this.name,
    required this.brand,
    this.sellerName,
    required this.isOfficialSeller,
    required this.imageUrls,
    required this.price,
    this.deliveryInfo,
    required this.category,
    required this.categoryDisplayName,
    required this.breadcrumbs,
    required this.avgRating,
    required this.reviewCount,
    required this.qaCount,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.specChips,
    required this.priceComparisons,
    required this.totalSellerCount,
    required this.rtiSummary,
    required this.trustSignals,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

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
      ProductRouteContext(chatProductId: chatProductId);

  final int id;
  final String name;
  final String brand;
  final String? sellerName;
  final bool isOfficialSeller;
  final List<String> imageUrls;
  final int price;
  final String? deliveryInfo;
  final String category;
  final String categoryDisplayName;
  final List<String> breadcrumbs;
  final double? avgRating;
  final int? reviewCount;
  final int qaCount;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final List<ProductSpecChip> specChips;
  final List<PriceComparison> priceComparisons;
  final int totalSellerCount;
  final RtiSummary? rtiSummary;
  final List<TrustSignal> trustSignals;
}

class ProductSpecChip {
  const ProductSpecChip({
    required this.label,
    required this.subtitle,
    required this.iconData,
  });

  final String label;
  final String subtitle;
  final String iconData;
}

class PriceComparison {
  const PriceComparison({
    required this.sellerName,
    required this.sellerLogoTag,
    required this.price,
    required this.deliveryInfo,
    required this.isLowest,
    required this.isOfficial,
    required this.linkLabel,
    this.url,
  });

  final String sellerName;
  final String sellerLogoTag;
  final int price;
  final String deliveryInfo;
  final bool isLowest;
  final bool isOfficial;
  final String linkLabel;
  final String? url;
}

class RtiSummary {
  const RtiSummary({
    this.hasReviewMetrics = true,
    required this.rtiScore,
    required this.rtiLabel,
    required this.rtiSubLabel,
    required this.realReviewRatio,
    required this.realReviewLabel,
    required this.adSuspicionRatio,
    required this.adSuspicionLabel,
    required this.repetitionRatio,
    required this.repetitionLabel,
    required this.summaryMessage,
    required this.analyzedReviewCount,
  });

  final bool hasReviewMetrics;
  final int rtiScore;
  final String rtiLabel;
  final String rtiSubLabel;
  final double realReviewRatio;
  final String realReviewLabel;
  final double adSuspicionRatio;
  final String adSuspicionLabel;
  final double repetitionRatio;
  final String repetitionLabel;
  final String summaryMessage;
  final int analyzedReviewCount;

  RtiSummary copyWith({
    bool? hasReviewMetrics,
    double? realReviewRatio,
    String? realReviewLabel,
    double? adSuspicionRatio,
    String? adSuspicionLabel,
    double? repetitionRatio,
    String? repetitionLabel,
  }) {
    return RtiSummary(
      hasReviewMetrics: hasReviewMetrics ?? this.hasReviewMetrics,
      rtiScore: rtiScore,
      rtiLabel: rtiLabel,
      rtiSubLabel: rtiSubLabel,
      realReviewRatio: realReviewRatio ?? this.realReviewRatio,
      realReviewLabel: realReviewLabel ?? this.realReviewLabel,
      adSuspicionRatio: adSuspicionRatio ?? this.adSuspicionRatio,
      adSuspicionLabel: adSuspicionLabel ?? this.adSuspicionLabel,
      repetitionRatio: repetitionRatio ?? this.repetitionRatio,
      repetitionLabel: repetitionLabel ?? this.repetitionLabel,
      summaryMessage: summaryMessage,
      analyzedReviewCount: analyzedReviewCount,
    );
  }
}

class TrustSignal {
  const TrustSignal({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  final String label;
  final String value;
  final bool isPositive;
}

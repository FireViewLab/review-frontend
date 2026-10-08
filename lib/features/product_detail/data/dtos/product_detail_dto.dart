import 'package:re_view_front/features/external_product/data/dtos/product_summary_dto.dart';
import 'package:re_view_front/features/external_product/domain/entities/product_summary.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';

class ProductDetailDto {
  const ProductDetailDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.categoryDisplayName,
    required this.platform,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.reviewCount,
    required this.avgRating,
    required this.lowestPrice,
    required this.lowestPlatform,
    required this.platforms,
    this.summary,
    this.externalId,
    this.dataPlatform,
    this.dataProductId,
    this.subCategory,
  });

  final ProductSummary? summary;
  final String? externalId;
  final String? dataPlatform;
  final String? dataProductId;
  final String? subCategory;

  final int id;
  final String name;
  final String? imageUrl;
  final int price;
  final String category;
  final String categoryDisplayName;
  final String? platform;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int? reviewCount;
  final double? avgRating;
  final int? lowestPrice;
  final String? lowestPlatform;
  final List<PlatformEntry> platforms;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) {
    final rawPlatforms = json['platforms'] as List? ?? [];
    return ProductDetailDto(
      summary: ProductSummaryDto.fromJson(json),
      externalId: json['externalId'] as String?,
      dataPlatform: json['dataPlatform'] as String?,
      dataProductId: json['dataProductId']?.toString(),
      subCategory: json['subCategory'] as String?,
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? json['title']) as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] ?? json['lowestPrice'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      categoryDisplayName: json['categoryDisplayName'] as String? ?? '',
      platform: json['platform'] as String?,
      avgRti: (json['avgRti'] as num?)?.toDouble(),
      rtiGrade: json['rtiGrade'] as String?,
      rtiColor: json['rtiColor'] as String?,
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      avgRating: (json['avgRating'] as num?)?.toDouble(),
      lowestPrice: (json['lowestPrice'] as num?)?.toInt(),
      lowestPlatform: json['lowestPlatform'] as String?,
      platforms: rawPlatforms
          .map((e) => PlatformEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ProductDetail toEntity() {
    final comparisons = _buildPriceComparisons();
    final normalizedDisplayName =
        subCategory ??
        (category.isEmpty
            ? categoryDisplayName
            : normalizedCategoryLabel(
                category: category,
                categoryDisplayName: categoryDisplayName,
                productName: name,
              ));
    return ProductDetail(
      summary: summary,
      externalId: externalId,
      dataPlatform: dataPlatform,
      dataProductId: dataProductId,
      subCategory: subCategory,
      id: id,
      name: name,
      brand: '',
      sellerName: platform,
      isOfficialSeller: false,
      imageUrls: imageUrl != null ? [imageUrl!] : [],
      price: lowestPrice ?? price,
      deliveryInfo: null,
      category: category,
      categoryDisplayName: normalizedDisplayName,
      breadcrumbs: _deriveBreadcrumbs(),
      avgRating: avgRating,
      reviewCount: reviewCount,
      qaCount: 0,
      avgRti: avgRti,
      rtiGrade: rtiGrade,
      rtiColor: rtiColor,
      specChips: const [],
      priceComparisons: comparisons,
      totalSellerCount: comparisons.length,
      rtiSummary: _deriveRtiSummary(),
      trustSignals: const [],
    );
  }

  List<PriceComparison> _buildPriceComparisons() {
    if (platforms.isEmpty) return const [];
    final sorted = [...platforms]..sort((a, b) => a.price.compareTo(b.price));
    return sorted.map((p) {
      final tag = p.platform.toLowerCase().replaceAll(' ', '');
      return PriceComparison(
        sellerName: _platformDisplayName(p.platform),
        sellerLogoTag: tag,
        price: p.price,
        deliveryInfo: _deliveryInfo(p.platform),
        isLowest: lowestPlatform != null
            ? p.platform.toUpperCase() == lowestPlatform!.toUpperCase()
            : p.price == sorted.first.price,
        isOfficial: false,
        linkLabel: '구매하기',
        url: p.url,
      );
    }).toList();
  }

  static String _platformDisplayName(String platform) =>
      switch (platform.toUpperCase()) {
        'NAVER' => '네이버',
        'COUPANG' => '쿠팡',
        '11ST' => '11번가',
        'GMARKET' => 'G마켓',
        'AUCTION' => '옥션',
        'LOTTE' => '롯데온',
        'SSG' => 'SSG닷컴',
        'KAKAO' => '카카오',
        _ => platform,
      };

  static String _deliveryInfo(String platform) =>
      switch (platform.toUpperCase()) {
        'COUPANG' => '로켓배송',
        'NAVER' => '네이버배송',
        '11ST' => '일반배송',
        _ => '배송정보 확인',
      };

  List<String> _deriveBreadcrumbs() {
    final normalizedDisplayName =
        subCategory ??
        (category.isEmpty
            ? categoryDisplayName
            : normalizedCategoryLabel(
                category: category,
                categoryDisplayName: categoryDisplayName,
                productName: name,
              ));
    return [
      if (normalizedDisplayName.isNotEmpty) normalizedDisplayName,
      if (name.isNotEmpty) name,
    ];
  }

  RtiSummary? _deriveRtiSummary() {
    if (avgRti == null) return null;
    final label = rtiGrade == null ? '' : _gradeLabel(rtiGrade!);
    return RtiSummary(
      hasReviewMetrics: false,
      rtiScore: avgRti!.round(),
      rtiLabel: label,
      rtiSubLabel: 'AI 분석 결과',
      realReviewRatio: 0.0,
      realReviewLabel: '집계 중',
      adSuspicionRatio: 0.0,
      adSuspicionLabel: '집계 중',
      repetitionRatio: 0.0,
      repetitionLabel: '집계 중',
      summaryMessage: '$reviewCount개 리뷰 기반 RTI 분석 결과입니다.',
      analyzedReviewCount: reviewCount ?? 0,
    );
  }

  static String _gradeLabel(String grade) => switch (grade) {
    'SAFE' => '안전',
    'SUSPICIOUS' => '의심',
    'DANGER' => '위험',
    _ => grade,
  };
}

class PlatformEntry {
  const PlatformEntry({
    required this.platform,
    required this.price,
    required this.url,
  });

  final String platform;
  final int price;
  final String url;

  factory PlatformEntry.fromJson(Map<String, dynamic> json) {
    return PlatformEntry(
      platform: json['platform'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      url: json['url'] as String? ?? '',
    );
  }
}

class ProductReviewDto {
  const ProductReviewDto({
    this.helpfulCount,
    this.imageUrls = const [],
    required this.id,
    required this.reviewerNickname,
    required this.content,
    required this.rating,
    required this.rtiScore,
    required this.trustGrade,
    required this.trustGradeLabel,
    required this.trustGradeColor,
    required this.reasons,
    required this.writtenAt,
    required this.isVerifiedPurchase,
  });

  final int? helpfulCount;
  final List<String> imageUrls;
  final int id;
  final String reviewerNickname;
  final String content;
  final double rating;
  final int? rtiScore;
  final String? trustGrade;
  final String? trustGradeLabel;
  final String? trustGradeColor;
  final List<String> reasons;
  final String writtenAt;
  final bool isVerifiedPurchase;

  factory ProductReviewDto.fromJson(Map<String, dynamic> json) {
    final images = json['imageUrls'] ?? json['images'];
    return ProductReviewDto(
      helpfulCount: (json['helpfulCount'] as num?)?.toInt(),
      imageUrls: [
        if (images is List)
          for (final image in images)
            if (image is String && image.trim().isNotEmpty) image.trim(),
      ],
      id: (json['id'] as num).toInt(),
      reviewerNickname:
          (json['reviewerNickname'] ?? json['authorName']) as String? ?? '',
      content: json['content'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      rtiScore:
          ((json['reviewerAtiScore'] ?? json['rtiScore'] ?? json['rti'])
                  as num?)
              ?.round(),
      trustGrade: json['trustGrade'] as String?,
      trustGradeLabel: json['trustGradeLabel'] as String?,
      trustGradeColor: json['trustGradeColor'] as String?,
      reasons: List<String>.from(json['reasons'] as List? ?? []),
      writtenAt: (json['writtenAt'] ?? json['createdAt']) as String? ?? '',
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
    );
  }

  static List<ProductReviewDto> fromList(List<dynamic> list) => list
      .map((e) => ProductReviewDto.fromJson(e as Map<String, dynamic>))
      .toList();

  ProductReview toEntity() {
    return ProductReview(
      id: id,
      authorName: reviewerNickname,
      authorAvatarUrl: null,
      rating: rating,
      content: content,
      createdAt: _formatDate(writtenAt),
      platform: '',
      isVerifiedPurchase: isVerifiedPurchase,
      rtiScore: rtiScore,
      rtiColor: trustGradeColor,
      rtiLabel: trustGradeLabel,
      helpfulCount: helpfulCount,
      imageUrls: imageUrls,
      reasons: reasons,
    );
  }

  static String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }
}

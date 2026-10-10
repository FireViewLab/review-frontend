import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductAnalysisDto {
  const ProductAnalysisDto({
    required this.productId,
    required this.averageRti,
    required this.level,
    required this.reviewCount,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.reviews,
    required this.trend,
    required this.realReviewRatio,
    required this.adSuspicionRatio,
    required this.repetitiveRatio,
    required this.trustSignals,
  });

  final String productId;
  final double averageRti;
  final String level;
  final int reviewCount;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final List<ReviewAnalysisItemDto> reviews;
  final List<AnalysisTrendItemDto> trend;
  final double realReviewRatio;
  final double adSuspicionRatio;
  final double repetitiveRatio;
  final List<TrustSignalDto> trustSignals;

  factory ProductAnalysisDto.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['reviews'] as List? ?? [];
    final rawTrend = json['trend'] as List? ?? [];
    final rawSignals = json['trustSignals'] as List? ?? [];
    return ProductAnalysisDto(
      productId: json['productId']?.toString() ?? '',
      averageRti: (json['averageRti'] as num?)?.toDouble() ?? 0.0,
      level: json['level'] as String? ?? 'safe',
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      safeCount: (json['safeCount'] as num?)?.toInt() ?? 0,
      warnCount: (json['warnCount'] as num?)?.toInt() ?? 0,
      dangerCount: (json['dangerCount'] as num?)?.toInt() ?? 0,
      reviews: rawReviews
          .map((e) => ReviewAnalysisItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      trend: rawTrend
          .map(
            (e) => AnalysisTrendItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      realReviewRatio: (json['realReviewRatio'] as num?)?.toDouble() ?? 0.0,
      adSuspicionRatio: (json['adSuspicionRatio'] as num?)?.toDouble() ?? 0.0,
      repetitiveRatio: (json['repetitiveRatio'] as num?)?.toDouble() ?? 0.0,
      trustSignals: rawSignals
          .map((e) => TrustSignalDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<int, ReviewRtiDetail> toReviewRtiDetailMap() {
    final result = <int, ReviewRtiDetail>{};
    for (final item in reviews) {
      final id = int.tryParse(item.reviewId);
      if (id != null) {
        result[id] = item.toRtiDetail();
      }
    }
    return result;
  }
}

class TrustSignalDto {
  const TrustSignalDto({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  final String label;
  final String value;
  final bool isPositive;

  factory TrustSignalDto.fromJson(Map<String, dynamic> json) {
    return TrustSignalDto(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      isPositive: json['isPositive'] as bool? ?? false,
    );
  }

  TrustSignal toEntity() => TrustSignal(
        label: label,
        value: value,
        isPositive: isPositive,
      );
}

class ReviewAnalysisItemDto {
  const ReviewAnalysisItemDto({
    required this.reviewId,
    required this.rti,
    required this.level,
    required this.textScore,
    required this.behaviorScore,
    required this.networkScore,
    required this.reasons,
    this.content,
    this.author,
    this.date,
  });

  final String reviewId;
  final String? content;
  final String? author;
  final String? date;
  final int rti;
  final String level;
  final int textScore;
  final int behaviorScore;
  final int networkScore;
  final List<ReviewReasonDto> reasons;

  factory ReviewAnalysisItemDto.fromJson(Map<String, dynamic> json) {
    final rawReasons = json['reasons'] as List? ?? [];
    return ReviewAnalysisItemDto(
      reviewId: json['reviewId']?.toString() ?? '',
      content: json['content'] as String?,
      author: json['author'] as String?,
      date: json['date'] as String?,
      rti: (json['rti'] as num?)?.toInt() ?? 0,
      level: json['level'] as String? ?? 'safe',
      textScore: (json['textScore'] as num?)?.toInt() ?? 0,
      behaviorScore: (json['behaviorScore'] as num?)?.toInt() ?? 0,
      networkScore: (json['networkScore'] as num?)?.toInt() ?? 0,
      reasons: rawReasons
          .map((e) => ReviewReasonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ReviewRtiDetail toRtiDetail() {
    final color = _levelHexColor(level);
    final signals = [
      RtiSignal(
        label: '텍스트 신뢰도',
        score: textScore,
        iconType: 'text',
        color: color,
      ),
      RtiSignal(
        label: '행동 패턴',
        score: behaviorScore,
        iconType: 'behavior',
        color: color,
      ),
      RtiSignal(
        label: '네트워크 분석',
        score: networkScore,
        iconType: 'pattern',
        color: color,
      ),
    ];

    final bases = reasons
        .map(
          (r) => RtiJudgmentBasis(
            label: r.message.trim().isNotEmpty ? r.message : r.code,
            description: r.code,
            percentage: rti,
            iconType: _codeToIconType(r.code),
            color: color,
          ),
        )
        .toList();

    return ReviewRtiDetail(
      summaryDescription: _buildSummaryDescription(level, rti),
      summaryTags: _buildSummaryTags(level),
      signals: signals,
      judgmentBases: bases,
      sentenceHighlights: const [],
    );
  }

  static String _levelHexColor(String level) => switch (level.toLowerCase()) {
        'safe' => '#22C55E',
        'warn' || 'suspicious' => '#F59E0B',
        'danger' => '#EF4444',
        _ => '#6B7280',
      };

  static String _buildSummaryDescription(String level, int rti) =>
      switch (level.toLowerCase()) {
        'safe' => 'AI 분석 결과 신뢰도 높은 리뷰입니다. (RTI $rti)',
        'warn' || 'suspicious' =>
          'AI 분석 결과 일부 의심 신호가 감지된 리뷰입니다. (RTI $rti)',
        'danger' => 'AI 분석 결과 신뢰도가 낮은 리뷰입니다. (RTI $rti)',
        _ => 'AI 분석 결과입니다. (RTI $rti)',
      };

  static List<RtiSummaryTag> _buildSummaryTags(String level) =>
      switch (level.toLowerCase()) {
        'safe' => const [
            RtiSummaryTag(label: '신뢰 리뷰', type: RtiTagType.positive),
          ],
        'warn' || 'suspicious' => const [
            RtiSummaryTag(label: '의심 신호 감지', type: RtiTagType.info),
          ],
        'danger' => const [
            RtiSummaryTag(label: '위험 리뷰', type: RtiTagType.warning),
          ],
        _ => const [],
      };

  static String _codeToIconType(String code) => switch (code) {
        'REPETITIVE_KEYWORD' ||
        'SIMILAR_REVIEW_CLUSTER' ||
        'SIMILAR_REVIEW_PATTERN' =>
          'repeat',
        'PURCHASE_NOT_VERIFIED' ||
        'PURCHASE_UNKNOWN' ||
        'FREE_TRIAL_REVIEW' =>
          'history',
        'MULTIPLE_REVIEWS_SAME_DAY' || 'REPURCHASE_SIGNAL' => 'similarity',
        _ => 'context',
      };
}

class AnalysisTrendItemDto {
  const AnalysisTrendItemDto({
    required this.date,
    required this.averageRti,
    required this.reviewCount,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final String date;
  final double averageRti;
  final int reviewCount;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  factory AnalysisTrendItemDto.fromJson(Map<String, dynamic> json) {
    return AnalysisTrendItemDto(
      date: json['date'] as String? ?? '',
      averageRti: (json['averageRti'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      safeCount: (json['safeCount'] as num?)?.toInt() ?? 0,
      warnCount: (json['warnCount'] as num?)?.toInt() ?? 0,
      dangerCount: (json['dangerCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReviewReasonDto {
  const ReviewReasonDto({required this.code, required this.message});

  final String code;
  final String message;

  factory ReviewReasonDto.fromJson(Map<String, dynamic> json) {
    return ReviewReasonDto(
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

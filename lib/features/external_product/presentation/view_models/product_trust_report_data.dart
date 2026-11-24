import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

enum ProductScoreSource { detail, catalog, loadedReviews, none }

enum ProductTrustGrade { safe, warn, danger, unknown }

class ProductTrustReportData {
  ProductTrustReportData._({
    required this.analysis,
    required this.breakdown,
    required this.source,
    required List<String> reasons,
    this.loadedReviewCount,
    this.loadedScoreCount,
    this.loadedLevelCount,
  }) : reasons = List.unmodifiable(reasons);

  factory ProductTrustReportData.fromState(ExternalProductState state) {
    final detail = state.analysis?.display;
    if (detail != null &&
        detail.isV2 &&
        (validScore(detail.score) != null || detail.levelCounts != null)) {
      return ProductTrustReportData._(
        analysis: detail,
        breakdown: detail,
        source: ProductScoreSource.detail,
        reasons: detail.displayReasons,
      );
    }
    final loaded = _fromLoadedReviews(state.reviews);
    if (loaded != null) return loaded;

    if (state.analysisState != ExternalAnalysisStatus.done) {
      return ProductTrustReportData._(
        analysis: null,
        breakdown: null,
        source: ProductScoreSource.none,
        reasons: const [],
      );
    }
    final hasDetail =
        detail != null &&
        (detail.hasResult ||
            detail.textScore != null ||
            detail.behaviorScore != null ||
            detail.networkScore != null);
    final product = state.displayProduct;
    final summary = state.summary;
    final candidate = product != null && summary?.matches(product.ref) == true
        ? summary?.catalogAnalysis
        : null;
    final catalog = candidate?.isCurrent == true
        ? candidate?.analysisDisplay
        : null;
    // 상세의 명시적인 계산 불가는 목록 점수로 덮어쓰지 않는다.
    final selected = hasDetail ? detail : catalog;
    final source = hasDetail
        ? ProductScoreSource.detail
        : catalog == null
        ? ProductScoreSource.none
        : ProductScoreSource.catalog;
    final breakdown = _supported(selected) ? selected : null;
    final reasons = breakdown?.displayReasons ?? const <String>[];
    return ProductTrustReportData._(
      analysis: selected,
      breakdown: breakdown,
      source: source,
      reasons: reasons,
    );
  }

  static ProductTrustReportData? _fromLoadedReviews(
    List<ExternalReview> reviews,
  ) {
    final unique = {for (final review in reviews) review.reviewId: review};
    final counts = {'SAFE': 0, 'WARN': 0, 'DANGER': 0};
    var loadedCount = 0;
    var scoredCount = 0;
    var levelCount = 0;
    var sum = 0.0;
    for (final review in unique.values) {
      final display = review.analysisDisplay;
      if (!display.isV2) continue;
      final score = validScore(display.score);
      final level = (display.reportedLevelV4 ?? display.level)
          ?.trim()
          .toUpperCase();
      final count = counts[level];
      if (score == null && count == null) continue;
      loadedCount++;
      if (score != null) {
        sum += score;
        scoredCount++;
      }
      if (level != null && count != null) {
        counts[level] = count + 1;
        levelCount++;
      }
    }
    if (loadedCount == 0) return null;
    return ProductTrustReportData._(
      analysis: AnalysisDisplay(
        contractVersion: 'v2',
        score: scoredCount == 0 ? null : sum / scoredCount,
        levelCounts: levelCount == 0 ? null : Map.unmodifiable(counts),
      ),
      breakdown: null,
      source: ProductScoreSource.loadedReviews,
      reasons: const [],
      loadedReviewCount: loadedCount,
      loadedScoreCount: scoredCount,
      loadedLevelCount: levelCount,
    );
  }

  final AnalysisDisplay? analysis;
  final AnalysisDisplay? breakdown;
  final ProductScoreSource source;
  final List<String> reasons;
  final int? loadedReviewCount;
  final int? loadedScoreCount;
  final int? loadedLevelCount;

  bool get hasResults => score != null || analysis?.levelCounts != null;

  double? get score =>
      _supported(analysis) ? validScore(analysis?.score) : null;
  bool get isV2 => analysis?.isV2 == true;
  ProductTrustGrade get grade => score == null
      ? ProductTrustGrade.unknown
      : switch (analysis?.level?.trim().toUpperCase()) {
          'SAFE' => ProductTrustGrade.safe,
          'WARN' || 'SUSPICIOUS' => ProductTrustGrade.warn,
          'DANGER' => ProductTrustGrade.danger,
          _ => ProductTrustGrade.unknown,
        };
  bool get hasComponents =>
      breakdown?.textScore != null ||
      breakdown?.behaviorScore != null ||
      breakdown?.networkScore != null;

  static bool _supported(AnalysisDisplay? display) =>
      display?.contractVersion == 'v2' || display?.contractVersion == 'v0.5';

  static double? validScore(double? value) =>
      value != null && value.isFinite && value >= 0 && value <= 100
      ? value
      : null;
}

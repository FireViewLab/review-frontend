import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

enum ProductScoreSource { detail, catalog, none }

enum ProductTrustGrade { safe, warn, danger, unknown }

class ProductTrustReportData {
  ProductTrustReportData._({
    required this.analysis,
    required this.breakdown,
    required this.source,
    required List<String> reasons,
  }) : reasons = List.unmodifiable(reasons);

  factory ProductTrustReportData.fromState(ExternalProductState state) {
    if (state.analysisState != ExternalAnalysisStatus.done) {
      return ProductTrustReportData._(
        analysis: null,
        breakdown: null,
        source: ProductScoreSource.none,
        reasons: const [],
      );
    }
    final detail = state.analysis?.display;
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

  final AnalysisDisplay? analysis;
  final AnalysisDisplay? breakdown;
  final ProductScoreSource source;
  final List<String> reasons;

  double? get score =>
      _supported(analysis) ? validScore(analysis?.score) : null;
  bool get isV2 => analysis?.isV2 == true;
  bool get isNotCalculable => isV2 && score == null;
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

import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';

enum LoadedAnalysisContract { v2, legacy, unknown }

enum LoadedReviewGrade { safe, warn, danger, notCalculable }

class LoadedGradeDistribution {
  LoadedGradeDistribution({
    required this.contract,
    required Map<LoadedReviewGrade, int> counts,
  }) : counts = Map.unmodifiable(counts);

  final LoadedAnalysisContract contract;
  final Map<LoadedReviewGrade, int> counts;

  int count(LoadedReviewGrade grade) => counts[grade] ?? 0;
}

class AnalysisReasonFrequency {
  const AnalysisReasonFrequency({required this.message, required this.count});

  final String message;
  final int count;
}

/// 현재 불러온 리뷰만 집계한다. 등급이나 상품 전체 비율을 점수에서 추정하지 않는다.
class AnalysisSummaryData {
  AnalysisSummaryData._({
    required this.loadedCount,
    required List<LoadedGradeDistribution> distributions,
    required List<AnalysisReasonFrequency> topReasons,
  }) : distributions = List.unmodifiable(distributions),
       topReasons = List.unmodifiable(topReasons);

  factory AnalysisSummaryData.fromReviews(List<ExternalReview> reviews) {
    final unique = {for (final review in reviews) review.reviewId: review};
    final counts = <LoadedAnalysisContract, Map<LoadedReviewGrade, int>>{};
    final reasons = <String, int>{};
    final whitespace = RegExp(r'\s+');
    for (final review in unique.values) {
      final display = review.analysisDisplay;
      final contract = switch (display.contractVersion) {
        'v2' => LoadedAnalysisContract.v2,
        'v0.5' => LoadedAnalysisContract.legacy,
        _ => LoadedAnalysisContract.unknown,
      };
      final grade =
          contract == LoadedAnalysisContract.unknown || display.isAwaitingScore
          ? LoadedReviewGrade.notCalculable
          : switch (display.level?.trim().toUpperCase()) {
              'SAFE' => LoadedReviewGrade.safe,
              'WARN' || 'SUSPICIOUS' => LoadedReviewGrade.warn,
              'DANGER' => LoadedReviewGrade.danger,
              _ => LoadedReviewGrade.notCalculable,
            };
      final group = counts.putIfAbsent(contract, () => {});
      group.update(grade, (count) => count + 1, ifAbsent: () => 1);
      if (contract == LoadedAnalysisContract.unknown) continue;
      // 같은 리뷰에 반복된 문장은 해당 리뷰에서 한 번만 센다.
      final sentences = display.displayReasons
          .map((reason) => reason.trim().replaceAll(whitespace, ' '))
          .where((reason) => reason.isNotEmpty)
          .toSet();
      for (final sentence in sentences) {
        reasons.update(sentence, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final ranked = reasons.entries.toList()
      ..sort((a, b) {
        final frequency = b.value.compareTo(a.value);
        return frequency != 0 ? frequency : a.key.compareTo(b.key);
      });
    return AnalysisSummaryData._(
      loadedCount: unique.length,
      distributions: [
        for (final contract in LoadedAnalysisContract.values)
          if (counts[contract] case final group?)
            LoadedGradeDistribution(contract: contract, counts: group),
      ],
      topReasons: [
        for (final entry in ranked.take(3))
          AnalysisReasonFrequency(message: entry.key, count: entry.value),
      ],
    );
  }

  final int loadedCount;
  final List<LoadedGradeDistribution> distributions;
  final List<AnalysisReasonFrequency> topReasons;
}

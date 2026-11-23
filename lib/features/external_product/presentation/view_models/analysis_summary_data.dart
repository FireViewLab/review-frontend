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

/// A deterministic summary of the reviews currently loaded on screen.
class ReviewContentSummary {
  ReviewContentSummary.fromReviews(
    List<ExternalReview> reviews, {
    required String productName,
  }) {
    final unique = {
      for (final review in reviews) review.reviewId: review,
    }.values.toList();
    loadedCount = unique.length;
    final ratings = unique
        .where(
          (review) =>
              review.rating != null &&
              review.rating!.isFinite &&
              review.rating! >= 1 &&
              review.rating! <= 5,
        )
        .toList();
    average = ratings.isEmpty
        ? null
        : ratings.fold<double>(0, (sum, review) => sum + review.rating!) /
              ratings.length;
    distribution = List.unmodifiable(
      List.generate(
        5,
        (index) => ratings
            .where((review) => review.rating!.round() == index + 1)
            .length,
      ),
    );
    ratings.sort((a, b) => b.rating!.compareTo(a.rating!));
    final positiveReview = ratings
        .where(
          (review) => review.rating! >= 4 && review.content.trim().isNotEmpty,
        )
        .firstOrNull;
    final negativeReview = ratings.reversed
        .where(
          (review) => review.rating! <= 2 && review.content.trim().isNotEmpty,
        )
        .firstOrNull;
    positive = _excerpt(positiveReview);
    negative = _excerpt(negativeReview);
    positiveRating = positiveReview?.rating;
    negativeRating = negativeReview?.rating;
    final excluded = _tokens(productName).toSet();
    final frequencies = <String, int>{};
    for (final review in unique) {
      for (final token in _tokens(
        review.content,
      ).toSet().difference(excluded)) {
        frequencies.update(token, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final ranked = frequencies.entries.toList()
      ..sort((a, b) {
        final frequency = b.value.compareTo(a.value);
        return frequency != 0 ? frequency : a.key.compareTo(b.key);
      });
    keywords = List.unmodifiable(ranked.take(5).map((entry) => entry.key));
  }

  late final int loadedCount;
  late final double? average;
  late final List<int> distribution;
  late final List<String> keywords;
  late final double? positiveRating;
  late final double? negativeRating;
  late final String? positive;
  late final String? negative;

  static String? _excerpt(ExternalReview? review) {
    if (review == null) return null;
    final text = review.content.trim().replaceAll(RegExp(r'\s+'), ' ');
    final characters = text.runes.toList();
    return characters.length <= 80
        ? text
        : '${String.fromCharCodes(characters.take(79))}…';
  }

  static Iterable<String> _tokens(String text) sync* {
    const stopwords = {
      '정말',
      '너무',
      '아주',
      '진짜',
      '그냥',
      '조금',
      '많이',
      '다시',
      '이번',
      '저는',
      '제가',
      '이거',
      '이것',
      '저것',
      '상품',
      '제품',
      '구매',
      '사용',
      '리뷰',
      '후기',
      '때문',
      '정도',
      '같아요',
      '좋아요',
      '있어요',
      '없어요',
      '합니다',
      '입니다',
      'the',
      'and',
      'for',
      'this',
      'with',
      'very',
    };
    final particles = RegExp(
      r'(에서는|으로는|에서도|에게는|이라도|으로|에서|에게|까지|부터|처럼|보다|하고|이랑|랑|은|는|이|가|을|를|에|의|도|만|와|과)$',
    );
    for (final match in RegExp(
      r'[가-힣a-zA-Z]+',
    ).allMatches(text.toLowerCase())) {
      final token = match.group(0)!.replaceFirst(particles, '');
      if (token.runes.length < 2 ||
          stopwords.contains(token) ||
          RegExp(
            r'(어요|아요|해요|네요|지만|니다|해서|하고|좋고|했음|했어요|습니다|같은|있는|없는)$',
          ).hasMatch(token)) {
        continue;
      }
      yield token;
    }
  }
}

int? productReviewCount(Map<String, dynamic> json) {
  int? available;
  for (final key in [
    'reviewCount',
    'review_count',
    'reviewsCount',
    'analysisSourceReviewCount',
    'analysis_source_review_count',
    'analysisReviewCount',
    'analysis_review_count',
  ]) {
    final value = json[key];
    final count = value is num ? value.toInt() : int.tryParse('$value');
    if (count != null && count > 0) return count;
    if (count == 0) available = 0;
  }
  return available;
}

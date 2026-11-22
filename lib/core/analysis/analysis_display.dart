class AnalysisDisplay {
  const AnalysisDisplay({
    this.contractVersion = 'v0.5',
    this.score,
    this.level,
    this.summary,
    this.reasons = const [],
    this.evidenceReasons = const [],
    this.reasonSource,
    this.textScore,
    this.behaviorScore,
    this.networkScore,
    this.textProbability,
    this.modelVersion,
    this.policyVersion,
    this.levelCounts,
  });

  final String contractVersion;
  final double? score;
  final String? level;
  final String? summary;
  final List<String> reasons;
  final List<String> evidenceReasons;
  final String? reasonSource;
  final double? textScore;
  final double? behaviorScore;
  final double? networkScore;
  final double? textProbability;
  final String? modelVersion;
  final String? policyVersion;
  final Map<String, int>? levelCounts;

  bool get isAwaitingScore => isV2 && score == null;
  bool get needsAttentionExplanation =>
      isV2 &&
      score != null &&
      const {'WARN', 'DANGER'}.contains(level?.toUpperCase());
  int? get attentionReviewCount {
    final warn = levelCounts?['WARN'];
    final danger = levelCounts?['DANGER'];
    return isV2 && warn != null && danger != null ? warn + danger : null;
  }

  bool get isV2 => contractVersion == 'v2';
  bool get hasResult =>
      isV2 || score != null || level != null || reasons.isNotEmpty;
  List<String> get displayReasons =>
      isV2 ? const [] : (summary == null ? reasons : [summary!]);
  String? get colorHex => isAwaitingScore
      ? null
      : switch (level?.toUpperCase()) {
          'SAFE' => '#22C55E',
          'WARN' || 'SUSPICIOUS' => '#F59E0B',
          'DANGER' => '#EF4444',
          _ => null,
        };
}

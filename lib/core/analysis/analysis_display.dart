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

  bool get isV2 => contractVersion == 'v2';
  bool get hasResult =>
      isV2 || score != null || level != null || reasons.isNotEmpty;
  List<String> get displayReasons => summary == null ? reasons : [summary!];
  String? get colorHex => switch (level?.toUpperCase()) {
    'SAFE' => '#22C55E',
    'WARN' || 'SUSPICIOUS' => '#F59E0B',
    'DANGER' => '#EF4444',
    _ => null,
  };
}

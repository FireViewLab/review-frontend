import 'analysis_display.dart';
import 'analysis_keys.dart';

abstract final class AnalysisContract {
  static Object? read(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) return json[key];
    }
    return null;
  }

  static String? text(Object? value) {
    final result = value is String ? value.trim() : '';
    return result.isEmpty ? null : result;
  }

  static double? score(Object? value) {
    final result = value is num ? value.toDouble() : double.tryParse('$value');
    return result != null && result.isFinite && result >= 0 && result <= 100
        ? result
        : null;
  }

  static String? version(Map<String, dynamic> json) =>
      text(read(json, AnalysisKeys.version));

  static List<String> _reasons(Object? value) => [
    if (value is List)
      for (final item in value)
        if (text(item is Map ? item['message'] ?? item['code'] : item)
            case final String reason)
          reason,
  ];

  static double? _probability(Object? value) {
    final parsed = score(value);
    return parsed != null && parsed <= 1 ? parsed : null;
  }

  static Map<String, int>? _levelCounts(Object? value) {
    if (value is! Map) return null;
    const levels = ['SAFE', 'WARN', 'DANGER'];
    for (final level in levels) {
      final count = value[level];
      if (count is! int || count < 0) return null;
    }
    return Map.unmodifiable({
      for (final level in levels) level: value[level] as int,
    });
  }

  static AnalysisDisplay parse(
    Map<String, dynamic> json, {
    bool catalog = false,
    String? inheritedVersion,
  }) {
    final contract =
        version(json) ??
        inheritedVersion ??
        ([
              ...AnalysisKeys.policyIndex,
              ...AnalysisKeys.averagePolicyIndex,
              ...AnalysisKeys.evidenceLevel,
              ...AnalysisKeys.textScore,
              ...AnalysisKeys.textProbability,
              ...AnalysisKeys.modelVersion,
              ...AnalysisKeys.policyVersion,
              ...AnalysisKeys.levelCounts,
            ].any(json.containsKey)
            ? 'v2'
            : 'v0.5');
    final v2 = contract == 'v2';
    final value = score(
      read(
        json,
        v2
            ? (catalog
                  ? AnalysisKeys.averagePolicyIndex
                  : AnalysisKeys.policyIndex)
            : (catalog ? AnalysisKeys.averageScore : AnalysisKeys.reviewScore),
      ),
    );
    final rawLevel = text(
      read(json, v2 ? AnalysisKeys.evidenceLevel : AnalysisKeys.level),
    );
    final level = v2 && value == null
        ? null
        : v2 && catalog && rawLevel == null && value != null
        ? (value >= 70
              ? 'SAFE'
              : value >= 40
              ? 'WARN'
              : 'DANGER')
        : rawLevel;
    return AnalysisDisplay(
      contractVersion: contract,
      score: value,
      level: level,
      summary: null,
      reasons: v2 ? const [] : _reasons(read(json, AnalysisKeys.reasons)),
      evidenceReasons: const [],
      reasonSource: v2 ? null : text(read(json, AnalysisKeys.reasonSource)),
      textScore: score(read(json, AnalysisKeys.textScore)),
      behaviorScore: score(read(json, AnalysisKeys.behaviorScore)),
      networkScore: score(read(json, AnalysisKeys.networkScore)),
      textProbability: v2
          ? _probability(read(json, AnalysisKeys.textProbability))
          : null,
      modelVersion: text(read(json, AnalysisKeys.modelVersion)),
      policyVersion: text(read(json, AnalysisKeys.policyVersion)),
      levelCounts: v2 && catalog
          ? _levelCounts(read(json, AnalysisKeys.levelCounts))
          : null,
    );
  }
}

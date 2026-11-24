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

  /// 서버 계약 버전을 화면 형식으로 정규화한다. v2 이후(v3, v4 …)는 모두
  /// 정책 점수 형식이고, v0.x만 이전 RTI 형식이다.
  static String? version(Map<String, dynamic> json) =>
      normalizeVersion(text(read(json, AnalysisKeys.version)));

  static String? normalizeVersion(String? raw) {
    final value = raw?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    final major = int.tryParse(
      RegExp(r'^v?(\d+)').firstMatch(value)?.group(1) ?? '',
    );
    if (major == null) return value;
    return major >= 2 ? 'v2' : 'v0.5';
  }

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
        normalizeVersion(inheritedVersion) ??
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
      reportedLevelV4: v2 && !catalog ? rawLevel : null,
      levelCounts: v2 && catalog
          ? _levelCounts(read(json, AnalysisKeys.levelCounts))
          : null,
    );
  }
}

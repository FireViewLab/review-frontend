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

  static AnalysisDisplay parse(
    Map<String, dynamic> json, {
    bool catalog = false,
    String? inheritedVersion,
  }) {
    final contract =
        version(json) ??
        inheritedVersion ??
        (catalog && score(read(json, AnalysisKeys.averagePolicyIndex)) != null
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
    final level = v2 && catalog && rawLevel == null && value != null
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
      summary: v2 ? text(read(json, AnalysisKeys.summary)) : null,
      reasons: _reasons(
        read(json, v2 ? AnalysisKeys.rulesReasons : AnalysisKeys.reasons),
      ),
      evidenceReasons: _reasons(read(json, AnalysisKeys.evidenceReasons)),
      reasonSource: text(read(json, AnalysisKeys.reasonSource)),
      textScore: score(read(json, AnalysisKeys.textScore)),
      behaviorScore: score(read(json, AnalysisKeys.behaviorScore)),
      networkScore: score(read(json, AnalysisKeys.networkScore)),
    );
  }
}

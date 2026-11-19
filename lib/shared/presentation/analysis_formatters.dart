import 'package:flutter/material.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

extension AnalysisFormatting on AnalysisDisplay {
  String scoreName(BuildContext context) =>
      isV2 ? AppLocalizations.of(context).analysisPolicyIndex : 'RTI';
  String badgeText(BuildContext context, {String? legacyMissingLabel}) =>
      score == null
      ? (isV2
            ? AppLocalizations.of(context).analysisNotCalculable
            : (legacyMissingLabel ?? AppLocalizations.of(context).reportBefore))
      : '${scoreName(context)} ${score!.round()}';
  String? gradeLabel(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (level?.toUpperCase()) {
      'SAFE' => l.reviewAnalysisSafe,
      'WARN' || 'SUSPICIOUS' => l.reviewAnalysisWarn,
      'DANGER' => l.reviewAnalysisDanger,
      _ => level,
    };
  }

  Color get color => switch (level?.toUpperCase()) {
    'SAFE' => const Color(0xFF22C55E),
    'WARN' || 'SUSPICIOUS' => const Color(0xFFF59E0B),
    'DANGER' => const Color(0xFFEF4444),
    _ => const Color(0xFF64748B),
  };
}

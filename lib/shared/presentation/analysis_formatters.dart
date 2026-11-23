import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

extension AnalysisFormatting on AnalysisDisplay {
  String scoreName(BuildContext context) => 'RTI';
  String badgeText(BuildContext context, {String? legacyMissingLabel}) =>
      score == null
      ? (isV2
            ? AppLocalizations.of(context).analysisPending
            : (legacyMissingLabel ?? AppLocalizations.of(context).reportBefore))
      : '${scoreName(context)} ${NumberFormat.decimalPattern(AppLocalizations.of(context).localeName).format(score!.round())}';
  List<String> localizedReasons(BuildContext context) => isV2
      ? (needsAttentionExplanation
            ? [AppLocalizations.of(context).analysisTextCaution]
            : const [])
      : displayReasons;

  String? attentionReviewsLabel(BuildContext context) {
    final count = attentionReviewCount;
    return count == null || count == 0
        ? null
        : AppLocalizations.of(context).analysisAttentionReviews(count);
  }

  String? gradeLabel(BuildContext context) {
    if (isAwaitingScore) return null;
    final l = AppLocalizations.of(context);
    return switch (level?.toUpperCase()) {
      'SAFE' => l.reviewAnalysisSafe,
      'WARN' || 'SUSPICIOUS' => l.reviewAnalysisWarn,
      'DANGER' => l.reviewAnalysisDanger,
      _ => level,
    };
  }

  Color get color => isAwaitingScore
      ? const Color(0xFF64748B)
      : switch (level?.toUpperCase()) {
          'SAFE' => const Color(0xFF22C55E),
          'WARN' || 'SUSPICIOUS' => const Color(0xFFF59E0B),
          'DANGER' => const Color(0xFFEF4444),
          _ => const Color(0xFF64748B),
        };
}

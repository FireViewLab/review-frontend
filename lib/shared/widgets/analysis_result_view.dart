import 'package:flutter/material.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/shared/widgets/rti_score_ring.dart';

class AnalysisResultView extends StatelessWidget {
  const AnalysisResultView({
    super.key,
    required this.analysis,
    this.compact = false,
  });
  final AnalysisDisplay analysis;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final score = analysis.score;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact && score != null) Text(analysis.scoreName(context)),
        if (score == null)
          Text(analysis.badgeText(context))
        else
          RtiScoreRing(
            score: score,
            color: analysis.color,
            size: compact ? 56 : 96,
            scoreLabel: analysis.scoreName(context),
          ),
        if (analysis.gradeLabel(context) case final String grade)
          Text(
            grade,
            style: TextStyle(
              color: analysis.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        for (final reason in analysis.localizedReasons(context))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              reason,
              maxLines: compact ? 2 : null,
              overflow: compact ? TextOverflow.ellipsis : null,
            ),
          ),
        if (!compact) ...[
          const SizedBox(height: 8),
          Text(l.analysisPolicyExplanation),
          const SizedBox(height: 8),
          for (final (label, value) in [
            (l.analysisTextScore, analysis.textScore),
            (l.analysisBehaviorScore, analysis.behaviorScore),
            (l.analysisNetworkScore, analysis.networkScore),
          ])
            Text(
              '$label: ${value == null ? l.analysisNotCalculable : value.toStringAsFixed(1)}',
            ),
        ],
      ],
    );
  }
}

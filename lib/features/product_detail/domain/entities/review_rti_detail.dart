import 'package:re_view_front/core/analysis/analysis_display.dart';

class ReviewRtiDetail {
  const ReviewRtiDetail({
    this.analysis,
    required this.summaryDescription,
    required this.summaryTags,
    required this.signals,
    required this.judgmentBases,
    required this.sentenceHighlights,
  });

  final AnalysisDisplay? analysis;
  final String summaryDescription;
  final List<RtiSummaryTag> summaryTags;
  final List<RtiSignal> signals;
  final List<RtiJudgmentBasis> judgmentBases;
  final List<RtiSentenceHighlight> sentenceHighlights;
}

enum RtiTagType { positive, info, warning }

class RtiSummaryTag {
  const RtiSummaryTag({required this.label, required this.type});

  final String label;
  final RtiTagType type;
}

class RtiSignal {
  const RtiSignal({
    required this.label,
    required this.score,
    required this.iconType,
    required this.color,
  });

  final String label;
  final int? score;
  final String iconType; // 'text', 'behavior', 'pattern', 'purchase'
  final String color; // hex
}

class RtiJudgmentBasis {
  const RtiJudgmentBasis({
    required this.label,
    required this.description,
    required this.percentage,
    required this.iconType,
    required this.color,
  });

  final String label;
  final String description;
  final int? percentage;
  final String iconType; // 'repeat', 'context', 'history', 'similarity'
  final String color; // hex
}

class RtiSentenceHighlight {
  const RtiSentenceHighlight({
    required this.sentence,
    required this.tag,
    required this.color,
  });

  final String sentence;
  final String tag;
  final String color; // hex
}

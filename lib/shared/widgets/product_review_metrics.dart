import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/search/presentation/widgets/product_rti_badge.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';

class ProductReviewMetrics extends StatelessWidget {
  const ProductReviewMetrics({
    super.key,
    this.rating,
    this.reviewCount,
    required this.analysis,
    this.analyzedReviewCount,
    this.alignment = WrapAlignment.spaceBetween,
  });
  final double? rating;
  final int? reviewCount;
  final AnalysisDisplay analysis;
  final int? analyzedReviewCount;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final count = (reviewCount ?? 0) > 0
        ? l.detailFormattedReviewCount(
            NumberFormat.decimalPattern(l.localeName).format(reviewCount),
          )
        : '';
    final average = rating != null && rating!.isFinite && rating! > 0
        ? '★${NumberFormat('0.0', l.localeName).format(rating)}'
        : '';
    final label = [
      if (average.isNotEmpty) average,
      if (count.isNotEmpty) count,
    ].join(' · ');
    final showScore =
        (analyzedReviewCount ?? reviewCount ?? 0) > 0 && analysis.score != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label.isNotEmpty || showScore)
          Wrap(
            alignment: alignment,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xxs,
            children: [
              if (label.isNotEmpty)
                Text(label, style: Theme.of(context).textTheme.labelSmall),
              if (showScore)
                RtiBadge(
                  value: analysis.score!.round(),
                  color: analysis.color,
                  analysis: analysis,
                ),
            ],
          ),
        if (analysis.attentionReviewsLabel(context) case final String attention)
          Text(attention, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

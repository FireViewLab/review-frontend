import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/analysis_summary_data.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ReviewSummaryContent extends StatelessWidget {
  const ReviewSummaryContent({required this.data, super.key});
  final ReviewContentSummary data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final numbers = NumberFormat.decimalPattern(l.localeName);
    final hasKeywords = data.keywords.length >= 2;
    final hasPhrases =
        hasKeywords || data.positive != null || data.negative != null;
    final count = Text(
      l.extSummaryReviewBasis(numbers.format(data.loadedCount)),
      style: data.ratedCount == 0 ? theme.titleLarge : theme.bodySmall,
    );
    final average = data.average;
    final ratings = average == null
        ? count
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      NumberFormat('0.0', l.localeName).format(average),
                      style: theme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              count,
              if (data.ratedCount < data.loadedCount)
                Text(
                  l.extSummaryRatedReviewBasis(numbers.format(data.ratedCount)),
                  style: theme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              for (var star = 5; star >= 1; star--)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: star == 1 ? 0 : AppSpacing.sm,
                  ),
                  child: Semantics(
                    label: l.extReviewStarCount(
                      star,
                      data.distribution[star - 1],
                    ),
                    excludeSemantics: true,
                    child: Row(
                      children: [
                        Text('$star ★', style: theme.labelSmall),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.small,
                            child: LinearProgressIndicator(
                              value:
                                  data.distribution[star - 1] / data.ratedCount,
                              minHeight: 8,
                              color: AppColors.warning,
                              backgroundColor: AppColors.border,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          numbers.format(data.distribution[star - 1]),
                          style: theme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
    final phrases = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasKeywords) ...[
          Text(l.extSummaryFrequentPhrases, style: theme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final keyword in data.keywords)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: AppRadius.small,
                  ),
                  child: Text(
                    keyword,
                    style: theme.labelMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          if (data.positive != null || data.negative != null)
            const SizedBox(height: AppSpacing.md),
        ],
        if (data.positive != null)
          _ReviewQuote(
            label: l.extSummaryPositiveLabel,
            text: data.positive!,
            rating: data.positiveRating,
          ),
        if (data.negative != null) ...[
          if (data.positive != null) const SizedBox(height: AppSpacing.sm),
          _ReviewQuote(
            label: l.extSummaryNegativeLabel,
            text: data.negative!,
            rating: data.negativeRating,
          ),
        ],
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        if (!hasPhrases) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ratings,
            ),
          );
        }
        if (average == null && constraints.maxWidth >= 560 * scale) {
          return Row(
            children: [
              count,
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: phrases),
            ],
          );
        }
        if (average != null && constraints.maxWidth >= 680 * scale) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: ratings),
              const SizedBox(width: AppSpacing.xl),
              Expanded(flex: 3, child: phrases),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ratings,
            const SizedBox(height: AppSpacing.md),
            phrases,
          ],
        );
      },
    );
  }
}

class _ReviewQuote extends StatelessWidget {
  const _ReviewQuote({required this.label, required this.text, this.rating});
  final String label;
  final String text;
  final double? rating;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.background,
      border: Border.all(color: AppColors.border),
      borderRadius: AppRadius.medium,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            if (rating != null)
              Text(
                '★ ${NumberFormat('0.0', AppLocalizations.of(context).localeName).format(rating)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '“$text”',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    ),
  );
}

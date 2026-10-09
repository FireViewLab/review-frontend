import 'package:re_view_front/features/external_product/presentation/widgets/external_review_analysis.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';

class ExternalProductReport extends StatelessWidget {
  const ExternalProductReport({super.key, required this.state});
  final ExternalProductState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final analysis = state.analysis;
    final status = state.analysisStatus.toUpperCase();
    final summary = state.phase == ExternalProductPhase.collecting
        ? l.reportCollecting
        : switch (status) {
            'QUEUED' || 'RUNNING' => l.reportRunning,
            'FAILED' => l.reportFailed,
            'DISABLED' => l.reportDisabled,
            'STALE' => l.reportStale,
            'DONE' when analysis != null => l.reportDone,
            'NOT_ANALYZED' => l.reportBefore,
            _ => l.reportUnavailable,
          };
    final hasResults = status == 'DONE' && analysis != null;
    final reviews = hasResults
        ? state.reviews
              .where(
                (r) => r.rti != null || r.level != null || r.reasons.isNotEmpty,
              )
              .toList()
        : [];
    final facts = <String>[
      if (hasResults && analysis.reviewCount != null)
        '${l.reportInputCount}: ${analysis.reviewCount}',
      if (hasResults && analysis.sampled != null)
        analysis.sampled! ? l.reportSampled : l.reportFull,
    ];
    return ProductReportCard(
      summary: summary,
      facts: facts,
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary, style: Theme.of(context).textTheme.titleMedium),
          for (final fact in facts)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(fact),
            ),
          if (hasResults && analysis.sourceReviewCount != null)
            Text('${l.reportSourceCount}: ${analysis.sourceReviewCount}'),
          if (hasResults && analysis.modelVersion != null)
            Text('${l.reportModel}: ${analysis.modelVersion}'),
          if (hasResults && analysis.policyVersion != null)
            Text('${l.reportPolicy}: ${analysis.policyVersion}'),
          const SizedBox(height: AppSpacing.md),
          Text(l.reportLoadedScope),
          const SizedBox(height: AppSpacing.sm),
          if (reviews.isEmpty)
            Text(l.reportNoReviewResults)
          else ...[
            Text('${l.reportCurrentCount}: ${reviews.length}'),
            for (final review in reviews)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: ExternalReviewAnalysisDetails(review: review),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

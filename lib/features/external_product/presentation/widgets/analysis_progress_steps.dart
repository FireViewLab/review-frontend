import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/analysis_progress_state.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/owl_guide.dart';

class AnalysisProgressSteps extends StatelessWidget {
  const AnalysisProgressSteps({
    required this.state,
    required this.onRetry,
    super.key,
  });

  final ExternalProductState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = AnalysisProgressState.fromDetail(state);
    final message = switch (progress.notice) {
      AnalysisProgressNotice.collecting => l10n.extProgressNoticeCollecting,
      AnalysisProgressNotice.refreshing => l10n.extProgressNoticeRefreshing,
      AnalysisProgressNotice.analyzing => l10n.extProgressNoticeAnalyzing,
      AnalysisProgressNotice.notAnalyzed => l10n.extProgressNoticeNotAnalyzed,
      AnalysisProgressNotice.complete => l10n.extProgressNoticeComplete,
      AnalysisProgressNotice.failed => l10n.extProgressNoticeFailed,
      AnalysisProgressNotice.delayed => l10n.extProgressNoticeDelayed,
      AnalysisProgressNotice.checking => l10n.extProgressNoticeChecking,
      AnalysisProgressNotice.disabled => l10n.extProgressNoticeDisabled,
      AnalysisProgressNotice.unavailable => l10n.extProgressNoticeUnavailable,
    };
    final tone = switch (progress.notice) {
      AnalysisProgressNotice.complete => OwlGuideTone.success,
      AnalysisProgressNotice.failed ||
      AnalysisProgressNotice.delayed => OwlGuideTone.warning,
      _ => OwlGuideTone.info,
    };
    if (!progress.showSteps) {
      return Text(
        state.isStale || (state.job?.isActive ?? false)
            ? l10n.extProgressPreviousComplete
            : l10n.extProgressNoticeComplete,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: OwlGuide(
                avatarSize: 40,
                message: message,
                tone: tone,
                action: progress.notice == AnalysisProgressNotice.delayed
                    ? TextButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.extProgressRetry),
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (progress.showSteps) ...[
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final steps = [
                _ProgressStep(
                  label: l10n.extProgressProductStep,
                  status: progress.product,
                  previous:
                      (state.isStale || (state.job?.isActive ?? false)) &&
                      progress.product == AnalysisStepStatus.complete,
                ),
                _ProgressStep(
                  label: l10n.extProgressReviewsStep,
                  status: progress.reviews,
                  previous:
                      (state.isStale || (state.job?.isActive ?? false)) &&
                      progress.reviews == AnalysisStepStatus.complete,
                ),
                _ProgressStep(
                  label: l10n.extProgressAnalysisStep,
                  status: progress.analysis,
                ),
              ];
              final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
              if (constraints.maxWidth >= 720 * textScale) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.lg),
                      Expanded(child: steps[i]),
                    ],
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.md),
                    steps[i],
                  ],
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.label,
    required this.status,
    this.previous = false,
  });

  final bool previous;

  final String label;
  final AnalysisStepStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final caption = previous
        ? l10n.extProgressPreviousInfo
        : switch (status) {
            AnalysisStepStatus.complete => l10n.extProgressStatusComplete,
            AnalysisStepStatus.inProgress => l10n.extProgressStatusInProgress,
            AnalysisStepStatus.waiting => l10n.extProgressStatusWaiting,
            AnalysisStepStatus.failed => l10n.extProgressStatusFailed,
            AnalysisStepStatus.notAnalyzed => l10n.extProgressStatusNotAnalyzed,
            AnalysisStepStatus.unknown => l10n.extProgressStatusUnknown,
            AnalysisStepStatus.refreshing => l10n.extProgressStatusRefreshing,
            AnalysisStepStatus.disabled => l10n.extProgressStatusDisabled,
            AnalysisStepStatus.unavailable => l10n.extProgressStatusUnavailable,
            AnalysisStepStatus.partial => l10n.extProgressStatusPartial,
          };
    final color = switch (status) {
      AnalysisStepStatus.complete => AppColors.success,
      AnalysisStepStatus.inProgress ||
      AnalysisStepStatus.refreshing => AppColors.primary,
      AnalysisStepStatus.failed => AppColors.error,
      AnalysisStepStatus.partial => AppColors.warning,
      _ => AppColors.textSecondary,
    };
    final icon = switch (status) {
      AnalysisStepStatus.complete => Icons.check_circle_outline_rounded,
      AnalysisStepStatus.inProgress ||
      AnalysisStepStatus.refreshing => Icons.sync_rounded,
      AnalysisStepStatus.failed => Icons.error_outline_rounded,
      AnalysisStepStatus.waiting => Icons.schedule_rounded,
      AnalysisStepStatus.notAnalyzed => Icons.pending_outlined,
      AnalysisStepStatus.disabled => Icons.pause_circle_outline_rounded,
      AnalysisStepStatus.partial => Icons.warning_amber_rounded,
      AnalysisStepStatus.unknown ||
      AnalysisStepStatus.unavailable => Icons.help_outline_rounded,
    };
    final isActive =
        status == AnalysisStepStatus.inProgress ||
        status == AnalysisStepStatus.refreshing;
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: l10n.extProgressStepSemantics(label, caption),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 24,
            child: isActive && !MediaQuery.disableAnimationsOf(context)
                ? Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  caption,
                  style: (previous ? textTheme.bodySmall : textTheme.bodyMedium)
                      ?.copyWith(
                        color: status == AnalysisStepStatus.partial
                            ? AppColors.textSecondary
                            : color,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

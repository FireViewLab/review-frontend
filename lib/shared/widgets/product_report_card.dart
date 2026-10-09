import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

enum ProductReportStatus {
  ready,
  pending,
  collecting,
  running,
  failed,
  stale,
  disabled,
  unavailable,
}

class ProductReportMetric {
  const ProductReportMetric(this.label, this.value);
  final String label;
  final String value;
}

/// Shows supplied results; opening details never starts an analysis request.
class ProductReportCard extends StatelessWidget {
  const ProductReportCard({
    super.key,
    required this.summary,
    required this.details,
    this.status = ProductReportStatus.pending,
    this.score,
    this.metrics = const [],
    this.onDetailPressed,
  });
  final String summary;
  final Widget details;
  final ProductReportStatus status;
  final double? score;
  final List<ProductReportMetric> metrics;
  final VoidCallback? onDetailPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final (label, color, icon) = switch (status) {
      ProductReportStatus.ready => (
        l.reportStateReady,
        AppColors.primary,
        Icons.fact_check_outlined,
      ),
      ProductReportStatus.collecting => (
        l.reportStateCollecting,
        AppColors.info,
        Icons.cloud_download_outlined,
      ),
      ProductReportStatus.running => (
        l.reportStateRunning,
        AppColors.info,
        Icons.hourglass_top_rounded,
      ),
      ProductReportStatus.failed => (
        l.reportStateFailed,
        AppColors.error,
        Icons.info_outline,
      ),
      ProductReportStatus.stale => (
        l.reportStateStale,
        AppColors.warning,
        Icons.update_rounded,
      ),
      ProductReportStatus.disabled => (
        l.reportStateDisabled,
        AppColors.textSecondary,
        Icons.pause_circle_outline,
      ),
      ProductReportStatus.unavailable => (
        l.reportStateUnavailable,
        AppColors.textSecondary,
        Icons.info_outline,
      ),
      ProductReportStatus.pending => (
        l.reportBefore,
        AppColors.textSecondary,
        Icons.query_stats_rounded,
      ),
    };
    final validScore =
        status == ProductReportStatus.ready &&
        score != null &&
        score!.isFinite &&
        score! >= 0 &&
        score! <= 100;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.reportTitle,
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.reportIntro,
                        style: theme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final result = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: color, size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              label,
                              style: theme.labelMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      summary,
                      style: theme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                );
                if (!validScore) return result;
                final scoreCard = Container(
                  width: constraints.maxWidth < 440 ? double.infinity : 160,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.reportScoreLabel,
                        style: theme.labelMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${score == score!.roundToDouble() ? score!.toInt() : score!.toStringAsFixed(1)}',
                        style: theme.headlineLarge?.copyWith(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'RTI / 100',
                        style: theme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
                if (constraints.maxWidth < 440) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      scoreCard,
                      const SizedBox(height: AppSpacing.md),
                      result,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    scoreCard,
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: result),
                  ],
                );
              },
            ),
            if (metrics.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final metric in metrics)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metric.label,
                            style: theme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            metric.value,
                            style: theme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.borderStrong),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    onDetailPressed ??
                    () => showProductReport(context, details),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(l.reportDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDetailSection extends StatelessWidget {
  const ReportDetailSection({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    ),
  );
}

class ReportFactRow extends StatelessWidget {
  const ReportFactRow({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Wrap(
      spacing: AppSpacing.md,
      runSpacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

Future<void> showProductReport(BuildContext context, Widget details) =>
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 800,
            maxHeight: MediaQuery.sizeOf(context).height * .85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fact_check_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).reportDetails,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      tooltip: AppLocalizations.of(context).reportClose,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: details,
                ),
              ),
            ],
          ),
        ),
      ),
    );

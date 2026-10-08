import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// A compact read-only report. Opening details never starts analysis.
class ProductReportCard extends StatelessWidget {
  const ProductReportCard({
    super.key,
    required this.summary,
    required this.details,
    this.facts = const [],
    this.onDetailPressed,
  });
  final String summary;
  final List<String> facts;
  final Widget details;
  final VoidCallback? onDetailPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(summary),
            if (facts.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final fact in facts)
                    Text(fact, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              icon: const Icon(Icons.description_outlined),
              label: Text(l10n.reportDetails),
              onPressed:
                  onDetailPressed ?? () => showProductReport(context, details),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showProductReport(BuildContext context, Widget details) =>
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 960,
            maxHeight: MediaQuery.sizeOf(context).height * .85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).reportDetails,
                        style: Theme.of(context).textTheme.titleMedium,
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
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: details,
                ),
              ),
            ],
          ),
        ),
      ),
    );

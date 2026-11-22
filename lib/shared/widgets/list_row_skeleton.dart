import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: AppLocalizations.of(context).listLoading,
    child: ExcludeSemantics(child: ShimmerWrapper(child: child)),
  );
}

class ListRowSkeleton extends StatelessWidget {
  const ListRowSkeleton({
    super.key,
    this.leadingSize = 96,
    this.lineCount = 4,
    this.card = true,
  });
  final double leadingSize;
  final int lineCount;
  final bool card;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: card ? BorderRadius.circular(12) : null,
      border: card ? Border.all(color: AppColors.border) : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingSize > 0) ...[
          ShimmerBox(width: leadingSize, height: leadingSize, radius: 8),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < lineCount; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: i.isEven ? 0.6 : 0.9,
                  child: const ShimmerBox(height: 14, radius: 4),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class ListLoadingSkeleton extends StatelessWidget {
  const ListLoadingSkeleton({
    super.key,
    this.leadingSize = 96,
    this.lineCount = 4,
    this.card = true,
    this.responsiveGrid = false,
  });
  final double leadingSize;
  final int lineCount;
  final bool card;
  final bool responsiveGrid;

  @override
  Widget build(BuildContext context) => LoadingSkeleton(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final columns = !responsiveGrid || constraints.maxWidth < 600
            ? 1
            : constraints.maxWidth < 1000
            ? 2
            : 4;
        final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            for (var i = 0; i < 4; i++)
              SizedBox(
                width: width,
                child: ListRowSkeleton(
                  leadingSize: leadingSize,
                  lineCount: lineCount,
                  card: card,
                ),
              ),
          ],
        );
      },
    ),
  );
}

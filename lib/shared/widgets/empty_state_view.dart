import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/presentation/review_owl_assets.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  }) : assert((primaryActionLabel == null) == (onPrimaryAction == null)),
       assert((secondaryActionLabel == null) == (onSecondaryAction == null)),
       assert(onSecondaryAction == null || onPrimaryAction != null);

  final String title;
  final String message;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final theme = Theme.of(context).textTheme;
      final content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExcludeSemantics(
                  child: Image.asset(
                    ReviewOwlAssets.full,
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.emoji_nature_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onPrimaryAction != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: onPrimaryAction,
                    child: Text(
                      primaryActionLabel!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                if (onSecondaryAction != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  OutlinedButton(
                    onPressed: onSecondaryAction,
                    child: Text(
                      secondaryActionLabel!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
      if (!constraints.hasBoundedHeight) return content;
      return SingleChildScrollView(
        primary: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: content,
        ),
      );
    },
  );
}

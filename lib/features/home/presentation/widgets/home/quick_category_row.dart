import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';

class QuickCategoryRow extends StatelessWidget {
  const QuickCategoryRow({
    required this.items,
    this.onCategoryPressed,
    super.key,
  });

  final List<QuickCategoryData> items;
  final ValueChanged<String>? onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        final spacing = compact ? AppSpacing.xs : AppSpacing.lg;
        // Compact mobile targets keep all categories visible in two rows.
        // Larger text uses three columns to preserve readable labels.
        final columns = MediaQuery.textScalerOf(context).scale(14) > 18 ? 3 : 4;
        final itemWidth = compact
            ? ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                  .clamp(48.0, 94.0)
            : 94.0;

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: compact ? AppSpacing.xs : AppSpacing.md,
            children: [
              for (final item in items)
                SizedBox(
                  width: itemWidth,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: AppRadius.medium,
                    child: InkWell(
                      borderRadius: AppRadius.medium,
                      hoverColor: AppColors.primaryLight,
                      focusColor: AppColors.primaryLight,
                      onTap: onCategoryPressed == null
                          ? null
                          : () => onCategoryPressed!(item.label),
                      child: Semantics(
                        button: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Ink(
                                width: compact ? 48 : 72,
                                height: compact ? 48 : 72,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.xs),
                                  child: ExcludeSemantics(
                                    child: Image.asset(
                                      item.iconAssetPath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: compact ? AppSpacing.xs : AppSpacing.sm,
                              ),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

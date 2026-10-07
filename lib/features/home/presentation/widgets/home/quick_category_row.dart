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
    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final item = items[index];

          return SizedBox(
            width: 94,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onCategoryPressed?.call(item.label),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: item.useIconBacking
                        ? BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F0F172A),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Image.asset(
                        item.iconAssetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

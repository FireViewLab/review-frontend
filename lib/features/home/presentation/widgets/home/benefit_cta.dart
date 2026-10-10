import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class BenefitCTA extends StatelessWidget {
  const BenefitCTA({
    required this.items,
    required this.onBenefitPressed,
    super.key,
  });

  final List<BenefitData> items;
  final VoidCallback onBenefitPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.isMobile ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useInlineGift = constraints.maxWidth >= 520;

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _children(context, constraints.maxWidth),
            );

            if (context.isMobile || !useInlineGift) {
              return Stack(
                children: [
                  content,
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.card_giftcard,
                      color: Color(0x332563EB),
                      size: 72,
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: AppSpacing.xl),
                const Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                  size: 96,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _children(BuildContext context, double maxWidth) {
    final itemWidth = maxWidth < 520 ? 96.0 : 124.0;

    return [
      Text(AppLocalizations.of(context).homeBenefitTitle, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.xs),
      Text(
        AppLocalizations.of(context).homeBenefitSubtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final item in items)
            Container(
              width: itemWidth,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      FilledButton(onPressed: onBenefitPressed, child: Text(AppLocalizations.of(context).homeBenefitButton)),
    ];
  }
}

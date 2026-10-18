import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AspectRatio(aspectRatio: 16 / 9, child: ShimmerBox()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 34,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerBox(width: 64, height: 20, radius: 999),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const SizedBox(height: 14, child: ShimmerBox(radius: 4)),
                  const SizedBox(height: 6),
                  const SizedBox(height: 13, child: ShimmerBox(radius: 4)),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 88, height: 12, radius: 4),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 72, height: 18, radius: 4),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const SizedBox(height: 12, child: ShimmerBox(radius: 4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardGridSkeleton extends StatelessWidget {
  const ProductCardGridSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _columnsFor(constraints.maxWidth);
          final cardWidth =
              (constraints.maxWidth - (columns - 1) * AppSpacing.md) / columns;
          const imageAspectRatio = 16.0 / 9.0;
          final imageHeight = cardWidth / imageAspectRatio;
          const textAreaHeight = 212.0;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: imageHeight + textAreaHeight,
            ),
            itemCount: itemCount,
            itemBuilder: (context, _) => const ProductCardSkeleton(),
          );
        },
      ),
    );
  }

  int _columnsFor(double width) {
    if (width < 480) return 2;
    if (width < 720) return 3;
    if (width < 1020) return 4;
    return 5;
  }
}

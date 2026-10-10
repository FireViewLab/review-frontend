import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/product_card.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class ProductRecommendationSection extends ConsumerWidget {
  const ProductRecommendationSection({
    required this.products,
    this.onProductTap,
    this.onViewAll,
    this.showHeader = true,
    super.key,
  });

  final List<HomeProductData> products;
  final ValueChanged<HomeProductData>? onProductTap;
  final VoidCallback? onViewAll;
  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact =
        ref.watch(confirmedDisplayPreferencesProvider)?.cardDensity ==
        'COMPACT';
    final grid = products.isEmpty
        ? const _ProductEmptyState()
        : LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnsFor(constraints.maxWidth);
              final cardWidth =
                  (constraints.maxWidth - (columns - 1) * AppSpacing.md) /
                  columns;
              const imageAspectRatio = 16.0 / 9.0;
              final imageHeight = cardWidth / imageAspectRatio;
              final textAreaHeight = compact ? 154.0 : 170.0;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisExtent: imageHeight + textAreaHeight,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: onProductTap == null
                        ? null
                        : () => onProductTap?.call(product),
                  );
                },
              );
            },
          );

    if (!showHeader) return grid;

    return _SectionShell(
      title: AppLocalizations.of(context).homeRecommendedTitle,
      icon: Icons.verified_outlined,
      onViewAll: onViewAll,
      child: grid,
    );
  }
}

class _ProductEmptyState extends StatelessWidget {
  const _ProductEmptyState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.isMobile ? 124 : 216),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '추천 상품 API 연결 대기 중',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '임의 상품을 만들지 않고 실제 상품 데이터가 연결되면 카드 목록으로 표시됩니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int _columnsFor(double width) {
  if (width < 480) return 2;
  if (width < 720) return 3;
  if (width < 1020) return 4;
  return 5;
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.icon,
    required this.child,
    this.onViewAll,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (onViewAll != null)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: AppColors.textSecondary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).homeViewAll,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

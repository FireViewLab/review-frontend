import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:url_launcher/url_launcher.dart';

class PriceComparisonTable extends StatefulWidget {
  const PriceComparisonTable({
    super.key,
    required this.comparisons,
    required this.totalSellerCount,
  });

  final List<PriceComparison> comparisons;
  final int totalSellerCount;

  @override
  State<PriceComparisonTable> createState() => _PriceComparisonTableState();
}

class _PriceComparisonTableState extends State<PriceComparisonTable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (MediaQuery.sizeOf(context).width >= 900 &&
              MediaQuery.textScalerOf(context).scale(16) <= 24)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '판매처',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '최저가',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '배송',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 80),
                ],
              ),
            ),
          const Divider(height: 1, color: AppColors.border),
          for (final item
              in (_expanded
                  ? widget.comparisons
                  : widget.comparisons.take(3).toList()))
            _PriceRow(comparison: item),
          const Divider(height: 1, color: AppColors.border),
          _ExpandButton(
            totalCount: widget.totalSellerCount,
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.comparison});

  final PriceComparison comparison;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 900 ||
        MediaQuery.textScalerOf(context).scale(16) > 24) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _SellerLogo(tag: comparison.sellerLogoTag),
                Text(
                  comparison.sellerName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (comparison.isLowest) _LowestBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              formatSearchPrice(comparison.price),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (comparison.deliveryInfo.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                comparison.deliveryInfo,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            _BuyButton(comparison: comparison),
          ],
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _SellerLogo(tag: comparison.sellerLogoTag),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        comparison.sellerName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (comparison.isLowest) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _LowestBadge(),
                    ],
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  formatSearchPrice(comparison.price),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  comparison.deliveryInfo,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 84, child: _BuyButton(comparison: comparison)),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _SellerLogo extends StatelessWidget {
  const _SellerLogo({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final letter = switch (tag) {
      'coupang' => 'C',
      'naver' => 'N',
      '11st' => '11',
      'official' => 'O',
      _ => tag.isNotEmpty ? tag[0].toUpperCase() : '?',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w900,
              fontSize: letter.length > 1 ? 9 : 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _LowestBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          '최저가',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({required this.comparison});

  final PriceComparison comparison;

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    const buttonSize = Size(80, 44);
    const padding = EdgeInsets.symmetric(horizontal: AppSpacing.sm);
    const tapTarget = MaterialTapTargetSize.shrinkWrap;

    void openUrl() {
      final url = comparison.url;
      if (url != null && url.isNotEmpty) {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }

    if (comparison.isLowest) {
      return FilledButton(
        onPressed: openUrl,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: padding,
          minimumSize: buttonSize,

          tapTargetSize: tapTarget,
          shape: shape,
        ),
        child: Text(
          comparison.linkLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      );
    }

    return OutlinedButton(
      onPressed: openUrl,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: padding,
        minimumSize: buttonSize,

        tapTargetSize: tapTarget,
        shape: shape,
      ),
      child: Text(
        comparison.linkLabel,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({
    required this.totalCount,
    required this.expanded,
    required this.onTap,
  });

  final int totalCount;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '전체 $totalCount개 판매처 가격 비교',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

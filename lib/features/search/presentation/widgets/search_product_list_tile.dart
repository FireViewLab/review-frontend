import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_actions.dart';
import 'package:re_view_front/features/search/presentation/widgets/product_rti_badge.dart';

class SearchProductListTile extends StatefulWidget {
  const SearchProductListTile({super.key, required this.product});

  final SearchResultProduct product;

  @override
  State<SearchProductListTile> createState() => _SearchProductListTileState();
}

class _SearchProductListTileState extends State<SearchProductListTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final rtiColor = colorFromHex(product.rtiColor);
    final isCompact = MediaQuery.sizeOf(context).width < 760;
    final image = SizedBox(
      width: isCompact ? 120 : 188,
      height: isCompact ? 92 : 126,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedScale(
              scale: _hovered && !MediaQuery.disableAnimationsOf(context)
                  ? 1.035
                  : 1,
              duration: AppMotion.of(context, AppMotion.fast),
              curve: AppMotion.enter,
              child: AppNetworkImage(
                url: product.imageUrl,
                borderRadius: AppRadius.medium,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: RtiBadge(value: product.avgRti?.round(), color: rtiColor),
          ),
          Positioned.fill(
            child: SearchProductHoverTapLayer(
              onEnter: () => setState(() => _hovered = true),
              onExit: () => setState(() => _hovered = false),
              onTap: () => openSearchProductDetail(context, product),
            ),
          ),
        ],
      ),
    );
    final details = ListTileDetails(product: product);
    final actions = ListTileActions(product: product, compact: isCompact);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => openSearchProductDetail(context, product),
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            curve: AppMotion.enter,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered ? AppColors.primary : AppColors.border,
                width: _hovered ? 1.2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? const Color(0x302563EB)
                      : const Color(0x080F172A),
                  blurRadius: _hovered ? 24 : 8,
                  spreadRadius: _hovered ? 1 : 0,
                  offset: Offset(0, _hovered ? 10 : 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          image,
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: details),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      actions,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      image,
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: details),
                      const SizedBox(width: AppSpacing.md),
                      actions,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ListTileDetails extends StatelessWidget {
  const ListTileDetails({super.key, required this.product});

  final SearchResultProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.platform ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        if (product.subCategory?.isNotEmpty ?? false)
          Text(
            product.subCategory!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            height: 1.25,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.avgRating != null)
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  product.avgRating?.toStringAsFixed(1) ?? '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  product.reviewCount == null
                      ? ''
                      : '(리뷰 ${formatSearchCount(product.reviewCount)})',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ListTileActions extends StatelessWidget {
  const ListTileActions({
    super.key,
    required this.product,
    required this.compact,
  });

  final SearchResultProduct product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? double.infinity : 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            formatSearchPrice(product.price),
            textAlign: compact ? TextAlign.left : TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              SearchProductWishlistButton(productId: product.id),
              const SizedBox(width: AppSpacing.xs),
              SearchProductCartButton(productId: product.id),
            ],
          ),
        ],
      ),
    );
  }
}

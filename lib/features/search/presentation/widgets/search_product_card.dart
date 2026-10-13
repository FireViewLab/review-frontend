import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_actions.dart';
import 'package:re_view_front/features/search/presentation/widgets/product_rti_badge.dart';

class SearchProductCard extends StatefulWidget {
  const SearchProductCard({super.key, required this.product});

  final SearchResultProduct product;

  @override
  State<SearchProductCard> createState() => _SearchProductCardState();
}

class _SearchProductCardState extends State<SearchProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final rtiColor = colorFromHex(product.rtiColor);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
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
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => openSearchProductDetail(context, product),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale:
                            _hovered && !MediaQuery.disableAnimationsOf(context)
                            ? 1.035
                            : 1,
                        duration: AppMotion.of(context, AppMotion.fast),
                        curve: AppMotion.enter,
                        child: AppNetworkImage(
                          url: product.imageUrl,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(9),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: SearchProductHoverTapLayer(
                          onEnter: () => setState(() => _hovered = true),
                          onExit: () => setState(() => _hovered = false),
                          onTap: () =>
                              openSearchProductDetail(context, product),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // RTI 배지는 이미지 위에 겹치지 않고 정보 영역에 둔다.
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.platform ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          RtiBadge(
                            value: product.avgRti?.round(),
                            color: rtiColor,
                          ),
                        ],
                      ),
                      if (product.subCategory?.isNotEmpty ?? false)
                        Text(
                          product.subCategory!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    height: 1.22,
                                  ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          SearchProductQuickActions(productId: product.id),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          if (product.avgRating != null)
                            const Icon(
                              Icons.star,
                              color: Color(0xFFF59E0B),
                              size: 13,
                            ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            product.avgRating?.toStringAsFixed(1) ?? '',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Flexible(
                            child: Text(
                              product.reviewCount == null
                                  ? ''
                                  : '(리뷰 ${formatSearchCount(product.reviewCount)})',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatSearchPrice(product.price),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchProductHoverTapLayer extends StatelessWidget {
  const SearchProductHoverTapLayer({
    super.key,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  });

  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: const ColoredBox(color: Colors.transparent),
      ),
    );
  }
}

void openSearchProductDetail(
  BuildContext context,
  SearchResultProduct product,
) {
  context.go(product.detailPath, extra: product.routeContext);
}

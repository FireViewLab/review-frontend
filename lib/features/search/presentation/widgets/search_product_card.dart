import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

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
            onTap: () => _openProductDetail(context, product.id),
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
                        child: AppNetworkImage(url: product.imageUrl),
                      ),
                      Positioned(
                        top: AppSpacing.xs,
                        right: AppSpacing.xs,
                        child: RtiBadge(
                          value: product.avgRti.round(),
                          color: rtiColor,
                        ),
                      ),
                      Positioned.fill(
                        child: _HoverTapLayer(
                          onEnter: () => setState(() => _hovered = true),
                          onExit: () => setState(() => _hovered = false),
                          onTap: () => _openProductDetail(context, product.id),
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
                          _ProductQuickActions(productId: product.id),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF59E0B),
                            size: 13,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            product.avgRating.toStringAsFixed(1),
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
                              '(리뷰 ${formatSearchCount(product.reviewCount)})',
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

class _HoverTapLayer extends StatelessWidget {
  const _HoverTapLayer({
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

void _openProductDetail(BuildContext context, int productId) {
  context.goNamed(
    RouteNames.productDetail,
    pathParameters: {'id': productId.toString()},
  );
}

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
            child: RtiBadge(value: product.avgRti.round(), color: rtiColor),
          ),
          Positioned.fill(
            child: _HoverTapLayer(
              onEnter: () => setState(() => _hovered = true),
              onExit: () => setState(() => _hovered = false),
              onTap: () => _openProductDetail(context, product.id),
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
          onTap: () => _openProductDetail(context, product.id),
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
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 15),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  product.avgRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '(리뷰 ${formatSearchCount(product.reviewCount)})',
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
              _WishlistSquareButton(productId: product.id),
              const SizedBox(width: AppSpacing.xs),
              _CartSquareButton(productId: product.id),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductQuickActions extends StatelessWidget {
  const _ProductQuickActions({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WishlistSquareButton(productId: productId),
        const SizedBox(width: AppSpacing.xs),
        _CartSquareButton(productId: productId),
      ],
    );
  }
}

class RtiBadge extends StatelessWidget {
  const RtiBadge({super.key, required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_outlined, color: color, size: 14),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'RTI $value',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryBadge extends StatelessWidget {
  const DeliveryBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class ProductTraitChip extends StatelessWidget {
  const ProductTraitChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: outlineHoverButtonStyle(padding: EdgeInsets.zero),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

ButtonStyle outlineHoverButtonStyle({required EdgeInsetsGeometry padding}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all(padding),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primaryLight
          : AppColors.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.hovered)
          ? AppColors.primary
          : AppColors.textPrimary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      return BorderSide(
        color: states.contains(WidgetState.hovered)
            ? AppColors.primary
            : AppColors.borderStrong,
      );
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.small),
    ),
  );
}

class _WishlistSquareButton extends ConsumerWidget {
  const _WishlistSquareButton({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(wishlistButtonProvider(productId));
    final liked = asyncStatus.value ?? false;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return SizedBox.square(
      dimension: 36,
      child: OutlinedButton(
        onPressed: asyncStatus.isLoading
            ? null
            : () {
                if (!isLoggedIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그인이 필요합니다.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                ref.read(wishlistButtonProvider(productId).notifier).toggle();
              },
        style: _wishlistButtonStyle(liked),
        child: AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.fast),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(liked),
            size: 18,
          ),
        ),
      ),
    );
  }

  ButtonStyle _wishlistButtonStyle(bool liked) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (liked) return const Color(0xFFFFF0F0);
        return states.contains(WidgetState.hovered)
            ? AppColors.primaryLight
            : AppColors.surface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (liked) return const Color(0xFFEF4444);
        return states.contains(WidgetState.hovered)
            ? AppColors.primary
            : AppColors.textPrimary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: liked
              ? const Color(0xFFEF4444)
              : states.contains(WidgetState.hovered)
              ? AppColors.primary
              : AppColors.borderStrong,
        );
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: AppRadius.small),
      ),
    );
  }
}

class _CartSquareButton extends ConsumerStatefulWidget {
  const _CartSquareButton({required this.productId});

  final int productId;

  @override
  ConsumerState<_CartSquareButton> createState() => _CartSquareButtonState();
}

class _CartSquareButtonState extends ConsumerState<_CartSquareButton> {
  bool _loading = false;

  Future<void> _addToCart() async {
    if (_loading) return;
    if (!ref.read(isLoggedInProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final alreadyInCart =
        ref.read(cartButtonProvider(widget.productId)).value ?? false;
    if (alreadyInCart) return;

    setState(() => _loading = true);

    await ref.read(cartButtonProvider(widget.productId).notifier).add();

    if (!mounted) return;
    setState(() => _loading = false);

    final inCart =
        ref.read(cartButtonProvider(widget.productId)).value ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(inCart ? '장바구니에 담겼습니다.' : '장바구니 담기에 실패했습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncStatus = ref.watch(cartButtonProvider(widget.productId));
    final inCart = asyncStatus.value ?? false;

    return SizedBox.square(
      dimension: 36,
      child: OutlinedButton(
        onPressed: _loading || inCart || asyncStatus.isLoading
            ? null
            : _addToCart,
        style: _cartButtonStyle(inCart),
        child: _loading || asyncStatus.isLoading
            ? SizedBox.square(
                dimension: 14,
                child: TickerMode(
                  enabled: !MediaQuery.disableAnimationsOf(context),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.fast),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  inCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                  key: ValueKey(inCart),
                  size: 18,
                ),
              ),
      ),
    );
  }

  ButtonStyle _cartButtonStyle(bool inCart) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (inCart) return AppColors.primaryLight;
        return states.contains(WidgetState.hovered)
            ? AppColors.primaryLight
            : AppColors.surface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (inCart) return AppColors.primary;
        return states.contains(WidgetState.hovered)
            ? AppColors.primary
            : AppColors.textPrimary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: inCart
              ? AppColors.primary
              : states.contains(WidgetState.hovered)
              ? AppColors.primary
              : AppColors.borderStrong,
        );
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: AppRadius.small),
      ),
    );
  }
}

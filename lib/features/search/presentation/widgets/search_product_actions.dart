import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

class SearchProductQuickActions extends StatelessWidget {
  const SearchProductQuickActions({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchProductWishlistButton(productId: productId),
        const SizedBox(width: AppSpacing.xs),
        SearchProductCartButton(productId: productId),
      ],
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

class SearchProductWishlistButton extends ConsumerWidget {
  const SearchProductWishlistButton({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(wishlistButtonProvider(productId));
    final liked = asyncStatus.value ?? false;

    return SizedBox.square(
      dimension: 36,
      child: OutlinedButton(
        onPressed: asyncStatus.isLoading
            ? null
            : () async {
                if (!ref.read(authSessionProvider).isLoggedIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그인이 필요합니다.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                final session = ref.read(authSessionProvider);
                final error = await ref
                    .read(wishlistButtonProvider(productId).notifier)
                    .toggle();
                if (context.mounted &&
                    ref.read(authSessionProvider) == session &&
                    error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
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

class SearchProductCartButton extends ConsumerStatefulWidget {
  const SearchProductCartButton({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<SearchProductCartButton> createState() =>
      _CartSquareButtonState();
}

class _CartSquareButtonState extends ConsumerState<SearchProductCartButton> {
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

    final session = ref.read(authSessionProvider);
    setState(() => _loading = true);

    await ref.read(cartButtonProvider(widget.productId).notifier).add();

    if (!mounted) return;
    setState(() => _loading = false);
    if (ref.read(authSessionProvider) != session) return;

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

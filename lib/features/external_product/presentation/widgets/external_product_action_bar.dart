import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_actions_view_model.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_action_notice.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ExternalProductActionBar extends StatelessWidget {
  const ExternalProductActionBar({
    super.key,
    required this.product,
    this.springProductId,
  });
  final ExternalProductRef product;
  final int? springProductId;
  @override
  Widget build(BuildContext context) => _ExternalProductActionBar(
    key: ValueKey((product, springProductId)),
    product: product,
    springProductId: springProductId,
  );
}

class _ExternalProductActionBar extends ConsumerWidget {
  const _ExternalProductActionBar({
    super.key,
    required this.product,
    this.springProductId,
  });
  final ExternalProductRef product;
  final int? springProductId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = externalActionsProvider((
      product: product,
      springProductId: springProductId,
    ));
    final state = ref.watch(provider);
    final l = AppLocalizations.of(context);
    Future<void> act(bool wishlist) async {
      if (!ref.read(isLoggedInProvider)) {
        context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
        return;
      }
      final result = await ref.read(provider.notifier).act(wishlist: wishlist);
      if (!context.mounted || !ref.exists(provider)) return;
      if (!ref.read(isLoggedInProvider)) {
        context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
        return;
      }
      showExternalActionResult(context, product, result);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: state.busy || state.initializing ? null : () => act(true),
          icon: Icon(state.wished ? Icons.favorite : Icons.favorite_border),
          label: Text(state.wished ? l.externalWishRemove : l.externalWishAdd),
        ),
        FilledButton.icon(
          onPressed: state.busy || state.initializing || state.cartAdded
              ? null
              : () => act(false),
          icon: const Icon(Icons.shopping_cart_outlined),
          label: Text(
            state.cartAdded ? l.externalCartAdded : l.externalCartAdd,
          ),
        ),
      ],
    );
  }
}

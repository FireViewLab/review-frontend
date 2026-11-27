import 'package:re_view_front/shared/widgets/empty_state_view.dart';
import 'package:re_view_front/shared/widgets/list_row_skeleton.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_view_model.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/payments/domain/entities/cart_checkout.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';
import 'package:re_view_front/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:re_view_front/features/cart/presentation/widgets/cart_list_header.dart';
import 'package:re_view_front/features/cart/presentation/widgets/cart_order_summary.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartViewModelProvider.notifier).load());
  }

  Future<void> _removeItem(int productId) async {
    final session = ref.read(authSessionProvider);
    final state = ref.read(cartViewModelProvider);
    if (state is! CartSuccess || state.isUpdating) return;
    final item = state.items.where((i) => i.productId == productId).firstOrNull;
    if (item == null) return;
    final result = await ref
        .read(cartViewModelProvider.notifier)
        .removeItem(productId);
    if (!mounted ||
        ref.read(authSessionProvider) != session ||
        result is! Success<void>) {
      return;
    }
    _showRemoved([item]);
  }

  Future<void> _saveForLater(int productId) async {
    final session = ref.read(authSessionProvider);
    final result = await ref
        .read(cartViewModelProvider.notifier)
        .saveToWishlist(productId, removeFromCart: true);
    if (!mounted ||
        ref.read(authSessionProvider) != session ||
        result == null ||
        !result.isSaved ||
        result.cartRemoval is! FailureResult<void>) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.cartWishlistRemovalFailed),
        action: SnackBarAction(
          label: l10n.cartRetryRemoval,
          onPressed: () {
            if (mounted && ref.read(authSessionProvider) == session) {
              _removeItem(productId);
            }
          },
        ),
      ),
    );
  }

  Future<void> _removeSelected() async {
    final session = ref.read(authSessionProvider);
    final result = await ref
        .read(cartViewModelProvider.notifier)
        .removeSelected();
    if (!mounted ||
        ref.read(authSessionProvider) != session ||
        result == null ||
        result.items.isEmpty) {
      return;
    }
    _showRemoved(result.items, errorMessage: result.errorMessage);
  }

  void _showRemoved(List<CartItem> items, {String? errorMessage}) {
    final session = ref.read(authSessionProvider);
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final container = ProviderScope.containerOf(context, listen: false);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          errorMessage == null
              ? l.cartRemoved
              : '${l.cartRemoved}\n$errorMessage',
        ),
        action: CartViewModel.canRestore(items)
            ? SnackBarAction(
                label: l.actionUndo,
                onPressed: () async {
                  if (!messenger.mounted ||
                      container.read(authSessionProvider) != session) {
                    return;
                  }
                  final result = await container
                      .read(cartViewModelProvider.notifier)
                      .restoreItems(items);
                  if (!messenger.mounted ||
                      container.read(authSessionProvider) != session) {
                    return;
                  }
                  if (result is! Success<void>) {
                    final message = result is FailureResult<void>
                        ? result.failure.message
                        : l.failureMessageUnknown;
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(SnackBar(content: Text(message)));
                  }
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1760,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.lg,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (cartState) {
                CartLoading() || CartInitial() => const _CartSkeleton(),
                CartFailure(:final failure) => SizedBox(
                  height: 320,
                  child: AppErrorView(
                    failure: failure,
                    onRetry: () =>
                        ref.read(cartViewModelProvider.notifier).load(),
                  ),
                ),
                CartEmpty() => _CartEmptyBody(
                  onGoHome: () => context.go(RoutePaths.home),
                ),
                CartSuccess() => _CartBody(
                  cartState: cartState,
                  onRemove: _removeItem,
                  onSaveForLater: _saveForLater,
                  onRemoveSelected: _removeSelected,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({
    required this.cartState,
    required this.onRemove,
    required this.onSaveForLater,
    required this.onRemoveSelected,
  });

  final CartSuccess cartState;
  final ValueChanged<int> onRemove;
  final ValueChanged<int> onSaveForLater;
  final VoidCallback onRemoveSelected;

  Future<void> _showPurchaseChoices(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).cartSellersTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).cartSellersDescription),
              for (final item in cartState.selectedItems)
                ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    AppLocalizations.of(context).cartViewProductAndSeller,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    context.push(item.detailPath, extra: item.routeContext);
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(AppLocalizations.of(context).reportClose),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(cartViewModelProvider.notifier);
    final isMobile = context.isMobile;
    final isNarrow = MediaQuery.sizeOf(context).width < 1080;

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CartPageHeader(totalCount: cartState.items.length),
        if (cartState.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            cartState.errorMessage!,
            style: const TextStyle(color: AppColors.error),
          ),
          TextButton(
            onPressed: cartState.isUpdating ? null : () => vm.load(),
            child: Text(AppLocalizations.of(context).onboardingReload),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _RtiCheckBanner(),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              CartListHeader(
                totalCount: cartState.items.length,
                selectedCount: cartState.selectedIds.length,
                isAllSelected: cartState.isAllSelected,
                onToggleSelectAll: vm.toggleSelectAll,
                onDeleteSelected: onRemoveSelected,
              ),
              const Divider(height: 1, color: AppColors.border),
              for (final item in cartState.items)
                CartItemCard(
                  item: item,
                  isSelected: cartState.selectedIds.contains(item.productId),
                  isUpdating: cartState.isUpdating,
                  onToggleSelect: () => vm.toggleSelectItem(item.productId),
                  onQuantityChanged: (qty) =>
                      vm.updateQuantity(item.productId, qty),
                  onRemove: () => onRemove(item.productId),
                  onMoveToWishlist: () => vm.saveToWishlist(item.productId),
                  onSaveForLater: () => onSaveForLater(item.productId),
                ),
            ],
          ),
        ),
      ],
    );

    if (isNarrow || isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          leftColumn,
          const SizedBox(height: AppSpacing.lg),
          CartOrderSummary(
            summary: cartState.selectedSummary,
            selectedCount: cartState.selectedIds.length,
            hasUnknownPrice: cartState.hasUnknownSelectedPrice,
            isUpdating: cartState.isUpdating,
            onCheckout: () => _showPurchaseChoices(context),
            onTestCheckout: () => context.push(
              RoutePaths.cartCheckout,
              extra: CartCheckoutSelection(
                cartState.selectedItems,
                ref.read(authSessionProvider).revision,
              ),
            ),
            onContinueShopping: () => context.go(RoutePaths.home),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: leftColumn),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 300,
          child: CartOrderSummary(
            summary: cartState.selectedSummary,
            selectedCount: cartState.selectedIds.length,
            hasUnknownPrice: cartState.hasUnknownSelectedPrice,
            isUpdating: cartState.isUpdating,
            onCheckout: () => _showPurchaseChoices(context),
            onTestCheckout: () => context.push(
              RoutePaths.cartCheckout,
              extra: CartCheckoutSelection(
                cartState.selectedItems,
                ref.read(authSessionProvider).revision,
              ),
            ),
            onContinueShopping: () => context.go(RoutePaths.home),
          ),
        ),
      ],
    );
  }
}

class _CartPageHeader extends StatelessWidget {
  const _CartPageHeader({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).headerCart,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                AppLocalizations.of(context).cartDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          AppLocalizations.of(context).cartTotalProducts(totalCount),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RtiCheckBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: AppRadius.small,
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.xs),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).cartTrustCheckTitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).cartTrustCheckDescription,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _CartEmptyBody extends StatelessWidget {
  const _CartEmptyBody({required this.onGoHome});
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStateView(
      title: l10n.cartEmptyTitle,
      message: l10n.cartEmptyDescription,
      primaryActionLabel: l10n.wishlistBrowse,
      onPrimaryAction: onGoHome,
      secondaryActionLabel: l10n.emptyViewWishlist,
      onSecondaryAction: () => context.go(RoutePaths.wishlist),
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  const _CartSkeleton();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return LoadingSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 4; i++) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 20, height: 20, radius: 4),
                    const SizedBox(width: AppSpacing.sm),
                    ShimmerBox(
                      width: isMobile ? 120 : 100,
                      height: isMobile ? 92 : 80,
                      radius: 8,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          SizedBox(height: 14, child: ShimmerBox(radius: 4)),
                          SizedBox(height: 6),
                          ShimmerBox(width: 120, height: 12, radius: 4),
                          SizedBox(height: AppSpacing.sm),
                          ShimmerBox(width: 80, height: 18, radius: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

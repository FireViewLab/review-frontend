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
                    message: failure.message,
                    onRetry: () =>
                        ref.read(cartViewModelProvider.notifier).load(),
                  ),
                ),
                CartEmpty() => _CartEmptyBody(
                  onGoHome: () => context.go(RoutePaths.home),
                ),
                CartSuccess() => _CartBody(cartState: cartState),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.cartState});

  final CartSuccess cartState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(cartViewModelProvider.notifier);
    final isMobile = context.isMobile;
    final isNarrow = MediaQuery.sizeOf(context).width < 1080;

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CartPageHeader(totalCount: cartState.items.length),
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
                onDeleteSelected: () => vm.removeSelected(),
              ),
              const Divider(height: 1, color: AppColors.border),
              for (final item in cartState.items)
                CartItemCard(
                  item: item,
                  isSelected: cartState.selectedIds.contains(item.productId),
                  isUpdating: cartState.updatingProductIds.contains(
                    item.productId,
                  ),
                  onToggleSelect: () => vm.toggleSelectItem(item.productId),
                  onQuantityChanged: (qty) =>
                      vm.updateQuantity(item.productId, qty),
                  onRemove: () => vm.removeItem(item.productId),
                  onMoveToWishlist: () {},
                  onSaveForLater: () {},
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
            onCheckout: () async {},
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
            onCheckout: () async {},
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
                '장바구니',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '담아둔 상품을 확인하고 주문 전 리뷰 신뢰도도 함께 비교하세요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          '총 $totalCount개 상품',
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
                borderRadius: BorderRadius.circular(8),
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
                    '리뷰 신뢰도 체크',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '제품별 RTI 지수를 확인하고, 신뢰할 수 있는 리뷰가 많은 상품을 선택해보세요.',
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
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '장바구니가 비어 있습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '마음에 드는 상품을 담아보세요.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(onPressed: onGoHome, child: const Text('쇼핑 계속하기')),
        ],
      ),
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  const _CartSkeleton();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return ShimmerWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 3; i++) ...[
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

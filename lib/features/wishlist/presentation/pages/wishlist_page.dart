import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_filter_bar.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_product_card.dart';
import 'package:re_view_front/features/wishlist/presentation/widgets/wishlist_summary_card.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  WishlistFilterOption _selectedFilter = WishlistFilterOption.all;
  WishlistSortOption _sortOption = WishlistSortOption.recent;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wishlistViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1760,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.lg,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: switch (wishlistState) {
                WishlistLoading() ||
                WishlistInitial() => const _WishlistGridSkeleton(),
                WishlistFailure(:final failure) => SizedBox(
                  height: 320,
                  child: AppErrorView(
                    message: failure.message,
                    onRetry: () =>
                        ref.read(wishlistViewModelProvider.notifier).load(),
                  ),
                ),
                WishlistEmpty() => _WishlistEmptyBody(
                  onGoHome: () => context.go(RoutePaths.home),
                ),
                WishlistSuccess(
                  :final items,
                  :final summary,
                  :final togglingProductIds,
                ) =>
                  _WishlistBody(
                    items: items,
                    summary: summary,
                    togglingProductIds: togglingProductIds,
                    selectedFilter: _selectedFilter,
                    sortOption: _sortOption,
                    onFilterSelected: (f) =>
                        setState(() => _selectedFilter = f),
                    onSortChanged: (s) => setState(() => _sortOption = s),
                    onRemove: (productId) => ref
                        .read(wishlistViewModelProvider.notifier)
                        .removeItem(productId),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistBody extends StatelessWidget {
  const _WishlistBody({
    required this.items,
    required this.summary,
    required this.togglingProductIds,
    required this.selectedFilter,
    required this.sortOption,
    required this.onFilterSelected,
    required this.onSortChanged,
    required this.onRemove,
  });

  final List<WishlistItem> items;
  final WishlistSummary summary;
  final Set<int> togglingProductIds;
  final WishlistFilterOption selectedFilter;
  final WishlistSortOption sortOption;
  final ValueChanged<WishlistFilterOption> onFilterSelected;
  final ValueChanged<WishlistSortOption> onSortChanged;
  final ValueChanged<int> onRemove;

  List<WishlistItem> get _filtered {
    var result = switch (selectedFilter) {
      WishlistFilterOption.all => [...items],
      WishlistFilterOption.priceDrop =>
        items.where((i) => i.isPriceDrop).toList(),
      WishlistFilterOption.rti => [
        ...items,
      ]..sort((a, b) => (b.avgRti ?? -1).compareTo(a.avgRti ?? -1)),
      WishlistFilterOption.lowestPrice => [
        ...items,
      ]..sort((a, b) => a.price.compareTo(b.price)),
      WishlistFilterOption.brand => [...items],
      WishlistFilterOption.category => [...items],
    };

    switch (sortOption) {
      case WishlistSortOption.recent:
        result.sort(
          (a, b) =>
              (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)),
        );
      case WishlistSortOption.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
      case WishlistSortOption.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
      case WishlistSortOption.rti:
        result.sort((a, b) => (b.avgRti ?? -1).compareTo(a.avgRti ?? -1));
      case WishlistSortOption.reviewCount:
        result.sort(
          (a, b) => (b.reviewCount ?? -1).compareTo(a.reviewCount ?? -1),
        );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _filtered;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WishlistPageHeader(totalCount: items.length),
        const SizedBox(height: AppSpacing.md),
        if (!isMobile)
          WishlistSummaryCard(summary: summary, totalCount: items.length),
        if (!isMobile) const SizedBox(height: AppSpacing.md),
        WishlistFilterBar(
          items: items,
          selectedFilter: selectedFilter,
          sortOption: sortOption,
          onFilterSelected: onFilterSelected,
          onSortChanged: onSortChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          WishlistSummaryCard(summary: summary, totalCount: items.length),
        if (isMobile) const SizedBox(height: AppSpacing.md),
        if (displayItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
            child: Center(
              child: Text(
                AppLocalizations.of(context).wishlistFilteredEmpty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          _WishlistGrid(
            items: displayItems,
            togglingProductIds: togglingProductIds,
            onRemove: onRemove,
          ),
      ],
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  const _WishlistGrid({
    required this.items,
    required this.togglingProductIds,
    required this.onRemove,
  });

  final List<WishlistItem> items;
  final Set<int> togglingProductIds;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      >= 1400 => 6,
      >= 1100 => 5,
      >= 860 => 4,
      >= 600 => 3,
      >= 400 => 2,
      _ => 2,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return WishlistProductCard(
          item: item,
          isToggling: togglingProductIds.contains(item.productId),
          onRemove: () => onRemove(item.productId),
        );
      },
    );
  }
}

class _WishlistPageHeader extends StatelessWidget {
  const _WishlistPageHeader({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).wishlistTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          AppLocalizations.of(context).wishlistSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(Icons.favorite, size: 14, color: AppColors.error),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              AppLocalizations.of(context).wishlistCount(totalCount),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WishlistEmptyBody extends StatelessWidget {
  const _WishlistEmptyBody({required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context).wishlistEmpty,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context).wishlistEmptyDesc,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: onGoHome,
            child: Text(AppLocalizations.of(context).wishlistBrowse),
          ),
        ],
      ),
    );
  }
}

class _WishlistGridSkeleton extends StatelessWidget {
  const _WishlistGridSkeleton();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (width) {
      >= 1400 => 6,
      >= 1100 => 5,
      >= 860 => 4,
      >= 600 => 3,
      _ => 2,
    };

    return ShimmerWrapper(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.62,
        ),
        itemCount: crossAxisCount * 2,
        itemBuilder: (context, _) => const _WishlistCardSkeleton(),
      ),
    );
  }
}

class _WishlistCardSkeleton extends StatelessWidget {
  const _WishlistCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: ShimmerBox()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 52, height: 11, radius: 3),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 13, child: ShimmerBox(radius: 3)),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 90, height: 13, radius: 3),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const ShimmerBox(width: 64, height: 19, radius: 3),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: const [
                      ShimmerBox(width: 36, height: 36, radius: 6),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ShimmerBox(radius: 6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

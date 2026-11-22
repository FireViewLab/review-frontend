import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/list_row_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import '../providers/price_watch_providers.dart';

class PriceWatchSliver extends ConsumerWidget {
  const PriceWatchSliver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(priceWatchRepositoryProvider);
    final wishlist = ref.watch(wishlistViewModelProvider);
    final items = wishlist is WishlistSuccess ? wishlist.items : null;
    final drops = items
        ?.where((item) => item.isPriceDrop)
        .toList(growable: false);
    final known =
        items?.where((item) => item.hasPriceDropInformation).length ?? 0;
    final loading = wishlist is WishlistInitial || wishlist is WishlistLoading;
    final failed = wishlist is WishlistFailure
        ? wishlist.failure.message
        : wishlist is WishlistSuccess
        ? wishlist.errorMessage
        : null;
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).priceWatchTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(repository.unavailableReason),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context).priceWatchHistoryNotice),
              if (failed != null)
                Text(AppLocalizations.of(context).priceWatchLoadFailed(failed)),
              if (items != null && known > 0)
                Text(
                  AppLocalizations.of(
                    context,
                  ).priceWatchDropCounts(items.length, known, drops!.length),
                )
              else if (!loading && failed == null)
                Text(
                  AppLocalizations.of(context).priceWatchComparisonUnavailable,
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: loading
                        ? null
                        : () => ref
                              .read(wishlistViewModelProvider.notifier)
                              .load(),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      AppLocalizations.of(
                        context,
                      ).priceWatchRefreshWishlistPrices,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.wishlist),
                    child: Text(
                      AppLocalizations.of(context).priceWatchViewWishlist,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(
                      context,
                    ).priceWatchSubscriptionNotice,
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).priceWatchSubscriptionUnavailable,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (loading)
          const SliverToBoxAdapter(
            child: ListLoadingSkeleton(
              leadingSize: 24,
              lineCount: 2,
              card: false,
            ),
          ),
        SliverList.builder(
          itemCount: drops?.length ?? 0,
          itemBuilder: (context, index) {
            final item = drops![index];
            return ListTile(
              key: ValueKey(item.productId),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.trending_down),
              title: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                AppLocalizations.of(context).priceWatchDropIndicator,
              ),
              onTap: () =>
                  context.go(item.detailPath, extra: item.routeContext),
            );
          },
        ),
      ],
    );
  }
}

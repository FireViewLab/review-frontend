import 'package:re_view_front/shared/widgets/empty_state_view.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/list_row_skeleton.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/personal_products_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/recent_products/presentation/providers/recent_products_providers.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_saved_products.dart';

String _scope(BuildContext context) =>
    AppLocalizations.of(context).recentProductsScope(10);

void showRecentProducts(BuildContext context) =>
    context.push(RoutePaths.recentProducts);

class RecentProductsSection extends ConsumerWidget {
  const RecentProductsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context).myPageSideNavRecentlyViewed,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () => showRecentProducts(context),
            child: Text(AppLocalizations.of(context).actionViewAll),
          ),
        ],
      ),
      Text(_scope(context)),
      const SizedBox(height: 12),
      _RecentBody(all: false),
    ],
  );
}

class RecentProductsPage extends ConsumerWidget {
  const RecentProductsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => PersonalProductsPage(
    title: AppLocalizations.of(context).myPageSideNavRecentlyViewed,
    scope: _scope(context),
    onRefresh: () => ref.invalidate(recentProductsProvider),
    sliver: const _RecentBody(all: true),
  );
}

class _RecentBody extends ConsumerWidget {
  const _RecentBody({required this.all});
  final bool all;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentProductsProvider);
    Widget status(Widget child) =>
        all ? SliverToBoxAdapter(child: child) : child;
    // Account changes rebuild this provider with no previous account's history.
    if (state.isLoading && !state.hasValue) {
      return status(const ListLoadingSkeleton());
    }
    if (state.isLoading) {
      return status(
        const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (state.hasError) {
      return status(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).recentProductsLoadFailed),
            TextButton(
              onPressed: () => ref.invalidate(recentProductsProvider),
              child: Text(AppLocalizations.of(context).actionRetry),
            ),
          ],
        ),
      );
    }
    final items = state.value ?? const <SearchResultProduct>[];
    if (items.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return status(
        EmptyStateView(
          title: l10n.recentProductsEmptyTitle,
          message: l10n.recentProductsEmptyDescription,
          primaryActionLabel: l10n.wishlistBrowse,
          onPrimaryAction: () => context.go(RoutePaths.home),
        ),
      );
    }
    Widget card(SearchResultProduct item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MyPageCompactProductCard(
        title: item.name,
        subtitle:
            normalizeSearchPlatform(item.platform) ?? item.categoryDisplayName,
        imageUrl: item.imageUrl,
        price: item.price,
        rating: item.avgRating,
        reviewCount: item.reviewCount,
        rtiLabel: item.analysisDisplay.badgeText(context),
        onTap: () {
          context.go(item.detailPath, extra: item.routeContext);
        },
      ),
    );
    if (all) {
      return SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => card(items[index]),
      );
    }
    return Column(children: [for (final item in items.take(2)) card(item)]);
  }
}

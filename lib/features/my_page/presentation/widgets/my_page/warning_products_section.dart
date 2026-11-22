import 'package:re_view_front/shared/widgets/empty_state_view.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/list_row_skeleton.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'my_page_saved_products.dart';
import 'personal_products_page.dart';
import 'package:re_view_front/app/router/route_paths.dart';

String _scope(BuildContext context) =>
    AppLocalizations.of(context).myPageWarningScope;

void showWarningProducts(BuildContext context) =>
    context.push(RoutePaths.warningProducts);

class WarningProductsSection extends ConsumerWidget {
  const WarningProductsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistViewModelProvider);
    final count = state is WishlistSuccess
        ? state.items.where((item) => item.needsAttention).length
        : state is WishlistEmpty
        ? 0
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context).myPageSideNavRiskyProducts,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () => showWarningProducts(context),
              child: Text(
                count == null
                    ? AppLocalizations.of(context).myPageCheckList
                    : AppLocalizations.of(context).myPageViewListCount(count),
              ),
            ),
          ],
        ),
        Text(_scope(context)),
      ],
    );
  }
}

class WarningProductsPage extends ConsumerStatefulWidget {
  const WarningProductsPage({super.key});
  @override
  ConsumerState<WarningProductsPage> createState() =>
      WarningProductsPageState();
}

class WarningProductsPageState extends ConsumerState<WarningProductsPage> {
  String? _grade;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wishlistViewModelProvider);
    final items = state is WishlistSuccess
        ? state.items
              .where(
                (item) =>
                    item.needsAttention &&
                    (_grade == null ||
                        item.rtiGrade?.trim().toUpperCase() == _grade),
              )
              .toList(growable: false)
        : const <WishlistItem>[];
    final failed = state is WishlistFailure
        ? state.failure.message
        : state is WishlistSuccess
        ? state.errorMessage
        : null;
    return PersonalProductsPage(
      title: AppLocalizations.of(context).myPageSideNavRiskyProducts,
      scope: _scope(context),
      onRefresh: () => ref.read(wishlistViewModelProvider.notifier).load(),
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in <String?, String>{
                null: AppLocalizations.of(context).myPageAllWarnings,
                'SUSPICIOUS': AppLocalizations.of(context).adminSuspicious,
                'DANGER': AppLocalizations.of(context).adminDanger,
              }.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: _grade == entry.key,
                  onSelected: (_) => setState(() => _grade = entry.key),
                ),
            ],
          ),
          if (failed != null) ...[
            Text(failed),
            TextButton(
              onPressed: () =>
                  ref.read(wishlistViewModelProvider.notifier).load(),
              child: Text(AppLocalizations.of(context).actionRetry),
            ),
          ],
        ],
      ),
      sliver: state is WishlistLoading || state is WishlistInitial
          ? const SliverToBoxAdapter(child: ListLoadingSkeleton())
          : items.isEmpty
          ? SliverToBoxAdapter(
              child: failed != null
                  ? Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        AppLocalizations.of(context).myPageLoadFailed,
                      ),
                    )
                  : EmptyStateView(
                      title: _grade == null
                          ? AppLocalizations.of(
                              context,
                            ).warningProductsEmptyTitle
                          : AppLocalizations.of(
                              context,
                            ).warningProductsFilteredEmptyTitle,
                      message: AppLocalizations.of(
                        context,
                      ).warningProductsEmptyDescription,
                      primaryActionLabel: AppLocalizations.of(
                        context,
                      ).wishlistBrowse,
                      onPrimaryAction: () => context.go(RoutePaths.home),
                    ),
            )
          : SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MyPageCompactProductCard(
                    title: item.name,
                    subtitle: item.platform ?? item.categoryDisplayName ?? '',
                    imageUrl: item.imageUrl,
                    price: item.price,
                    rating: item.avgRating,
                    reviewCount: item.reviewCount,
                    rtiLabel: item.analysisDisplay.isV2
                        ? '${item.analysisDisplay.gradeLabel(context) ?? ''} · ${item.analysisDisplay.badgeText(context)}'
                        : '${item.rtiGrade?.trim().toUpperCase() == 'DANGER' ? AppLocalizations.of(context).adminDanger : AppLocalizations.of(context).adminSuspicious} · RTI ${item.analysisDisplay.score!.round()}',
                    onTap: () {
                      context.go(item.detailPath, extra: item.routeContext);
                    },
                  ),
                );
              },
            ),
    );
  }
}

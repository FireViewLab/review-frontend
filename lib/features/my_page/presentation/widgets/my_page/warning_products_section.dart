import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'my_page_saved_products.dart';
import 'personal_products_page.dart';
import 'package:re_view_front/app/router/route_paths.dart';

const _scope = '찜한 상품 중 서버가 의심·위험 등급으로 분석한 상품이에요. 분석 전 상품은 포함하지 않아요.';

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
            const Expanded(
              child: Text(
                '주의 상품',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () => showWarningProducts(context),
              child: Text(count == null ? '목록 확인' : '목록 보기 ($count)'),
            ),
          ],
        ),
        const Text(_scope),
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
      title: '주의 상품',
      scope: _scope,
      onRefresh: () => ref.read(wishlistViewModelProvider.notifier).load(),
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in <String?, String>{
                null: '전체 주의',
                'SUSPICIOUS': '의심',
                'DANGER': '위험',
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
              child: const Text('다시 시도'),
            ),
          ],
        ],
      ),
      sliver: state is WishlistLoading || state is WishlistInitial
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          : items.isEmpty
          ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  failed == null ? '해당 등급의 찜 상품이 없어요.' : '주의 상품을 확인할 수 없어요.',
                ),
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
                    rtiLabel:
                        '${item.rtiGrade?.trim().toUpperCase() == 'DANGER' ? '위험' : '의심'} · RTI ${item.avgRti!.round()}',
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

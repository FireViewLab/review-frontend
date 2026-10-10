import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'my_page_saved_products.dart';

const _scope = '찜한 상품 중 서버가 의심·위험 등급으로 분석한 상품이에요. 분석 전 상품은 포함하지 않아요.';

void showWarningProducts(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) =>
      const Dialog(insetPadding: EdgeInsets.all(16), child: _WarningList()),
);

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

class _WarningList extends ConsumerStatefulWidget {
  const _WarningList();
  @override
  ConsumerState<_WarningList> createState() => _WarningListState();
}

class _WarningListState extends ConsumerState<_WarningList> {
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
    return SizedBox(
      width: 720,
      height: MediaQuery.sizeOf(context).height * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '주의 상품',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: '새로고침',
                  onPressed: () =>
                      ref.read(wishlistViewModelProvider.notifier).load(),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: '닫기',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(_scope),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
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
          ),
          if (failed != null) ...[
            Padding(padding: const EdgeInsets.all(16), child: Text(failed)),
            TextButton(
              onPressed: () =>
                  ref.read(wishlistViewModelProvider.notifier).load(),
              child: const Text('다시 시도'),
            ),
          ],
          Expanded(
            child: state is WishlistLoading || state is WishlistInitial
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? Center(
                    child: Text(
                      failed == null
                          ? '해당 등급의 찜 상품이 없어요.'
                          : '주의 상품을 확인할 수 없어요.',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          height: 166,
                          child: MyPageCompactProductCard(
                            title: item.name,
                            subtitle:
                                item.platform ?? item.categoryDisplayName ?? '',
                            imageUrl: item.imageUrl,
                            price: item.price,
                            rating: item.avgRating,
                            reviewCount: item.reviewCount,
                            rtiLabel:
                                '${item.rtiGrade?.trim().toUpperCase() == 'DANGER' ? '위험' : '의심'} · RTI ${item.avgRti!.round()}',
                            onTap: () {
                              Navigator.of(context).pop();
                              context.go(
                                item.detailPath,
                                extra: item.routeContext,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/features/recent_products/presentation/providers/recent_products_providers.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_saved_products.dart';

const _scope = '서버의 최근 10개 조회 기록에서 중복 상품을 제외했어요. 전체 기간의 상품 수와는 다를 수 있어요.';

void showRecentProducts(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => const _RecentProductsDialog(),
  );
}

class RecentProductsSection extends ConsumerWidget {
  const RecentProductsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              '최근 본 상품',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () => showRecentProducts(context),
            child: const Text('전체 보기'),
          ),
        ],
      ),
      const Text(_scope),
      const SizedBox(height: 12),
      _RecentBody(all: false),
    ],
  );
}

class _RecentProductsDialog extends StatelessWidget {
  const _RecentProductsDialog();
  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 720,
      height: MediaQuery.sizeOf(context).height * .8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '최근 본 상품',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Consumer(
                  builder: (context, ref, _) => IconButton(
                    tooltip: '새로고침',
                    onPressed: () => ref.invalidate(recentProductsProvider),
                    icon: const Icon(Icons.refresh),
                  ),
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
          const SizedBox(height: 12),
          const Expanded(child: _RecentBody(all: true)),
        ],
      ),
    ),
  );
}

class _RecentBody extends ConsumerWidget {
  const _RecentBody({required this.all});
  final bool all;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentProductsProvider);
    // Account changes rebuild this provider with no previous account's history.
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.hasError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('최근 본 상품을 불러오지 못했어요.'),
          TextButton(
            onPressed: () => ref.invalidate(recentProductsProvider),
            child: const Text('다시 시도'),
          ),
        ],
      );
    }
    final items = state.value ?? const <SearchResultProduct>[];
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('서버에 기록된 최근 본 상품이 없어요.'),
      );
    }
    Widget card(SearchResultProduct item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 166,
        child: MyPageCompactProductCard(
          title: item.name,
          subtitle:
              normalizeSearchPlatform(item.platform) ??
              item.categoryDisplayName,
          imageUrl: item.imageUrl,
          price: item.price,
          rating: item.avgRating,
          reviewCount: item.reviewCount,
          rtiLabel: item.avgRti == null
              ? '분석 전'
              : 'RTI ${item.avgRti!.round()}',
          onTap: () {
            if (all) Navigator.of(context).pop();
            context.go(item.detailPath, extra: item.routeContext);
          },
        ),
      ),
    );
    if (all) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => card(items[index]),
      );
    }
    return Column(children: [for (final item in items.take(2)) card(item)]);
  }
}

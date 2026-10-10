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
                '가격하락 · 가격 알림 관리',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(repository.unavailableReason),
              const SizedBox(height: 8),
              const Text(
                '가격 알림 이력·구독 저장은 아직 지원되지 않아요. 아래는 알림 기록이 아닌 찜 상품의 서버 가격하락 표시입니다.',
              ),
              if (loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                ),
              if (failed != null) Text('가격하락 표시를 확인하지 못했어요. $failed'),
              if (items != null && known > 0)
                Text(
                  '찜 ${items.length}개 중 가격하락 정보가 있는 $known개에서 ${drops!.length}개가 하락으로 표시됐어요. 기준 가격·시점은 제공되지 않았어요.',
                )
              else if (!loading && failed == null)
                const Text('서버가 찜 상품의 비교 가격 정보를 제공하지 않아 하락 여부를 확인할 수 없어요.'),
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
                    label: const Text('찜 가격 정보 새로고침'),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.wishlist),
                    child: const Text('찜 상품 확인'),
                  ),
                  const Tooltip(
                    message: '서버 가격이력·구독 저장 연동 후 신청할 수 있어요.',
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text('가격 알림 신청 · 미지원'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
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
              subtitle: const Text('서버 가격하락 표시 · 하락액/비율 정보 없음'),
              onTap: () =>
                  context.go(item.detailPath, extra: item.routeContext),
            );
          },
        ),
      ],
    );
  }
}

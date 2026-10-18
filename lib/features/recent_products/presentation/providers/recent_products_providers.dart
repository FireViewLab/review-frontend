import 'package:re_view_front/features/recent_products/data/repositories/recent_products_repository_impl.dart';
import 'package:re_view_front/features/recent_products/domain/repositories/recent_products_repository.dart';
import 'package:re_view_front/features/search/domain/entities/search_result_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/recent_products/domain/usecases/record_viewed_product_use_case.dart';

enum RecentViewStatus { idle, recording, recorded, failed }

final recordViewedProductUseCaseProvider = Provider(
  (ref) =>
      RecordViewedProductUseCase(ref.watch(productDetailRepositoryProvider)),
);
final recentViewRecordProvider = NotifierProvider.autoDispose
    .family<RecentViewRecorder, RecentViewStatus, ExternalProductRef>(
      RecentViewRecorder.new,
    );

class RecentViewRecorder extends Notifier<RecentViewStatus> {
  RecentViewRecorder(this.product);
  final ExternalProductRef product;
  int _generation = 0;
  @override
  RecentViewStatus build() {
    ref.watch(authTokenStoreProvider);
    ref.watch(isLoggedInProvider);
    _generation++;
    return RecentViewStatus.idle;
  }

  void acknowledgeInheritedView() {
    if (state == RecentViewStatus.idle && ref.read(isLoggedInProvider)) {
      state = RecentViewStatus.recorded;
    }
  }

  Future<void> record(int id, {bool retry = false}) async {
    if (!ref.mounted ||
        !ref.read(isLoggedInProvider) ||
        state == RecentViewStatus.recorded ||
        state == RecentViewStatus.recording ||
        (state == RecentViewStatus.failed && !retry)) {
      return;
    }
    final generation = _generation;
    state = RecentViewStatus.recording;
    final result = await ref.read(recordViewedProductUseCaseProvider)(
      product,
      id,
    );
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider)) {
      return;
    }
    result.when(
      success: (_) {
        state = RecentViewStatus.recorded;
        ref.invalidate(homeDashboardViewModelProvider);
        ref.invalidate(recentProductsProvider);
      },
      failure: (_) {
        state = RecentViewStatus.failed;
      },
    );
  }
}

final recentProductsRepositoryProvider = Provider<RecentProductsRepository>(
  (ref) => RecentProductsRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(appConfigProvider),
  ),
);

final recentProductsProvider =
    FutureProvider.autoDispose<List<SearchResultProduct>>((ref) async {
      if (!ref.watch(authSessionProvider).isLoggedIn) return const [];
      final result = await ref
          .read(recentProductsRepositoryProvider)
          .getRecentProducts();
      return result.when(
        success: (items) => items,
        failure: (failure) => throw failure,
      );
    });

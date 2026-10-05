import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:re_view_front/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_summary.dart';
import 'package:re_view_front/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_view_model.dart';

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDataSource>((
  ref,
) {
  return WishlistRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(ref.watch(wishlistRemoteDataSourceProvider));
});

final getWishlistUseCaseProvider = Provider<GetWishlistUseCase>((ref) {
  return GetWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final toggleWishlistUseCaseProvider = Provider<ToggleWishlistUseCase>((ref) {
  return ToggleWishlistUseCase(ref.watch(wishlistRepositoryProvider));
});

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(WishlistViewModel.new);

typedef WishlistSnapshot = ({
  List<WishlistItem> items,
  WishlistSummary summary,
});

final _wishlistSnapshotProvider = FutureProvider.autoDispose<WishlistSnapshot?>(
  (ref) async {
    ref.keepAlive();
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) return null;

    final result = await ref.read(getWishlistUseCaseProvider)();
    return result.when(success: (data) => data, failure: (_) => null);
  },
);

final wishlistItemCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return 0;
  final snapshot = await ref.watch(_wishlistSnapshotProvider.future);
  return snapshot?.items.length ?? 0;
});

final wishlistProductIdsProvider = FutureProvider.autoDispose<Set<int>>((
  ref,
) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return <int>{};
  final snapshot = await ref.watch(_wishlistSnapshotProvider.future);
  return snapshot?.items.map((item) => item.productId).toSet() ?? <int>{};
});

final wishlistButtonProvider =
    AsyncNotifierProvider.family<WishlistButtonNotifier, bool, int>(
      WishlistButtonNotifier.new,
    );

class WishlistButtonNotifier extends AsyncNotifier<bool> {
  WishlistButtonNotifier(this._productId);

  final int _productId;
  bool _isToggling = false;

  @override
  Future<bool> build() async {
    if (_productId <= 0) return false;

    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) return false;

    final productIds = await ref.watch(wishlistProductIdsProvider.future);
    return productIds.contains(_productId);
  }

  Future<void> toggle() async {
    if (_isToggling) return;
    if (_productId <= 0) return;
    if (!ref.read(isLoggedInProvider)) return;

    final current = state.value ?? false;
    _isToggling = true;

    final toggleUseCase = ref.read(toggleWishlistUseCaseProvider);
    final result = current
        ? await toggleUseCase.remove(_productId)
        : await toggleUseCase.add(_productId);

    if (!ref.mounted) return;
    _isToggling = false;
    result.when(
      success: (_) {
        state = AsyncData(!current);
        ref.invalidate(_wishlistSnapshotProvider);
      },
      failure: (failure) {
        if (!current && failure.code == 'WISHLIST_ALREADY_EXISTS') {
          state = const AsyncData(true);
          ref.invalidate(_wishlistSnapshotProvider);
          return;
        }
        state = AsyncData(current);
      },
    );
  }
}

void refreshWishlistSnapshot(Ref ref) {
  ref.invalidate(_wishlistSnapshotProvider);
}

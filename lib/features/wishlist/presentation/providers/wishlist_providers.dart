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
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
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
  int _generation = 0;

  @override
  Future<bool> build() async {
    _generation++;
    _isToggling = false;
    if (_productId <= 0) return false;

    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) return false;

    final productIds = await ref.watch(wishlistProductIdsProvider.future);
    return productIds.contains(_productId);
  }

  Future<String?> toggle() async {
    if (_isToggling) return null;
    if (_productId <= 0) return null;
    if (!ref.read(isLoggedInProvider)) return '로그인이 필요합니다.';

    if (!state.hasValue) {
      ref.invalidateSelf();
      return '찜 상태를 확인하지 못했습니다. 다시 불러온 뒤 시도해 주세요.';
    }
    final generation = _generation;
    final current = state.value!;
    _isToggling = true;

    final toggleUseCase = ref.read(toggleWishlistUseCaseProvider);
    final result = current
        ? await toggleUseCase.remove(_productId)
        : await toggleUseCase.add(_productId);

    if (!ref.mounted || generation != _generation) return null;
    _isToggling = false;
    return result.when<String?>(
      success: (_) {
        state = AsyncData(!current);
        ref.invalidate(_wishlistSnapshotProvider);
        ref.invalidate(wishlistViewModelProvider);
        return null;
      },
      failure: (failure) {
        if (!current && failure.code == 'WISHLIST_ALREADY_EXISTS') {
          state = const AsyncData(true);
          ref.invalidate(_wishlistSnapshotProvider);
          return null;
        }
        state = AsyncData(current);
        return failure.message;
      },
    );
  }
}

void refreshWishlistSnapshot(Ref ref) {
  ref.invalidate(_wishlistSnapshotProvider);
}

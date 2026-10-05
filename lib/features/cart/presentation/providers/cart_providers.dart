import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:re_view_front/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/cart/domain/repositories/cart_repository.dart';
import 'package:re_view_front/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:re_view_front/features/cart/domain/usecases/update_cart_use_case.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_view_model.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(cartRemoteDataSourceProvider));
});

final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  return GetCartUseCase(ref.watch(cartRepositoryProvider));
});

final updateCartUseCaseProvider = Provider<UpdateCartUseCase>((ref) {
  return UpdateCartUseCase(ref.watch(cartRepositoryProvider));
});

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  CartViewModel.new,
);

typedef CartSnapshot = ({List<CartItem> items, CartSummary summary});

final _cartSnapshotProvider = FutureProvider.autoDispose<CartSnapshot?>((
  ref,
) async {
  ref.keepAlive();
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return null;

  final result = await ref.read(getCartUseCaseProvider)();
  return result.when(success: (data) => data, failure: (_) => null);
});

final cartItemCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return 0;
  final snapshot = await ref.watch(_cartSnapshotProvider.future);
  return snapshot?.items.length ?? 0;
});

final cartProductIdsProvider = FutureProvider.autoDispose<Set<int>>((
  ref,
) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return <int>{};
  final snapshot = await ref.watch(_cartSnapshotProvider.future);
  return snapshot?.items.map((item) => item.productId).toSet() ?? <int>{};
});

final cartButtonProvider =
    AsyncNotifierProvider.family<CartButtonNotifier, bool, int>(
      CartButtonNotifier.new,
    );

class CartButtonNotifier extends AsyncNotifier<bool> {
  CartButtonNotifier(this._productId);

  final int _productId;
  bool _isAdding = false;

  @override
  Future<bool> build() async {
    if (_productId <= 0) return false;

    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) return false;

    final productIds = await ref.watch(cartProductIdsProvider.future);
    return productIds.contains(_productId);
  }

  Future<void> add() async {
    if (_isAdding || state.value == true) return;
    if (_productId <= 0) return;
    if (!ref.read(isLoggedInProvider)) return;

    _isAdding = true;
    final result = await ref.read(updateCartUseCaseProvider).add(_productId);

    if (!ref.mounted) return;
    _isAdding = false;
    result.when(
      success: (_) {
        state = const AsyncData(true);
        ref.invalidate(_cartSnapshotProvider);
      },
      failure: (_) => state = const AsyncData(false),
    );
  }
}

void refreshCartSnapshot(Ref ref) {
  ref.invalidate(_cartSnapshotProvider);
}

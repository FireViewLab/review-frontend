import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:re_view_front/features/cart/domain/usecases/update_cart_use_case.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

class CartViewModel extends Notifier<CartState> {
  late GetCartUseCase _getCartUseCase;
  late UpdateCartUseCase _updateCartUseCase;
  int _generation = 0;

  @override
  CartState build() {
    _generation++;
    ref.watch(isLoggedInProvider);
    _getCartUseCase = ref.watch(getCartUseCaseProvider);
    _updateCartUseCase = ref.watch(updateCartUseCaseProvider);
    return const CartInitial();
  }

  Future<void> load({String? message}) async {
    if (!ref.mounted) return;
    final generation = ++_generation;
    if (!ref.read(isLoggedInProvider)) {
      state = const CartEmpty();
      return;
    }
    final previous = state is CartSuccess ? state as CartSuccess : null;
    if (previous == null) state = const CartLoading();
    final result = await _getCartUseCase();
    if (!ref.mounted || generation != _generation) return;
    state = result.when(
      success: (data) {
        if (data.items.isEmpty) return const CartEmpty();
        final ids = data.items.map((i) => i.productId).toSet();
        return CartSuccess(
          items: data.items,
          summary: data.summary,
          selectedIds: previous?.selectedIds.intersection(ids) ?? ids,
          errorMessage: message,
        );
      },
      failure: (failure) =>
          previous?.copyWith(
            updatingProductIds: {},
            errorMessage: failure.message,
          ) ??
          CartFailure(failure),
    );
  }

  void toggleSelectAll() {
    final current = state;
    if (current is! CartSuccess || current.isUpdating) return;
    state = current.copyWith(
      selectedIds: current.isAllSelected
          ? {}
          : current.items.map((i) => i.productId).toSet(),
    );
  }

  void toggleSelectItem(int productId) {
    final current = state;
    if (current is! CartSuccess || current.isUpdating) return;
    final ids = Set<int>.from(current.selectedIds);
    if (!ids.remove(productId)) ids.add(productId);
    state = current.copyWith(selectedIds: ids);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final current = state;
    if (current is! CartSuccess) return;
    final matches = current.items.where((i) => i.productId == productId);
    if (matches.isEmpty ||
        quantity < 1 ||
        quantity > matches.first.maxQuantity) {
      return;
    }
    await _mutate(
      productId,
      () => _updateCartUseCase.updateQuantity(productId, quantity),
    );
  }

  Future<void> removeItem(int productId) =>
      _mutate(productId, () => _updateCartUseCase.remove(productId));

  Future<void> saveToWishlist(int productId, {bool removeFromCart = false}) =>
      _mutate(productId, () async {
        final result = await ref
            .read(toggleWishlistUseCaseProvider)
            .add(productId);
        if (!ref.mounted) return result;
        final alreadySaved =
            result is FailureResult<void> &&
            result.failure.code == 'WISHLIST_ALREADY_EXISTS';
        if (result is FailureResult<void> && !alreadySaved) return result;
        refreshWishlistSnapshot(ref);
        ref.invalidate(wishlistViewModelProvider);
        if (removeFromCart) return _updateCartUseCase.remove(productId);
        return const Success(null);
      });

  Future<void> _mutate(
    int productId,
    Future<Result<void>> Function() operation,
  ) async {
    final current = state;
    if (!ref.read(isLoggedInProvider) ||
        current is! CartSuccess ||
        current.isUpdating) {
      return;
    }
    final generation = _generation;
    state = current.copyWith(updatingProductIds: {productId}, clearError: true);
    final result = await operation();
    if (!ref.mounted || generation != _generation) return;
    refreshCartSnapshot(ref);
    final message = result.when(
      success: (_) => null,
      failure: (f) => f.message,
    );
    await load(message: message);
  }

  Future<void> removeSelected() async {
    final current = state;
    if (!ref.read(isLoggedInProvider) ||
        current is! CartSuccess ||
        current.isUpdating ||
        current.selectedIds.isEmpty) {
      return;
    }
    final generation = _generation;
    state = current.copyWith(
      updatingProductIds: current.selectedIds,
      clearError: true,
    );
    String? message;
    for (final id in current.selectedIds) {
      final result = await _updateCartUseCase.remove(id);
      if (!ref.mounted || generation != _generation) return;
      if (result is FailureResult<void>) {
        message = '일부 상품을 삭제하지 못했습니다. ${result.failure.message}';
        break;
      }
    }
    refreshCartSnapshot(ref);
    await load(message: message);
  }
}

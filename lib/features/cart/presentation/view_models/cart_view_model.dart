import 'package:re_view_front/shared/presentation/action_feedback.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:re_view_front/features/cart/domain/usecases/update_cart_use_case.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/cart/presentation/view_models/cart_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';

typedef CartRemoval = ({List<CartItem> items, String? errorMessage});

class CartViewModel extends Notifier<CartState> {
  late GetCartUseCase _getCartUseCase;
  late UpdateCartUseCase _updateCartUseCase;
  int _generation = 0;

  @override
  CartState build() {
    _generation++;
    ref.watch(authSessionProvider).isLoggedIn;
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

  Future<Result<void>?> removeItem(int productId) => _mutate(
    productId,
    () => _updateCartUseCase.remove(productId),
    feedbackOnSuccess: () => true,
  );

  Future<void> saveToWishlist(
    int productId, {
    bool removeFromCart = false,
  }) async {
    final generation = _generation;
    final session = ref.read(authSessionProvider);
    var changed = false;
    await _mutate(productId, () async {
      final result = await ref
          .read(toggleWishlistUseCaseProvider)
          .add(productId);
      if (!ref.mounted ||
          generation != _generation ||
          ref.read(authSessionProvider) != session) {
        return result;
      }
      final alreadySaved =
          result is FailureResult<void> &&
          result.failure.code == 'WISHLIST_ALREADY_EXISTS';
      if (result is FailureResult<void> && !alreadySaved) return result;
      changed = result is Success<void>;
      refreshWishlistSnapshot(ref);
      ref.invalidate(wishlistViewModelProvider);
      if (removeFromCart) {
        final removal = await _updateCartUseCase.remove(productId);
        changed = removal is Success<void>;
        return removal;
      }
      return const Success(null);
    }, feedbackOnSuccess: () => changed);
  }

  Future<Result<void>?> _mutate(
    int productId,
    Future<Result<void>> Function() operation, {
    bool Function()? feedbackOnSuccess,
  }) async {
    final current = state;
    if (!ref.read(isLoggedInProvider) ||
        current is! CartSuccess ||
        current.isUpdating) {
      return null;
    }
    final generation = _generation;
    state = current.copyWith(updatingProductIds: {productId}, clearError: true);
    final result = await operation();
    if (!ref.mounted || generation != _generation) return null;
    if (result is Success<void> && feedbackOnSuccess?.call() == true) {
      ActionFeedback.selection();
    }
    refreshCartSnapshot(ref);
    final message = result.when(
      success: (_) => null,
      failure: (f) => f.message,
    );
    await load(message: message);
    return result;
  }

  Future<CartRemoval?> removeSelected() async {
    final current = state;
    if (!ref.read(isLoggedInProvider) ||
        current is! CartSuccess ||
        current.isUpdating ||
        current.selectedIds.isEmpty) {
      return null;
    }
    final generation = _generation;
    state = current.copyWith(
      updatingProductIds: current.selectedIds,
      clearError: true,
    );
    final removed = <CartItem>[];
    String? message;
    for (final item in current.selectedItems) {
      final result = await _updateCartUseCase.remove(item.productId);
      if (!ref.mounted || generation != _generation) return null;
      if (result is FailureResult<void>) {
        message = '일부 상품을 삭제하지 못했습니다. ${result.failure.message}';
        break;
      }
      removed.add(item);
    }
    if (message == null && removed.isNotEmpty) ActionFeedback.selection();
    refreshCartSnapshot(ref);
    await load(message: message);
    return (items: List<CartItem>.unmodifiable(removed), errorMessage: message);
  }

  // 현재 추가 API는 옵션을 받지 않으므로 옵션이 있는 항목은 복원하지 않는다.
  static bool canRestore(List<CartItem> items) =>
      items.isNotEmpty &&
      items.every(
        (item) =>
            item.productId > 0 &&
            item.quantity > 0 &&
            item.quantity <= item.maxQuantity &&
            (item.variant?.trim().isEmpty ?? true),
      );

  Future<Result<void>?> restoreItems(List<CartItem> items) async {
    if (!ref.read(isLoggedInProvider) || !canRestore(items)) return null;
    final current = state;
    if (current is! CartEmpty && current is! CartSuccess) return null;
    if (current is CartSuccess && current.isUpdating) return null;
    final generation = _generation;
    final session = ref.read(authSessionProvider);
    bool isCurrent() =>
        ref.mounted &&
        generation == _generation &&
        ref.read(authSessionProvider) == session;
    state = current is CartSuccess
        ? current.copyWith(
            updatingProductIds: items.map((i) => i.productId).toSet(),
            clearError: true,
          )
        : const CartLoading();
    final snapshot = await _getCartUseCase();
    if (!isCurrent()) return null;
    Result<void> result = const Success(null);
    var changed = false;
    if (snapshot case FailureResult(:final failure)) {
      result = FailureResult(failure);
    } else {
      // 삭제 뒤 사용자가 다시 담은 항목은 수량을 덧붙이거나 덮어쓰지 않는다.
      final existing = (snapshot as Success<CartSnapshot>).value.items
          .map((i) => i.productId)
          .toSet();
      for (final item in items) {
        if (existing.contains(item.productId)) continue;
        result = await _updateCartUseCase.add(
          item.productId,
          quantity: item.quantity,
        );
        if (!isCurrent()) return null;
        if (result is FailureResult<void>) break;
        changed = true;
        existing.add(item.productId);
      }
    }
    if (changed && result is Success<void>) ActionFeedback.selection();
    refreshCartSnapshot(ref);
    final message = result.when(
      success: (_) => null,
      failure: (failure) => failure.message,
    );
    await load(message: message);
    return result;
  }
}

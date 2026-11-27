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

class CartWishlistResult {
  const CartWishlistResult({required this.wishlistSave, this.cartRemoval});

  final Result<void> wishlistSave;
  final Result<void>? cartRemoval;

  bool get isSaved => switch (wishlistSave) {
    Success<void>() => true,
    FailureResult<void>(:final failure) =>
      failure.code == 'WISHLIST_ALREADY_EXISTS',
  };
}

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
      errorMessage: _mutationError,
    );
  }

  Future<Result<void>?> removeItem(int productId) => _mutate(
    productId,
    () => _updateCartUseCase.remove(productId),
    errorMessage: _mutationError,
    shouldGiveFeedback: (result) => result is Success<void>,
  );

  Future<CartWishlistResult?> saveToWishlist(
    int productId, {
    bool removeFromCart = false,
  }) {
    final generation = _generation;
    final session = ref.read(authSessionProvider);
    return _mutate(
      productId,
      () async {
        final save = CartWishlistResult(
          wishlistSave: await ref
              .read(toggleWishlistUseCaseProvider)
              .add(productId),
        );
        if (!ref.mounted ||
            generation != _generation ||
            ref.read(authSessionProvider) != session ||
            !save.isSaved) {
          return save;
        }
        refreshWishlistSnapshot(ref);
        ref.invalidate(wishlistViewModelProvider);
        if (!removeFromCart) return save;

        return CartWishlistResult(
          wishlistSave: save.wishlistSave,
          cartRemoval: await _updateCartUseCase.remove(productId),
        );
      },
      errorMessage: (result) =>
          result.isSaved ? null : _mutationError(result.wishlistSave),
      shouldGiveFeedback: (result) =>
          (result.cartRemoval ?? result.wishlistSave) is Success<void>,
    );
  }

  String? _mutationError(Result<void> result) =>
      result.when(success: (_) => null, failure: (failure) => failure.message);

  Future<T?> _mutate<T>(
    int productId,
    Future<T> Function() operation, {
    required String? Function(T) errorMessage,
    bool Function(T)? shouldGiveFeedback,
  }) async {
    final current = state;
    final session = ref.read(authSessionProvider);
    if (!session.isLoggedIn || current is! CartSuccess || current.isUpdating) {
      return null;
    }
    final generation = _generation;
    state = current.copyWith(updatingProductIds: {productId}, clearError: true);
    final result = await operation();
    if (!ref.mounted ||
        generation != _generation ||
        ref.read(authSessionProvider) != session) {
      return null;
    }
    if (shouldGiveFeedback?.call(result) == true) ActionFeedback.selection();
    refreshCartSnapshot(ref);
    await load(message: errorMessage(result));
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

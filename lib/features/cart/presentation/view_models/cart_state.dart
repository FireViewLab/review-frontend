import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  const CartSuccess({
    required this.items,
    required this.summary,
    this.selectedIds = const {},
    this.updatingProductIds = const {},
    this.errorMessage,
  });

  final List<CartItem> items;
  final CartSummary summary;
  final Set<int> selectedIds;
  final Set<int> updatingProductIds;
  final String? errorMessage;
  bool get isUpdating => updatingProductIds.isNotEmpty;
  bool get hasUnknownSelectedPrice => selectedItems.any((i) => i.price == null);

  bool get isAllSelected =>
      items.isNotEmpty && items.every((i) => selectedIds.contains(i.productId));

  List<CartItem> get selectedItems =>
      items.where((i) => selectedIds.contains(i.productId)).toList();

  CartSummary get selectedSummary {
    final selected = selectedItems;
    final total = selected.fold(
      0,
      (sum, i) => sum + (i.price ?? 0) * i.quantity,
    );
    // The cart is a saved shopping list, not a merchant checkout quote.
    return CartSummary(
      totalProductPrice: total,
      shippingFee: 0,
      discountAmount: 0,
      totalPayment: total,
    );
  }

  CartSuccess copyWith({
    List<CartItem>? items,
    CartSummary? summary,
    Set<int>? selectedIds,
    Set<int>? updatingProductIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CartSuccess(
      items: items ?? this.items,
      summary: summary ?? this.summary,
      selectedIds: selectedIds ?? this.selectedIds,
      updatingProductIds: updatingProductIds ?? this.updatingProductIds,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartFailure extends CartState {
  const CartFailure(this.failure);

  final Failure failure;
}

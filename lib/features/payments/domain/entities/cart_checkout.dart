import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';

class CartCheckoutSelection {
  CartCheckoutSelection(Iterable<CartItem> items, this.sessionRevision)
    : items = List.unmodifiable(items);
  final List<CartItem> items;
  final int sessionRevision;
}

class CheckoutAddress {
  const CheckoutAddress({
    required this.recipient,
    required this.phone,
    required this.postalCode,
    required this.address,
    required this.detail,
  });
  final String recipient, phone, postalCode, address, detail;
  Map<String, Object> toJson() => {
    'recipient': recipient,
    'phone': phone,
    'postalCode': postalCode,
    'address': address,
    'detail': detail,
  };
}

import 'package:re_view_front/features/payments/data/test_payment_contract.dart';

/// Proposed contract: disabled until the server explicitly supports these paths.
class CartCheckoutContract {
  const CartCheckoutContract(
    this.quotesPath,
    this.ordersPath,
    this.confirmPath,
  );
  final String quotesPath, ordersPath, confirmPath;
  TestPaymentContract get payment => TestPaymentContract(
    catalogPath: quotesPath,
    ordersPath: ordersPath,
    confirmPath: confirmPath,
  );
  static CartCheckoutContract? fromEnvironment() {
    const quote = String.fromEnvironment('CART_TEST_QUOTES_PATH');
    const orders = String.fromEnvironment('CART_TEST_ORDERS_PATH');
    const confirm = String.fromEnvironment('CART_TEST_CONFIRM_PATH');
    bool valid(String s) =>
        s.startsWith('/api/') &&
        !s.contains(RegExp(r'[?#]')) &&
        !s.contains('..');
    return valid(quote) && valid(orders) && valid(confirm)
        ? const CartCheckoutContract(quote, orders, confirm)
        : null;
  }
}

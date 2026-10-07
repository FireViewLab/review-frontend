/// Explicit opt-in to an agreed server contract; no default API is assumed.
class TestPaymentContract {
  const TestPaymentContract({
    required this.catalogPath,
    required this.ordersPath,
    required this.confirmPath,
  });
  final String catalogPath;
  final String ordersPath;
  final String confirmPath;
  static TestPaymentContract? fromEnvironment() {
    const catalog = String.fromEnvironment('PAYMENT_TEST_CATALOG_PATH');
    const orders = String.fromEnvironment('PAYMENT_TEST_ORDERS_PATH');
    const confirm = String.fromEnvironment('PAYMENT_TEST_CONFIRM_PATH');
    bool valid(String value) =>
        value.startsWith('/api/') &&
        !value.contains('?') &&
        !value.contains('#') &&
        !value.contains('..');
    if (!valid(catalog) || !valid(orders) || !valid(confirm)) return null;
    return const TestPaymentContract(
      catalogPath: catalog,
      ordersPath: orders,
      confirmPath: confirm,
    );
  }
}

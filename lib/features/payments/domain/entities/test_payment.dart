class TestPaymentOffer {
  const TestPaymentOffer({
    required this.code,
    required this.name,
    required this.amount,
  });
  final String code;
  final String name;
  final int amount;
}

class TestPaymentOrder {
  const TestPaymentOrder({
    required this.id,
    required this.name,
    required this.amount,
    required this.offerCode,
    required this.customerKey,
    required this.status,
  });
  final String id;
  final String name;
  final int amount;
  final String offerCode;
  final String customerKey;
  final String status;
  bool get isPaid => status == 'PAID';
}

import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

class TestPaymentDto {
  static int amount(Map<String, dynamic> data) {
    final amount = data['amount'];
    if (data['testOnly'] != true ||
        data['currency'] != 'KRW' ||
        amount is! int ||
        amount <= 0 ||
        amount > 9007199254740991) {
      throw const FormatException('Invalid TEST payment quote');
    }
    return amount;
  }

  static TestPaymentOffer offer(Map<String, dynamic> data) {
    final code = data['offerCode'];
    final name = data['orderName'];
    if (!const ['PLUS', 'PRO'].contains(code) ||
        name is! String ||
        name.isEmpty ||
        name.length > 100) {
      throw const FormatException('Invalid service offer');
    }
    return TestPaymentOffer(
      code: code as String,
      name: name,
      amount: amount(data),
    );
  }

  static TestPaymentOrder order(Map<String, dynamic> data) {
    final quote = offer(data);
    final id = data['orderId'];
    final customerKey = data['customerKey'];
    final status = data['status'];
    if (id is! String ||
        !RegExp(r'^[A-Za-z0-9_=-]{6,64}$').hasMatch(id) ||
        customerKey is! String ||
        !RegExp(r'^[A-Za-z0-9_=.@-]{2,50}$').hasMatch(customerKey) ||
        !const ['PENDING', 'PAID', 'FAILED', 'CANCELED'].contains(status)) {
      throw const FormatException('Invalid TEST order');
    }
    return TestPaymentOrder(
      id: id,
      name: quote.name,
      amount: quote.amount,
      offerCode: quote.code,
      customerKey: customerKey,
      status: status as String,
    );
  }
}

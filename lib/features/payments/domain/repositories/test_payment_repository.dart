import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

abstract interface class TestPaymentRepository {
  Future<Result<List<TestPaymentOffer>>> getOffers();
  Future<Result<TestPaymentOrder>> createOrder(
    String offerCode,
    String requestId,
  );
  Future<Result<TestPaymentOrder>> getOrder(String orderId);
  Future<Result<TestPaymentOrder>> confirm(
    String orderId,
    String paymentKey,
    int amount,
  );
}

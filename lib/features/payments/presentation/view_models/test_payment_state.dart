import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

class TestPaymentState {
  const TestPaymentState({
    this.offers = const [],
    this.order,
    this.isBusy = false,
    this.message,
  });
  final List<TestPaymentOffer> offers;
  final TestPaymentOrder? order;
  final bool isBusy;
  final String? message;
  TestPaymentState copyWith({
    List<TestPaymentOffer>? offers,
    TestPaymentOrder? order,
    bool? isBusy,
    String? message,
    bool clearMessage = false,
  }) => TestPaymentState(
    offers: offers ?? this.offers,
    order: order ?? this.order,
    isBusy: isBusy ?? this.isBusy,
    message: clearMessage ? null : message ?? this.message,
  );
}

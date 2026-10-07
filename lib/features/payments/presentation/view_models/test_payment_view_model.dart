import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';
import 'package:re_view_front/features/payments/presentation/providers/test_payment_providers.dart';
import 'package:re_view_front/features/payments/presentation/view_models/test_payment_state.dart';

class TestPaymentViewModel extends Notifier<TestPaymentState> {
  int _generation = 0;
  String? _requestId;
  String? _requestOffer;
  @override
  TestPaymentState build() {
    _generation++;
    _requestId = null;
    _requestOffer = null;
    ref.watch(authSessionProvider).isLoggedIn;
    return const TestPaymentState();
  }

  bool get configured =>
      ref.read(testPaymentContractProvider) != null &&
      ref.read(testPaymentClientKeyProvider).isNotEmpty;
  void notice(String message) {
    if (ref.mounted) state = state.copyWith(message: message);
  }

  Future<void> load() async {
    if (!configured || !ref.read(isLoggedInProvider) || state.isBusy) return;
    final generation = ++_generation;
    state = state.copyWith(isBusy: true, clearMessage: true);
    final result = await ref.read(testPaymentRepositoryProvider).getOffers();
    if (!ref.mounted || generation != _generation) return;
    state = result.when(
      success: (offers) => state.copyWith(offers: offers, isBusy: false),
      failure: (f) => state.copyWith(isBusy: false, message: f.message),
    );
  }

  Future<void> create(TestPaymentOffer offer) async {
    if (!configured ||
        !ref.read(isLoggedInProvider) ||
        state.isBusy ||
        state.order != null) {
      return;
    }
    final generation = ++_generation;
    // Keep the request ID on an ambiguous failure; retrying must not create another order.
    if (_requestOffer != offer.code) {
      _requestOffer = offer.code;
      _requestId = null;
    }
    _requestId ??=
        'test-${List.generate(24, (_) => Random.secure().nextInt(16).toRadixString(16)).join()}';
    state = state.copyWith(isBusy: true, clearMessage: true);
    final result = await ref
        .read(testPaymentRepositoryProvider)
        .createOrder(offer.code, _requestId!);
    if (!ref.mounted || generation != _generation) return;
    state = result.when(
      success: (order) {
        if (order.offerCode != offer.code ||
            order.amount != offer.amount ||
            order.status != 'PENDING') {
          return state.copyWith(
            isBusy: false,
            message: '주문과 선택한 TEST 가격이 다릅니다. 다시 조회해 주세요.',
          );
        }
        return state.copyWith(order: order, isBusy: false);
      },
      failure: (f) => state.copyWith(isBusy: false, message: f.message),
    );
  }

  Future<void> restore(Uri uri) async {
    if (!configured || !ref.read(isLoggedInProvider) || state.isBusy) return;
    final id = uri.queryParameters['orderId'];
    if (id == null || !RegExp(r'^[A-Za-z0-9_=-]{6,64}$').hasMatch(id)) {
      notice('조회할 TEST 주문이 없습니다.');
      return;
    }
    final generation = ++_generation;
    state = state.copyWith(isBusy: true, clearMessage: true);
    final repository = ref.read(testPaymentRepositoryProvider);
    var result = await repository.getOrder(id);
    if (!ref.mounted || generation != _generation) return;
    if (result is Success<TestPaymentOrder> &&
        !result.value.isPaid &&
        uri.queryParameters['result'] == 'success') {
      final amount = int.tryParse(uri.queryParameters['amount'] ?? '');
      final key = uri.queryParameters['paymentKey'];
      if (result.value.id != id ||
          result.value.status != 'PENDING' ||
          amount != result.value.amount ||
          key == null ||
          key.isEmpty) {
        state = state.copyWith(
          isBusy: false,
          message: '결제 인증 정보와 서버 주문이 일치하지 않습니다. 승인하지 않았습니다.',
        );
        return;
      }
      final original = result.value;
      result = await repository.confirm(id, key, amount!);
      if (!ref.mounted || generation != _generation) return;
      if (result is Success<TestPaymentOrder> &&
          (result.value.id != original.id ||
              result.value.amount != original.amount ||
              result.value.offerCode != original.offerCode)) {
        state = state.copyWith(
          isBusy: false,
          message: '승인 응답과 원래 주문이 다릅니다. 완료로 처리하지 않았습니다.',
        );
        return;
      }
      if (result is FailureResult<TestPaymentOrder>) {
        // A timeout can follow a successful server approval. Query, never auto-repeat the mutation.
        final status = await repository.getOrder(id);
        if (!ref.mounted || generation != _generation) return;
        if (status is Success<TestPaymentOrder> &&
            status.value.isPaid &&
            status.value.amount == original.amount &&
            status.value.offerCode == original.offerCode) {
          result = status;
        }
      }
    }
    state = result.when(
      success: (order) {
        if (order.id != id) {
          return state.copyWith(isBusy: false, message: '서버 주문 번호가 일치하지 않습니다.');
        }
        return state.copyWith(
          order: order,
          isBusy: false,
          message: order.isPaid
              ? '서버에서 TEST 결제 승인을 확인했습니다. 실결제와 자동 플랜 변경은 진행하지 않습니다.'
              : uri.queryParameters['result'] == 'fail'
              ? '결제가 취소되었거나 실패했습니다. 구매 완료로 처리하지 않았습니다.'
              : '아직 서버에서 결제 완료를 확인하지 못했습니다. 다시 조회할 수 있습니다.',
        );
      },
      failure: (f) => state.copyWith(isBusy: false, message: f.message),
    );
  }

  void reset() {
    if (!state.isBusy) {
      _generation++;
      _requestId = null;
      _requestOffer = null;
      state = TestPaymentState(offers: state.offers);
    }
  }
}

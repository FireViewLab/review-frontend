import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/payments/data/test_payment_contract.dart';
import 'package:re_view_front/features/payments/data/test_payment_dto.dart';
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';
import 'package:re_view_front/features/payments/domain/repositories/test_payment_repository.dart';

class TestPaymentRepositoryImpl implements TestPaymentRepository {
  const TestPaymentRepositoryImpl(this.client, this.contract);
  final ApiClient client;
  final TestPaymentContract? contract;
  TestPaymentContract get _contract =>
      contract ?? (throw StateError('TEST payment API is not configured'));
  @override
  Future<Result<List<TestPaymentOffer>>> getOffers() => _guard(() async {
    final data = _body(await client.get(_contract.catalogPath));
    if (data['testOnly'] != true || data['offers'] is! List) {
      throw const FormatException('Invalid TEST catalog');
    }
    return [
      for (final item in data['offers'] as List)
        TestPaymentDto.offer(item as Map<String, dynamic>),
    ];
  });
  @override
  Future<Result<TestPaymentOrder>> createOrder(
    String offerCode,
    String requestId,
  ) => _guard(
    () async => TestPaymentDto.order(
      _body(
        await client.post(
          _contract.ordersPath,
          data: {'offerCode': offerCode, 'testOnly': true},
          options: Options(headers: {'Idempotency-Key': requestId}),
        ),
      ),
    ),
  );
  @override
  Future<Result<TestPaymentOrder>> getOrder(String orderId) => _guard(
    () async => TestPaymentDto.order(
      _body(
        await client.get(
          '${_contract.ordersPath}/${Uri.encodeComponent(orderId)}',
        ),
      ),
    ),
  );
  @override
  Future<Result<TestPaymentOrder>> confirm(
    String orderId,
    String paymentKey,
    int amount,
  ) => _guard(
    () async => TestPaymentDto.order(
      _body(
        await client.post(
          _contract.confirmPath,
          data: {
            'orderId': orderId,
            'paymentKey': paymentKey,
            'amount': amount,
          },
          options: Options(headers: {'Idempotency-Key': 'confirm-$orderId'}),
        ),
      ),
    ),
  );
  Map<String, dynamic> _body(Response<dynamic> response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid payment response');
    }
    final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Invalid payment data');
    }
    return body;
  }

  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Success(await request());
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object {
      return const FailureResult(
        Failure(
          message: 'TEST 결제 정보를 확인하지 못했습니다. 결제 완료로 처리하지 않았습니다. 다시 조회해 주세요.',
        ),
      );
    }
  }
}

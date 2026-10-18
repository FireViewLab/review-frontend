import 'package:dio/dio.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/payments/data/cart_checkout_contract.dart';
import 'package:re_view_front/features/payments/data/test_payment_dto.dart';
import 'package:re_view_front/features/payments/data/test_payment_repository_impl.dart';
import 'package:re_view_front/features/payments/domain/entities/cart_checkout.dart';
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

class CartCheckoutRepositoryImpl extends TestPaymentRepositoryImpl {
  CartCheckoutRepositoryImpl(
    ApiClient client,
    this.cartContract,
    this.selection,
    this.address,
  ) : super(client, cartContract?.payment, cart: true);
  final CartCheckoutContract? cartContract;
  final CartCheckoutSelection? selection;
  final CheckoutAddress? address;
  Map<String, dynamic>? _quote;

  Map<String, dynamic> _body(Response<dynamic> response) {
    if (response.data is! Map<String, dynamic>) {
      throw const FormatException('Invalid response');
    }
    final body = ApiResponse<Object?>.fromJson(
      response.data as Map<String, dynamic>,
    ).requireSuccess();
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Invalid data');
    }
    return body;
  }

  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Success(await request());
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on Object {
      return const FailureResult(
        Failure(message: '서버 TEST 주문 정보를 확인하지 못했습니다. 주문·결제 완료로 처리하지 않았습니다.'),
      );
    }
  }

  @override
  Future<Result<List<TestPaymentOffer>>> getOffers() => _guard(() async {
    if (cartContract == null ||
        selection == null ||
        address == null ||
        selection!.items.isEmpty) {
      throw StateError('Checkout is not configured');
    }
    final items = selection!.items;
    final data = _body(
      await client.post(
        cartContract!.quotesPath,
        data: {
          'testOnly': true,
          'items': [
            for (final item in items)
              {
                'cartItemId': item.cartItemId,
                'productId': item.productId,
                'quantity': item.quantity,
              },
          ],
          'shippingAddress': address!.toJson(),
        },
      ),
    );
    final amount = TestPaymentDto.amount(data);
    final quoted = data['items'];
    final shipping = data['shippingFee'];
    final subtotal = data['subtotal'];
    final id = data['quoteId'];
    final name = data['orderName'];
    if (data['purpose'] != 'CART' ||
        quoted is! List ||
        quoted.length != items.length ||
        shipping is! int ||
        shipping < 0 ||
        subtotal is! int ||
        subtotal < 0 ||
        subtotal + shipping != amount ||
        id is! String ||
        id.isEmpty ||
        name is! String ||
        name.isEmpty ||
        name.length > 100) {
      throw const FormatException('Invalid quote');
    }
    final seen = <int>{};
    var calculated = 0;
    for (final row in quoted) {
      if (row is! Map<String, dynamic>) {
        throw const FormatException('Invalid line');
      }
      final matches = items.where(
        (item) =>
            item.cartItemId == row['cartItemId'] &&
            item.productId == row['productId'] &&
            item.quantity == row['quantity'],
      );
      final price = row['unitPrice'];
      if (matches.length != 1 ||
          !seen.add(matches.single.cartItemId) ||
          price is! int ||
          price < 0 ||
          row['seller'] is! String ||
          (row['seller'] as String).trim().isEmpty ||
          row['fulfillmentAvailable'] != true) {
        throw const FormatException('Invalid fulfillment');
      }
      calculated += price * matches.single.quantity;
    }
    if (calculated != subtotal) throw const FormatException('Invalid subtotal');
    _quote = data;
    return [
      TestPaymentOffer(
        code: id,
        name: name,
        amount: amount,
        details: [
          for (final row in quoted)
            '${row['seller']} · ${row['quantity']}개 · 개당 ${row['unitPrice']}원',
          '서버 상품금액 $subtotal원 · 배송비 $shipping원',
        ],
      ),
    ];
  });
  @override
  Future<Result<TestPaymentOrder>> createOrder(
    String offerCode,
    String requestId,
  ) => _guard(() async {
    if (cartContract == null || _quote?['quoteId'] != offerCode) {
      throw StateError('Quote unavailable');
    }
    return TestPaymentDto.order(
      _body(
        await client.post(
          cartContract!.ordersPath,
          data: {'quoteId': offerCode, 'testOnly': true},
          options: Options(headers: {'Idempotency-Key': requestId}),
        ),
      ),
      cart: true,
    );
  });
}

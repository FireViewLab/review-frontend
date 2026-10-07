import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

@JS('TossPayments')
external _Toss _toss(String clientKey);
extension type _Toss(JSObject _) implements JSObject {
  external _Widgets widgets(JSObject parameters);
}
extension type _Widgets(JSObject _) implements JSObject {
  external JSPromise<JSAny?> setAmount(JSObject parameters);
  external JSPromise<JSAny?> renderPaymentMethods(JSObject parameters);
  external JSPromise<JSAny?> renderAgreement(JSObject parameters);
  external JSPromise<JSAny?> requestPayment(JSObject parameters);
}
Future<void>? _sdkLoad;
Future<void> _loadSdk() => _sdkLoad ??= _load().catchError((Object error) {
  _sdkLoad = null;
  throw error;
});
Future<void> _load() async {
  final script = web.HTMLScriptElement()
    ..src = 'https://js.tosspayments.com/v2/standard'
    ..async = true;
  final loaded = Completer<void>();
  final onLoad = ((web.Event event) {
    if (!loaded.isCompleted) loaded.complete();
  }).toJS;
  final onError = ((web.Event event) {
    if (!loaded.isCompleted) {
      loaded.completeError(StateError('SDK load failed'));
    }
  }).toJS;
  script.addEventListener('load', onLoad);
  script.addEventListener('error', onError);
  web.document.head!.appendChild(script);
  try {
    await loaded.future.timeout(const Duration(seconds: 15));
  } catch (_) {
    script.remove();
    rethrow;
  } finally {
    script.removeEventListener('load', onLoad);
    script.removeEventListener('error', onError);
  }
}

class TossTestPaymentWidget extends StatefulWidget {
  const TossTestPaymentWidget({
    super.key,
    required this.clientKey,
    required this.order,
    required this.successUrl,
    required this.failUrl,
    required this.onReady,
    required this.onError,
  });
  final String clientKey;
  final TestPaymentOrder order;
  final String successUrl;
  final String failUrl;
  final ValueChanged<Future<void> Function()> onReady;
  final ValueChanged<String> onError;
  @override
  State<TossTestPaymentWidget> createState() => _TossTestPaymentWidgetState();
}

class _TossTestPaymentWidgetState extends State<TossTestPaymentWidget> {
  bool _requesting = false;
  Future<void> _mount(Object element) async {
    final root = element as web.HTMLDivElement;
    final id =
        'test-order-${widget.order.id.codeUnits.map((value) => value.toRadixString(16)).join()}';
    final methods = web.HTMLDivElement()..id = '$id-methods';
    final agreement = web.HTMLDivElement()..id = '$id-agreement';
    root.appendChild(methods);
    root.appendChild(agreement);
    root.style.overflowY = 'auto';
    try {
      await _loadSdk();
      if (!mounted || !widget.clientKey.startsWith('test_gck_')) return;
      final sdk = _toss(
        widget.clientKey,
      ).widgets({'customerKey': widget.order.customerKey}.jsify() as JSObject);
      await sdk
          .setAmount(
            {'value': widget.order.amount, 'currency': 'KRW'}.jsify()
                as JSObject,
          )
          .toDart;
      if (!mounted) return;
      await sdk
          .renderPaymentMethods(
            {'selector': '#$id-methods', 'variantKey': 'DEFAULT'}.jsify()
                as JSObject,
          )
          .toDart;
      if (!mounted) return;
      await sdk
          .renderAgreement(
            {'selector': '#$id-agreement', 'variantKey': 'AGREEMENT'}.jsify()
                as JSObject,
          )
          .toDart;
      if (!mounted) return;
      widget.onReady(() async {
        if (!mounted || _requesting) return;
        _requesting = true;
        try {
          await sdk
              .requestPayment(
                {
                      'orderId': widget.order.id,
                      'orderName': widget.order.name,
                      'successUrl': widget.successUrl,
                      'failUrl': widget.failUrl,
                      'windowTarget': 'self',
                    }.jsify()
                    as JSObject,
              )
              .toDart;
        } catch (_) {
          if (mounted) {
            widget.onError('결제창 요청이 취소되었거나 실패했습니다. 결제 완료로 처리하지 않았습니다.');
          }
        } finally {
          _requesting = false;
        }
      });
    } catch (_) {
      if (mounted) {
        widget.onError('TEST 결제창을 불러오지 못했습니다. 네트워크와 설정을 확인한 뒤 다시 시도해 주세요.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 520,
    child: HtmlElementView.fromTagName(
      tagName: 'div',
      onElementCreated: (element) {
        unawaited(_mount(element));
      },
    ),
  );
}

import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/features/payments/domain/entities/test_payment.dart';

class TossTestPaymentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) =>
      Text(AppLocalizations.of(context).paymentTestWebBrowserOnly);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

String externalFailureMessage(AppLocalizations l, Failure f) =>
    switch (f.code) {
      'PRODUCT_NOT_COLLECTED' => l.externalNotCollected,
      'DATA_SERVER_UNAVAILABLE' => l.externalUnavailable,
      'REPORT_ALREADY_EXISTS' => l.externalReportDuplicate,
      'FEEDBACK_ALREADY_EXISTS' => l.externalFeedbackDuplicate,
      _ => l.externalFailed,
    };
void showExternalActionResult(
  BuildContext context,
  ExternalProductRef product,
  Result<void>? result,
) {
  if (result == null) return;
  if (result case FailureResult<void>(:final failure)) {
    if (failure.statusCode == 401 ||
        failure.code == 'UNAUTHORIZED' ||
        failure.code == 'AUTHENTICATION_REQUIRED') {
      context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          externalFailureMessage(AppLocalizations.of(context), failure),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).externalSuccess)),
    );
  }
}

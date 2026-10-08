import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

String externalFailureMessage(AppLocalizations l, Failure f) {
  if (f.statusCode == 403) return l.externalForbidden;
  if (f.statusCode == 401) return l.externalAuthRequestFailed;
  final cause = f.cause;
  if (cause is DioException) {
    switch (cause.type) {
      case DioExceptionType.connectionError:
        return l.externalNetworkFailure;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l.externalTimeout;
      default:
        break;
    }
  }
  return switch (f.code) {
    'PRODUCT_NOT_COLLECTED' => l.externalNotCollected,
    'DATA_SERVER_UNAVAILABLE' => l.externalUnavailable,
    'REPORT_ALREADY_EXISTS' => l.externalReportDuplicate,
    'FEEDBACK_ALREADY_EXISTS' => l.externalFeedbackDuplicate,
    _ => l.externalFailed,
  };
}

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
      final session = ProviderScope.containerOf(
        context,
        listen: false,
      ).read(authSessionProvider);
      if (!session.isLoggedIn) {
        context.go('/login?from=${Uri.encodeComponent(product.routePath)}');
        return;
      }
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

import 'package:flutter/widgets.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

String failureTitle(BuildContext context, Failure failure) {
  final l = AppLocalizations.of(context);
  return switch (failure.kind) {
    FailureKind.offline => l.failureTitleOffline,
    FailureKind.timeout => l.failureTitleTimeout,
    FailureKind.unauthorized => l.failureTitleUnauthorized,
    FailureKind.forbidden => l.failureTitleForbidden,
    FailureKind.notFound => l.failureTitleNotFound,
    FailureKind.rateLimited => l.failureTitleRateLimited,
    FailureKind.server => l.failureTitleServer,
    FailureKind.cancelled => l.failureTitleCancelled,
    FailureKind.badResponse => l.failureTitleBadResponse,
    FailureKind.unknown => l.failureTitleUnknown,
  };
}

String failureMessage(BuildContext context, Failure failure) {
  final l = AppLocalizations.of(context);
  final status = failure.statusCode;
  final clientError = status != null && status >= 400 && status < 500;
  final businessKind = switch (failure.kind) {
    FailureKind.unauthorized ||
    FailureKind.forbidden ||
    FailureKind.notFound ||
    FailureKind.rateLimited ||
    FailureKind.badResponse => true,
    _ => false,
  };
  final supplied =
      failure.serverMessage ??
      (clientError && failure.cause == null ? failure.message : null);
  if (businessKind && supplied != null && !_isTechnical(supplied)) {
    return supplied;
  }
  // 상태 코드도 원인 예외도 없는 오류는 앱이 직접 쓴 안내 문구이므로 그대로 보여 준다.
  if (failure.kind == FailureKind.unknown &&
      failure.statusCode == null &&
      failure.cause == null &&
      !_isTechnical(failure.message)) {
    return failure.message;
  }
  return switch (failure.kind) {
    FailureKind.offline => l.failureMessageOffline,
    FailureKind.timeout => l.failureMessageTimeout,
    FailureKind.unauthorized => l.failureMessageUnauthorized,
    FailureKind.forbidden => l.failureMessageForbidden,
    FailureKind.notFound => l.failureMessageNotFound,
    FailureKind.rateLimited => l.failureMessageRateLimited,
    FailureKind.server => l.failureMessageServer,
    FailureKind.cancelled => l.failureMessageCancelled,
    FailureKind.badResponse => l.failureMessageBadResponse,
    FailureKind.unknown => l.failureMessageUnknown,
  };
}

bool _isTechnical(String message) {
  final text = message.trim();
  if (text.isEmpty) return true;
  if (const {
    'bad request',
    'unauthorized',
    'forbidden',
    'not found',
    'too many requests',
    'internal server error',
    'bad gateway',
    'service unavailable',
    'gateway timeout',
    'request failed',
    'network error',
    'rate limit exceeded',
    'token expired',
    'jwt expired',
    'invalid token',
    'access token expired',
    'authentication required',
    'authentication failed',
    'access denied',
    '요청을 처리하지 못했습니다.',
  }.contains(text.toLowerCase())) {
    return true;
  }
  return RegExp(
    r'^(?:DioException|FormatException|SocketException|HttpException|TypeError|Exception|Connection reset|Connection refused|Failed host lookup|Failed to fetch|XMLHttpRequest error|Request failed with status code|The request returned an invalid status code)(?:\b|:)',
    caseSensitive: false,
  ).hasMatch(text);
}

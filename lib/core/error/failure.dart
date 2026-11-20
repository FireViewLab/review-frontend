enum FailureKind {
  offline,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  server,
  cancelled,
  badResponse,
  unknown,
}

class Failure {
  const Failure({
    required this.message,
    this.code,
    this.statusCode,
    this.cause,
    this.serverMessage,
    FailureKind? kind,
  }) : _kind = kind;

  final String message;
  final String? code;
  final int? statusCode;
  final Object? cause;
  final String? serverMessage;
  final FailureKind? _kind;

  FailureKind get kind {
    final status = statusCode;
    if (status == 401) return FailureKind.unauthorized;
    if (status == 403) return FailureKind.forbidden;
    if (status == 404) return FailureKind.notFound;
    if (status == 429) return FailureKind.rateLimited;
    if (status != null && status >= 500 && status < 600) {
      return FailureKind.server;
    }
    if (status != null && status >= 400 && status < 500) {
      return FailureKind.badResponse;
    }
    if (_kind != null) return _kind;
    if (cause is FormatException || cause is TypeError) {
      return FailureKind.badResponse;
    }
    return switch (code) {
      'connectionError' => FailureKind.offline,
      'connectionTimeout' ||
      'sendTimeout' ||
      'receiveTimeout' => FailureKind.timeout,
      'cancel' => FailureKind.cancelled,
      'badResponse' => FailureKind.badResponse,
      _ => FailureKind.unknown,
    };
  }

  bool get isRetryable => switch (kind) {
    FailureKind.offline ||
    FailureKind.timeout ||
    FailureKind.rateLimited ||
    FailureKind.server ||
    FailureKind.unknown => true,
    _ => false,
  };

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';

Failure failureFromApiResponseException(ApiResponseException error) {
  return Failure(
    message: error.message,
    serverMessage: error.message,
    code: error.code,
    cause: error,
    kind: FailureKind.badResponse,
  );
}

Failure failureFromDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final data = error.response?.data;
  final rawMessage = data is Map<String, dynamic> ? data['message'] : null;
  final serverMessage = rawMessage is String && rawMessage.trim().isNotEmpty
      ? rawMessage
      : null;
  final errorCode = data is Map<String, dynamic>
      ? data['errorCode']?.toString()
      : null;

  return Failure(
    message: serverMessage ?? _messageForType(error.type),
    serverMessage: serverMessage,
    kind: switch (error.type) {
      DioExceptionType.connectionError => FailureKind.offline,
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => FailureKind.timeout,
      DioExceptionType.cancel => FailureKind.cancelled,
      DioExceptionType.badResponse => FailureKind.badResponse,
      _ =>
        (error.error is FormatException || error.error is TypeError)
            ? FailureKind.badResponse
            : FailureKind.unknown,
    },
    code: errorCode ?? error.type.name,
    statusCode: statusCode,
    cause: error,
  );
}

String _messageForType(DioExceptionType type) {
  return switch (type) {
    DioExceptionType.connectionTimeout => '서버 연결 시간이 초과되었습니다.',
    DioExceptionType.sendTimeout => '요청 전송 시간이 초과되었습니다.',
    DioExceptionType.receiveTimeout => '응답 대기 시간이 초과되었습니다.',
    DioExceptionType.badCertificate => '서버 인증서를 확인할 수 없습니다.',
    DioExceptionType.badResponse => '서버 응답을 처리하지 못했습니다.',
    DioExceptionType.cancel => '요청이 취소되었습니다.',
    DioExceptionType.connectionError => '서버에 연결할 수 없습니다.',
    DioExceptionType.unknown => '알 수 없는 네트워크 오류가 발생했습니다.',
  };
}

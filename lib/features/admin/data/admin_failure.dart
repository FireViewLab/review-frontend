import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';

/// 관리자 API 예외를 [Failure]로 바꾼다. 서버 응답 본문이 있으면 그 메시지를 쓴다.
Failure adminFailureFrom(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    return Failure(
      message: data is Map<String, dynamic>
          ? data['message']?.toString() ?? error.toString()
          : error.toString(),
      code: data is Map<String, dynamic> ? data['errorCode']?.toString() : null,
      statusCode: error.response?.statusCode,
      cause: error,
    );
  }
  if (error is ApiResponseException) {
    return Failure(message: error.message, code: error.code, cause: error);
  }
  return Failure(message: error.toString(), cause: error);
}

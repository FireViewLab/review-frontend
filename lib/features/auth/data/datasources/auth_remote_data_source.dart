import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/auth/data/dtos/auth_user_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/login_request_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/password_reset_request_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/signup_request_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUserDto> login(LoginRequestDto request);

  Future<void> signup(SignupRequestDto request);

  Future<String> sendPasswordResetRequest(String email);

  Future<void> resetPassword(PasswordResetRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<AuthUserDto> login(LoginRequestDto request) async {
    final response = await _apiClient.post(
      _config.loginPath,
      data: request.toJson(),
    );
    final payload = _readPayload<Map<String, dynamic>>(response.data);
    final data = payload.requireSuccess();

    if (data is Map<String, dynamic>) {
      return AuthUserDto.fromJson(data);
    }

    throw const FormatException('Invalid login response');
  }

  @override
  Future<void> signup(SignupRequestDto request) async {
    final response = await _apiClient.post(
      _config.signupPath,
      data: request.toJson(),
    );
    final payload = _readPayload<Object?>(response.data);
    payload.requireSuccess();
  }

  @override
  Future<String> sendPasswordResetRequest(String email) async {
    final response = await _apiClient.post(
      '${_config.passwordResetRequestPath}?email=${Uri.encodeComponent(email)}',
    );
    final payload = _readPayload<Map<String, dynamic>>(response.data);
    final data = payload.requireSuccess();

    if (data is Map<String, dynamic> && data['resetToken'] is String) {
      return data['resetToken'] as String;
    }

    return '';
  }

  @override
  Future<void> resetPassword(PasswordResetRequestDto request) async {
    final response = await _apiClient.post(
      _config.passwordResetPath,
      data: request.toJson(),
    );
    final payload = _readPayload<Object?>(response.data);
    payload.requireSuccess();
  }

  ApiResponse<T> _readPayload<T>(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(data);
    }

    throw const FormatException('Invalid API response');
  }
}

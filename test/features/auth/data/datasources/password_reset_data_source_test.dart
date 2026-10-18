import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:re_view_front/features/auth/data/dtos/password_reset_request_dto.dart';

void main() {
  test('accepts reset-request success without returning a token', () async {
    final client = _Client();
    final config = AppConfig.fromEnvironment();
    final path = '${config.passwordResetRequestPath}?email=test%40example.com';
    when(() => client.post(path)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: path),
        data: {'success': true, 'message': 'email sent'},
      ),
    );
    final source = AuthRemoteDataSourceImpl(apiClient: client, config: config);
    expect(await source.sendPasswordResetRequest('test@example.com'), isEmpty);
  });

  test('posts the email token and new password to reset endpoint', () async {
    final client = _Client();
    final config = AppConfig.fromEnvironment();
    final body = {'token': 'email-token', 'newPassword': 'Password123!'};
    when(() => client.post(config.passwordResetPath, data: body)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: config.passwordResetPath),
        data: {'success': true},
      ),
    );
    final source = AuthRemoteDataSourceImpl(apiClient: client, config: config);
    await source.resetPassword(
      const PasswordResetRequestDto(
        token: 'email-token',
        newPassword: 'Password123!',
      ),
    );
    verify(() => client.post(config.passwordResetPath, data: body)).called(1);
  });
}

class _Client extends Mock implements ApiClient {}

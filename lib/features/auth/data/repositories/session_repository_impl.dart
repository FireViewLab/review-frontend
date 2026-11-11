import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/features/auth/data/dtos/auth_user_dto.dart';
import 'package:re_view_front/features/auth/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl({
    required ApiClient apiClient,
    required AuthTokenStore tokenStore,
    required int Function() sessionRevision,
  }) : _apiClient = apiClient,
       _tokenStore = tokenStore,
       _sessionRevision = sessionRevision;

  final ApiClient _apiClient;
  final AuthTokenStore _tokenStore;
  final int Function() _sessionRevision;

  @override
  Future<void> restoreSession() async {
    final token = _tokenStore.accessToken;
    if (token != null && !_isExpired(token)) return;
    final revision = _sessionRevision();
    bool isCurrentSession() =>
        _sessionRevision() == revision && _tokenStore.accessToken == token;

    try {
      final response = await _apiClient.post('/api/auth/refresh');
      final body = response.data;
      final data = body is Map<String, dynamic> ? body['data'] : null;
      if (data is! Map<String, dynamic> || !isCurrentSession()) return;
      final user = AuthUserDto.fromJson(data);
      final accessToken = user.accessToken;
      if (accessToken == null || accessToken.isEmpty) return;
      _tokenStore.save(
        accessToken: accessToken,
        tokenType: user.tokenType ?? 'Bearer',
        nickname: user.name,
        role: user.role,
        onboardingCompleted: user.onboardingCompleted,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 &&
          token != null &&
          isCurrentSession()) {
        _tokenStore.clear();
      }
    } on Object {
      // 시작 시 세션 복구 실패는 화면에 알리지 않는다.
    }
  }

  bool _isExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload is Map ? payload['exp'] : null;
      return exp is num &&
          exp.isFinite &&
          exp <= DateTime.now().millisecondsSinceEpoch / 1000;
    } on Object {
      return false;
    }
  }
}

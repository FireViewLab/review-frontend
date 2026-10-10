import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:re_view_front/features/auth/data/dtos/login_request_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/password_reset_request_dto.dart';
import 'package:re_view_front/features/auth/data/dtos/signup_request_dto.dart';
import 'package:re_view_front/features/auth/domain/entities/auth_user.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AppConfig config,
    required AuthRemoteDataSource remoteDataSource,
    required AuthTokenStore tokenStore,
  }) : _config = config,
       _remoteDataSource = remoteDataSource,
       _tokenStore = tokenStore;

  final AppConfig _config;
  final AuthRemoteDataSource _remoteDataSource;
  final AuthTokenStore _tokenStore;

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        LoginRequestDto(email: email, password: password),
      );
      final entity = user.toEntity();
      final token = entity.accessToken;
      if (token != null && token.isNotEmpty) {
        _tokenStore.save(
          accessToken: token,
          tokenType: entity.tokenType ?? 'Bearer',
          onboardingCompleted: entity.onboardingCompleted,
          nickname: entity.name,
          role: entity.role,
        );
      }

      return Success(entity);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: '로그인을 완료하지 못했습니다.', cause: error));
    }
  }

  @override
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signup(
        SignupRequestDto(name: name, email: email, password: password),
      );
      return const Success<void>(null);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: '회원가입을 완료하지 못했습니다.', cause: error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      _tokenStore.clear();
      return const Success<void>(null);
    } on Object catch (error) {
      return FailureResult(Failure(message: '로그아웃을 완료하지 못했습니다.', cause: error));
    }
  }

  @override
  Future<Result<AuthUser>> handleOAuthCallback({
    required String accessToken,
    required String tokenType,
    required String email,
    required String nickname,
    required bool onboardingCompleted,
  }) async {
    try {
      _tokenStore.save(
        accessToken: accessToken,
        tokenType: tokenType,
        onboardingCompleted: onboardingCompleted,
        nickname: nickname,
      );
      final user = AuthUser(
        id: email,
        email: email,
        name: nickname,
        accessToken: accessToken,
        tokenType: tokenType,
        onboardingCompleted: onboardingCompleted,
      );
      return Success(user);
    } on Object catch (error) {
      return FailureResult(
        Failure(message: 'OAuth 처리 중 오류가 발생했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<String>> sendPasswordResetRequest(String email) async {
    try {
      final token = await _remoteDataSource.sendPasswordResetRequest(email);
      return Success(token);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '인증 이메일을 발송하지 못했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        PasswordResetRequestDto(token: token, newPassword: newPassword),
      );
      return const Success<void>(null);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: '비밀번호를 변경하지 못했습니다.', cause: error));
    }
  }

  @override
  Future<Result<Uri>> getOAuthLoginUri(OAuthProvider provider) async {
    final path = switch (provider) {
      OAuthProvider.naver => _config.naverOAuthPath,
      OAuthProvider.google => _config.googleOAuthPath,
    };

    if (path.trim().isEmpty) {
      return FailureResult(
        Failure(message: '${provider.label} 로그인 경로가 설정되지 않았습니다.'),
      );
    }

    final baseUrl = _config.apiBaseUrl.trim();
    final uri = baseUrl.isEmpty
        ? Uri.parse(path)
        : Uri.parse(baseUrl).resolve(path);

    return Success(uri);
  }
}

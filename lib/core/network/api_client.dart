import 'package:dio/dio.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';

class ApiClient {
  ApiClient(AppConfig config, {AuthTokenStore? tokenStore})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          contentType: 'application/json',
          headers: const {'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStore?.accessToken;
          final tokenType = tokenStore?.tokenType ?? 'Bearer';
          if (options.extra[_skipAuthRefresh] != true &&
              token != null &&
              token.isNotEmpty) {
            options.headers['Authorization'] = '$tokenType $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final options = error.requestOptions;
          final current = tokenStore?.accessToken;
          final type = tokenStore?.tokenType ?? 'Bearer';
          final sent = options.headers['Authorization'];
          if (error.response?.statusCode != 401 ||
              options.extra[_skipAuthRefresh] == true ||
              options.uri.path.startsWith('/api/auth/') ||
              current == null ||
              sent == null) {
            handler.next(error);
            return;
          }
          if (options.extra[_authRetried] == true) {
            if (sent == '$type $current') tokenStore?.expireSession();
            handler.next(error);
            return;
          }

          // 다른 요청이 이미 토큰을 갱신했으면 refresh 없이 새 토큰으로 다시 보낸다.
          if (sent == '$type $current') {
            final refreshed = await (_refreshFuture ??= _refreshAccessToken(
              tokenStore!,
              current,
              type,
            ));
            if (!refreshed || tokenStore?.accessToken == null) {
              handler.next(error);
              return;
            }
          }
          final data = options.data;
          final retry = options.copyWith(
            data: data is FormData ? data.clone() : data,
            headers: {
              ...options.headers,
              'Authorization':
                  '${tokenStore?.tokenType ?? 'Bearer'} ${tokenStore?.accessToken}',
            },
            extra: {...options.extra, _authRetried: true},
          );
          try {
            handler.resolve(await dio.fetch<dynamic>(retry));
          } on DioException catch (retryError) {
            handler.next(retryError);
          }
        },
      ),
    );
    // Request headers/bodies and response bodies can contain credentials or
    // payment callback data. Do not install payload logging in any build.
  }

  static const _skipAuthRefresh = 'skipAuthRefresh';
  static const _authRetried = 'authRetried';

  final Dio dio;
  Future<bool>? _refreshFuture;

  Future<bool> _refreshAccessToken(
    AuthTokenStore tokenStore,
    String accessToken,
    String tokenType,
  ) async {
    bool isCurrentSession() =>
        tokenStore.accessToken == accessToken &&
        tokenStore.tokenType == tokenType;

    try {
      final response = await dio.post<dynamic>(
        '/api/auth/refresh',
        options: Options(extra: {_skipAuthRefresh: true}),
      );
      final body = response.data;
      final data = body is Map ? body['data'] : null;
      if (data is! Map ||
          data['accessToken'] is! String ||
          (data['accessToken'] as String).isEmpty ||
          data['tokenType'] is! String ||
          (data['tokenType'] as String).isEmpty ||
          !isCurrentSession()) {
        return false;
      }
      tokenStore.updateAccessToken(
        accessToken: data['accessToken'] as String,
        tokenType: data['tokenType'] as String,
      );
      return true;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 && isCurrentSession()) {
        tokenStore.expireSession();
      }
      return false;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete(path, queryParameters: queryParameters);
  }
}

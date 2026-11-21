import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';

void main() {
  group(ApiClient, () {
    final retryable = <Object>[
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      502,
      503,
      504,
    ];

    for (final failure in retryable) {
      test(
        'retries GET once after $failure and preserves query parameters',
        () {
          fakeAsync((time) {
            final adapter = _ScriptedAdapter([failure, 200]);
            final client = ApiClient(AppConfig.fromEnvironment())
              ..dio.httpClientAdapter = adapter;
            Response<dynamic>? response;
            Object? error;
            client
                .get('/products', queryParameters: {'q': '마스크', 'page': 2})
                .then(
                  (value) => response = value,
                  onError: (Object e) => error = e,
                );
            time.elapse(Duration.zero);
            expect(adapter.requests, hasLength(1));
            time.elapse(const Duration(milliseconds: 599));
            expect(adapter.requests, hasLength(1));
            time.elapse(const Duration(milliseconds: 1));
            expect(adapter.requests, hasLength(2));
            expect(error, isNull);
            expect(response?.data, {'ok': true});
            expect(adapter.requests.map((r) => r.method), ['GET', 'GET']);
            expect(adapter.requests.last.uri, adapter.requests.first.uri);
            expect(adapter.requests.last.queryParameters, {
              'q': '마스크',
              'page': 2,
            });
            time.elapse(const Duration(seconds: 10));
            expect(adapter.requests, hasLength(2));
            client.dio.close(force: true);
          });
        },
      );
      test(
        'surfaces the second GET failure after $failure without a third attempt',
        () {
          fakeAsync((time) {
            final adapter = _ScriptedAdapter([failure, failure, 200]);
            final client = ApiClient(AppConfig.fromEnvironment())
              ..dio.httpClientAdapter = adapter;
            Object? error;
            client
                .get('/products')
                .then<void>(
                  (_) => fail('must fail'),
                  onError: (Object e) => error = e,
                );
            time.elapse(Duration.zero);
            time.elapse(const Duration(seconds: 10));
            expect(adapter.requests, hasLength(2));
            expect(error, isA<DioException>());
            final dioError = error as DioException;
            expect(
              dioError.type,
              failure is int ? DioExceptionType.badResponse : failure,
            );
            expect(
              dioError.response?.statusCode,
              failure is int ? failure : null,
            );
            client.dio.close(force: true);
          });
        },
      );
    }

    for (final failure in <Object>[
      400,
      404,
      429,
      500,
      DioExceptionType.cancel,
      DioExceptionType.badCertificate,
    ]) {
      test('does not retry GET for $failure', () {
        fakeAsync((time) {
          final adapter = _ScriptedAdapter([failure, 200]);
          final client = ApiClient(AppConfig.fromEnvironment())
            ..dio.httpClientAdapter = adapter;
          Object? error;
          client
              .get('/products')
              .then<void>(
                (_) => fail('must fail'),
                onError: (Object e) => error = e,
              );
          time.elapse(Duration.zero);
          time.elapse(const Duration(seconds: 10));
          expect(adapter.requests, hasLength(1));
          expect(error, isA<DioException>());
          client.dio.close(force: true);
        });
      });
    }

    for (final method in ['POST', 'PUT', 'PATCH', 'DELETE']) {
      for (final failure in <Object>[DioExceptionType.connectionError, 503]) {
        test('does not retry $method after $failure', () {
          fakeAsync((time) {
            final adapter = _ScriptedAdapter([failure, 200]);
            final client = ApiClient(AppConfig.fromEnvironment())
              ..dio.httpClientAdapter = adapter;
            final request = switch (method) {
              'POST' => client.post('/products', data: {'id': 1}),
              'PUT' => client.put('/products', data: {'id': 1}),
              'PATCH' => client.patch('/products', data: {'id': 1}),
              _ => client.delete('/products'),
            };
            Object? error;
            request.then<void>(
              (_) => fail('must fail'),
              onError: (Object e) => error = e,
            );
            time.elapse(Duration.zero);
            time.elapse(const Duration(seconds: 10));
            expect(adapter.requests, hasLength(1));
            expect(adapter.requests.single.method, method);
            expect(error, isA<DioException>());
            client.dio.close(force: true);
          });
        });
      }
    }
    test(
      'returns the second GET error rather than the original connection failure',
      () {
        fakeAsync((time) {
          final adapter = _ScriptedAdapter([
            DioExceptionType.connectionError,
            404,
            200,
          ]);
          final client = ApiClient(AppConfig.fromEnvironment())
            ..dio.httpClientAdapter = adapter;
          Object? error;
          client
              .get('/products')
              .then<void>(
                (_) => fail('must fail'),
                onError: (Object e) => error = e,
              );
          time.elapse(const Duration(seconds: 10));
          expect(adapter.requests, hasLength(2));
          expect(error, isA<DioException>());
          final dioError = error as DioException;
          expect(dioError.type, DioExceptionType.badResponse);
          expect(dioError.response?.statusCode, 404);
          client.dio.close(force: true);
        });
      },
    );

    test('does not replay an already successful GET', () {
      fakeAsync((time) {
        final adapter = _ScriptedAdapter([200]);
        final client = ApiClient(AppConfig.fromEnvironment())
          ..dio.httpClientAdapter = adapter;
        Response<dynamic>? response;
        client.get('/products').then((value) => response = value);
        time.elapse(Duration.zero);
        time.elapse(const Duration(seconds: 10));
        expect(response?.statusCode, 200);
        expect(adapter.requests, hasLength(1));
        client.dio.close(force: true);
      });
    });
  });
}

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.outcomes);
  final List<Object> outcomes;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final outcome = outcomes[requests.length];
    requests.add(options);
    if (outcome is DioExceptionType) {
      throw DioException(requestOptions: options, type: outcome);
    }
    return ResponseBody.fromString(
      '{"ok":true}',
      outcome as int,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

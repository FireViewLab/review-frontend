import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/failure_messages.dart';

import '../../helpers/pump_app.dart';

void main() {
  group(Failure, () {
    group('network classification', () {
      for (final entry in [
        (DioExceptionType.connectionError, FailureKind.offline, true),
        (DioExceptionType.connectionTimeout, FailureKind.timeout, true),
        (DioExceptionType.sendTimeout, FailureKind.timeout, true),
        (DioExceptionType.receiveTimeout, FailureKind.timeout, true),
        (DioExceptionType.cancel, FailureKind.cancelled, false),
        (DioExceptionType.badResponse, FailureKind.badResponse, false),
        (DioExceptionType.unknown, FailureKind.unknown, true),
        (DioExceptionType.badCertificate, FailureKind.unknown, true),
      ]) {
        test(
          'classifies ${entry.$1.name} as ${entry.$2.name} with retryable=${entry.$3}',
          () {
            final error = DioException(
              requestOptions: RequestOptions(path: '/products'),
              type: entry.$1,
            );
            final failure = failureFromDioException(error);
            expect(failure.kind, entry.$2);
            expect(failure.isRetryable, entry.$3);
            expect(failure.code, entry.$1.name);
            expect(failure.cause, same(error));
            expect(failure.serverMessage, isNull);
            expect(
              Failure(message: '오류', code: entry.$1.name).kind,
              entry.$1 == DioExceptionType.badCertificate
                  ? FailureKind.unknown
                  : entry.$2,
            );
          },
        );
      }
      for (final entry in [
        (401, FailureKind.unauthorized, false),
        (403, FailureKind.forbidden, false),
        (404, FailureKind.notFound, false),
        (429, FailureKind.rateLimited, true),
        (500, FailureKind.server, true),
        (502, FailureKind.server, true),
        (503, FailureKind.server, true),
        (504, FailureKind.server, true),
        (400, FailureKind.badResponse, false),
        (422, FailureKind.badResponse, false),
      ]) {
        test(
          'classifies HTTP ${entry.$1} and retains the business error payload',
          () {
            final request = RequestOptions(path: '/products');
            final failure = failureFromDioException(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response<dynamic>(
                  requestOptions: request,
                  statusCode: entry.$1,
                  data: {'message': '이미 등록된 상품입니다.', 'errorCode': 'DUPLICATE'},
                ),
              ),
            );
            expect(failure.kind, entry.$2);
            expect(failure.isRetryable, entry.$3);
            expect(failure.message, '이미 등록된 상품입니다.');
            expect(failure.serverMessage, '이미 등록된 상품입니다.');
            expect(failure.code, 'DUPLICATE');
            expect(failure.statusCode, entry.$1);
          },
        );
      }
      test('uses the HTTP status before an explicit kind or network code', () {
        const failure = Failure(
          message: '오류',
          statusCode: 403,
          kind: FailureKind.offline,
          code: 'receiveTimeout',
        );
        expect(failure.kind, FailureKind.forbidden);
        expect(failure.isRetryable, isFalse);
      });
      test(
        'treats malformed responses as nonretryable even without an HTTP status',
        () {
          for (final cause in [
            const FormatException('invalid JSON'),
            TypeError(),
          ]) {
            expect(
              Failure(message: '오류', cause: cause).kind,
              FailureKind.badResponse,
            );
            final converted = failureFromDioException(
              DioException(
                requestOptions: RequestOptions(path: '/'),
                error: cause,
              ),
            );
            expect(converted.kind, FailureKind.badResponse);
            expect(converted.isRetryable, isFalse);
          }
        },
      );
      test('keeps an application response error and its business code', () {
        const error = ApiResponseException(
          message: '분석할 리뷰가 없습니다.',
          code: 'NO_REVIEWS',
        );
        final failure = failureFromApiResponseException(error);
        expect(failure.kind, FailureKind.badResponse);
        expect(failure.isRetryable, isFalse);
        expect(failure.serverMessage, error.message);
        expect(failure.code, 'NO_REVIEWS');
        expect(failure.cause, same(error));
      });
      test('ignores a blank server message and a non-object error body', () {
        for (final body in <Object?>[
          {'message': ' '},
          {'message': 42},
          'Bad gateway',
          null,
        ]) {
          final request = RequestOptions(path: '/');
          final failure = failureFromDioException(
            DioException(
              requestOptions: request,
              type: DioExceptionType.badResponse,
              response: Response<dynamic>(
                requestOptions: request,
                statusCode: 502,
                data: body,
              ),
            ),
          );
          expect(failure.serverMessage, isNull);
          expect(failure.kind, FailureKind.server);
        }
      });
    });

    group('localized messages', () {
      final localized =
          <
            (
              FailureKind,
              String Function(AppLocalizations),
              String Function(AppLocalizations),
            )
          >[
            (
              FailureKind.offline,
              (l) => l.failureTitleOffline,
              (l) => l.failureMessageOffline,
            ),
            (
              FailureKind.timeout,
              (l) => l.failureTitleTimeout,
              (l) => l.failureMessageTimeout,
            ),
            (
              FailureKind.unauthorized,
              (l) => l.failureTitleUnauthorized,
              (l) => l.failureMessageUnauthorized,
            ),
            (
              FailureKind.forbidden,
              (l) => l.failureTitleForbidden,
              (l) => l.failureMessageForbidden,
            ),
            (
              FailureKind.notFound,
              (l) => l.failureTitleNotFound,
              (l) => l.failureMessageNotFound,
            ),
            (
              FailureKind.rateLimited,
              (l) => l.failureTitleRateLimited,
              (l) => l.failureMessageRateLimited,
            ),
            (
              FailureKind.server,
              (l) => l.failureTitleServer,
              (l) => l.failureMessageServer,
            ),
            (
              FailureKind.cancelled,
              (l) => l.failureTitleCancelled,
              (l) => l.failureMessageCancelled,
            ),
            (
              FailureKind.badResponse,
              (l) => l.failureTitleBadResponse,
              (l) => l.failureMessageBadResponse,
            ),
            (
              FailureKind.unknown,
              (l) => l.failureTitleUnknown,
              (l) => l.failureMessageUnknown,
            ),
          ];
      for (final entry in localized) {
        testWidgets(
          'replaces technical ${entry.$1.name} errors with the localized title and message',
          (tester) async {
            final l = await _pumpFailure(
              tester,
              Failure(
                message: 'DioException: transport error',
                serverMessage: 'Request failed',
                kind: entry.$1,
                cause: Exception('transport'),
              ),
            );
            expect(find.text(entry.$2(l)), findsOneWidget);
            expect(find.text(entry.$3(l)), findsOneWidget);
            expect(find.textContaining('DioException'), findsNothing);
          },
        );
      }
      for (final status in [400, 401, 403, 404, 429]) {
        testWidgets('preserves a server business message for HTTP $status', (
          tester,
        ) async {
          await _pumpFailure(
            tester,
            Failure(
              message: 'technical',
              statusCode: status,
              serverMessage: '이미 처리된 요청입니다.',
              cause: Exception(),
            ),
          );
          expect(find.text('이미 처리된 요청입니다.'), findsOneWidget);
        });
      }
      testWidgets(
        'preserves a business message from an unsuccessful API response without HTTP status',
        (tester) async {
          await _pumpFailure(
            tester,
            failureFromApiResponseException(
              const ApiResponseException(
                message: '분석할 리뷰가 없습니다.',
                code: 'NO_REVIEWS',
              ),
            ),
          );
          expect(find.text('분석할 리뷰가 없습니다.'), findsOneWidget);
        },
      );
      testWidgets(
        'preserves an application-authored message without status or cause',
        (tester) async {
          await _pumpFailure(tester, const Failure(message: '검색어를 입력해 주세요.'));
          expect(find.text('검색어를 입력해 주세요.'), findsOneWidget);
        },
      );
      testWidgets('preserves a client error message authored without a cause', (
        tester,
      ) async {
        await _pumpFailure(
          tester,
          const Failure(message: '상품을 선택해 주세요.', statusCode: 400),
        );
        expect(find.text('상품을 선택해 주세요.'), findsOneWidget);
      });
      testWidgets('does not expose a server message for a server-side outage', (
        tester,
      ) async {
        final l = await _pumpFailure(
          tester,
          const Failure(
            message: 'database internals',
            serverMessage: '데이터베이스 장애',
            statusCode: 503,
          ),
        );
        expect(find.text(l.failureMessageServer), findsOneWidget);
        expect(find.text('데이터베이스 장애'), findsNothing);
      });
      for (final technical in [
        'Unauthorized',
        'token expired',
        'SocketException: refused',
        'FormatException: invalid',
        ' ',
      ]) {
        testWidgets('sanitizes the technical response "$technical"', (
          tester,
        ) async {
          final l = await _pumpFailure(
            tester,
            Failure(
              message: technical,
              serverMessage: technical,
              statusCode: 401,
            ),
          );
          expect(find.text(l.failureMessageUnauthorized), findsOneWidget);
        });
      }
    });
  });
}

Future<AppLocalizations> _pumpFailure(
  WidgetTester tester,
  Failure failure,
) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Column(
            children: [
              Text(failureTitle(context, failure)),
              Text(failureMessage(context, failure)),
            ],
          ),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);
  await pumpApp(tester, localizedApp(router: router));
  return AppLocalizations.of(tester.element(find.byType(Scaffold)));
}

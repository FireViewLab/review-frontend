import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:re_view_front/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient client;
  late ChatRemoteDataSourceImpl source;
  late ChatRepositoryImpl repository;

  setUp(() {
    client = _MockApiClient();
    source = ChatRemoteDataSourceImpl(
      apiClient: client,
      config: AppConfig.fromEnvironment(),
    );
    repository = ChatRepositoryImpl(source);
  });

  Response<dynamic> response(Object? data) => Response(
    requestOptions: RequestOptions(path: '/api/chat/sessions'),
    data: {'success': true, 'data': data},
  );

  test('requests a page and preserves session metadata and last', () async {
    when(
      () => client.get(
        '/api/chat/sessions',
        queryParameters: {'page': 1, 'size': 20},
      ),
    ).thenAnswer(
      (_) async => response({
        'content': [
          {
            'id': 12,
            'productId': '1',
            'title': '상품 리뷰',
            'createdAt': '2026-10-01T10:00:00Z',
            'lastMessageAt': '2026-10-02T10:00:00Z',
          },
        ],
        'number': 1,
        'last': true,
      }),
    );
    final page = await source.getSessions(page: 1, size: 20);
    expect(page.page, 1);
    expect(page.isLast, isTrue);
    expect(page.items.single.id, 12);
    expect(page.items.single.productId, '1');
    expect(page.items.single.title, '상품 리뷰');
    expect(page.items.single.createdAt, DateTime.utc(2026, 10, 1, 10));
    expect(page.items.single.lastMessageAt, DateTime.utc(2026, 10, 2, 10));
  });

  test(
    'restores message roles, order, blocked status and timestamps',
    () async {
      when(() => client.get('/api/chat/sessions/12/messages')).thenAnswer(
        (_) async => response([
          {
            'id': 21,
            'role': 'USER',
            'content': '질문',
            'blocked': false,
            'createdAt': '2026-10-01T10:00:00Z',
          },
          {
            'id': 22,
            'role': 'ASSISTANT',
            'content': '답변',
            'blocked': true,
            'blockReason': '차단 이유',
            'createdAt': '2026-10-01T10:01:00Z',
          },
        ]),
      );
      final messages = await source.getSessionMessages(12);
      expect(messages.map((m) => m.id), [21, 22]);
      expect(messages.map((m) => m.role), [ChatRole.user, ChatRole.assistant]);
      expect(messages.last.content, '답변');
      expect(messages.last.blocked, isTrue);
      expect(messages.last.blockReason, '차단 이유');
      expect(messages.last.createdAt, DateTime.utc(2026, 10, 1, 10, 1));
    },
  );

  test('returns a failure for an unsuccessful API envelope', () async {
    when(() => client.get('/api/chat/sessions/12/messages')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/chat/sessions/12/messages'),
        data: {'success': false, 'message': '대화 없음', 'errorCode': 'NOT_FOUND'},
      ),
    );
    final result = await repository.getSessionMessages(12);
    expect(result, isA<FailureResult<List<ChatMessage>>>());
    result.when(
      success: (_) => fail('Unexpected success'),
      failure: (failure) {
        expect(failure.code, 'NOT_FOUND');
        expect(failure.message, '대화 없음');
      },
    );
  });

  test('does not silently restore an unknown message role', () async {
    when(() => client.get('/api/chat/sessions/12/messages')).thenAnswer(
      (_) async => response([
        {'id': 21, 'role': 'SYSTEM', 'content': '잘못된 역할'},
      ]),
    );
    expect(
      await repository.getSessionMessages(12),
      isA<FailureResult<List<ChatMessage>>>(),
    );
  });

  test('preserves HTTP failures for history requests', () async {
    when(
      () => client.get(
        '/api/chat/sessions',
        queryParameters: {'page': 0, 'size': 20},
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/chat/sessions'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/api/chat/sessions'),
          statusCode: 401,
          data: {'message': '로그인 필요', 'errorCode': 'UNAUTHORIZED'},
        ),
      ),
    );
    final result = await repository.getSessions(page: 0, size: 20);
    result.when(
      success: (_) => fail('Unexpected success'),
      failure: (failure) {
        expect(failure.statusCode, 401);
        expect(failure.code, 'UNAUTHORIZED');
        expect(failure.message, '로그인 필요');
      },
    );
  });
}

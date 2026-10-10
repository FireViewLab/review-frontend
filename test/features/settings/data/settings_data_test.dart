import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:re_view_front/features/settings/data/dtos/settings_dto.dart';
import 'package:re_view_front/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

void main() {
  late _MockApiClient client;
  late AppConfig config;
  late SettingsRemoteDataSourceImpl source;
  late SettingsRepositoryImpl repository;

  setUp(() {
    client = _MockApiClient();
    config = AppConfig.fromEnvironment();
    source = SettingsRemoteDataSourceImpl(apiClient: client, config: config);
    repository = SettingsRepositoryImpl(source);
  });

  Response<dynamic> response(Object? body) => Response(
    requestOptions: RequestOptions(path: config.userSettingsPath),
    data: body,
  );

  test(
    'defaults match backend entity and exclude theme from partial PATCH',
    () {
      final data = const SettingsDto({}).toEntity();
      expect(SettingsDto.toUpdateJson(data), {
        'notifyRiskyProduct': true,
        'notifyAnalysisComplete': true,
        'notifyFeedbackResult': true,
        'notifyMarketing': false,
        'rtiThreshold': 50,
        'hideRiskyReviews': true,
        'showSuspiciousLabel': true,
        'prioritizeVerifiedReviews': true,
        'autoOpenAnalysisPopup': false,
        'cardDensity': 'COMFORTABLE',
        'reviewSortOrder': 'VERIFIED_RECENT',
        'rtiLabelStyle': 'BADGE_SMALL',
        'allowDataAnalysis': true,
      });
      expect(data.theme, 'SYSTEM');
    },
  );

  test('GET reads the settings response envelope', () async {
    when(() => client.get(config.userSettingsPath)).thenAnswer(
      (_) async => response({
        'success': true,
        'data': {
          ...SettingsDto.toUpdateJson(const SettingsData()),
          'theme': 'DARK',
          'rtiThreshold': 25,
          'notifyMarketing': true,
        },
      }),
    );
    final result = await repository.getSettings() as Success<SettingsData>;
    expect(result.value.rtiThreshold, 25);
    expect(result.value.theme, 'DARK');
    expect(result.value.notifyMarketing, isTrue);
    verify(() => client.get(config.userSettingsPath)).called(1);
  });

  test('PATCH sends editable fields only and returns server values', () async {
    const data = SettingsData(
      theme: 'DARK',
      cardDensity: 'COMPACT',
      reviewSortOrder: 'HELPFUL',
      rtiLabelStyle: 'NONE',
      notifyRiskyProduct: false,
      allowDataAnalysis: false,
      rtiThreshold: 100,
    );
    final body = SettingsDto.toUpdateJson(data);
    when(() => client.patch(config.userSettingsPath, data: body)).thenAnswer(
      (_) async => response({
        'success': true,
        'data': {...body, 'theme': 'DARK'},
      }),
    );
    final result =
        await repository.updateSettings(data) as Success<SettingsData>;
    expect(result.value.theme, 'DARK');
    expect(result.value.cardDensity, 'COMPACT');
    expect(result.value.reviewSortOrder, 'HELPFUL');
    expect(result.value.rtiLabelStyle, 'NONE');
    expect(result.value.allowDataAnalysis, isFalse);
    expect(body, isNot(contains('theme')));
    expect(body['rtiThreshold'], 100);
    verify(() => client.patch(config.userSettingsPath, data: body)).called(1);
  });

  test('failed GET envelope becomes FailureResult', () async {
    when(() => client.get(config.userSettingsPath)).thenAnswer(
      (_) async => response({
        'success': false,
        'message': '조회 실패',
        'errorCode': 'ERROR',
      }),
    );
    final result =
        await repository.getSettings() as FailureResult<SettingsData>;
    expect(result.failure.message, '조회 실패');
  });

  test('PATCH network failure becomes FailureResult', () async {
    when(
      () => client.patch(config.userSettingsPath, data: any(named: 'data')),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: config.userSettingsPath),
        type: DioExceptionType.connectionError,
      ),
    );
    expect(
      await repository.updateSettings(const SettingsData()),
      isA<FailureResult<SettingsData>>(),
    );
  });

  test(
    'invalid success payload does not silently replace settings with defaults',
    () async {
      when(
        () => client.get(config.userSettingsPath),
      ).thenAnswer((_) async => response({'success': true, 'data': null}));
      expect(
        await repository.getSettings(),
        isA<FailureResult<SettingsData>>(),
      );
    },
  );
}

class _MockApiClient extends Mock implements ApiClient {}

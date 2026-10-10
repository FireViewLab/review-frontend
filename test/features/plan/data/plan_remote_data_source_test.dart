import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/features/plan/data/datasources/plan_remote_data_source.dart';

void main() {
  test(
    'plan PATCH validates changed UserResponse without a plans endpoint',
    () async {
      final config = AppConfig.fromEnvironment();
      final client = ApiClient(config);
      final paths = <String>[];
      var returnedCode = 'PLUS';
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            paths.add(options.path);
            expect(options.data, {'planTier': 'PLUS'});
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'success': true,
                  'data': {'planTier': returnedCode, 'planExpiresAt': null},
                },
              ),
            );
          },
        ),
      );
      final source = PlanRemoteDataSourceImpl(
        apiClient: client,
        config: config,
      );
      await source.changeMyPlan('PLUS');
      returnedCode = 'FREE';
      await expectLater(source.changeMyPlan('PLUS'), throwsFormatException);
      expect(paths, ['/api/users/me/plan', '/api/users/me/plan']);
      client.dio.close();
    },
  );
}

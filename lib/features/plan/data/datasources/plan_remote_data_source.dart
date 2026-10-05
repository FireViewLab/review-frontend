import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';

abstract interface class PlanRemoteDataSource {
  Future<DateTime?> getMyPlanExpiry();
  Future<void> changeMyPlan(String code);
}

class PlanRemoteDataSourceImpl implements PlanRemoteDataSource {
  const PlanRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  // 백엔드에 요청한 경로다(review-backend #174). 서버에 생기기 전에는 404가 온다.
  static const myPlanPath = '/api/users/me/plan';

  @override
  Future<DateTime?> getMyPlanExpiry() async {
    final response = await _apiClient.get(_config.userMePath);
    final body = _requireData(response.data);
    if (body is! Map<String, dynamic>) return null;
    return DateTime.tryParse(body['planExpiresAt']?.toString() ?? '');
  }

  @override
  Future<void> changeMyPlan(String code) async {
    final response = await _apiClient.patch(
      myPlanPath,
      data: <String, dynamic>{'planTier': code},
    );
    _requireData(response.data);
  }

  Object? _requireData(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
    throw const FormatException('Invalid plan response');
  }
}

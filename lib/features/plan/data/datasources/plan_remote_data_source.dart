import 'package:re_view_front/features/plan/domain/entities/user_plan.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';

abstract interface class PlanRemoteDataSource {
  Future<UserPlan> getMyPlan();
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

  // Current-user plan mutation contract.
  static const myPlanPath = '/api/users/me/plan';

  @override
  Future<UserPlan> getMyPlan() async {
    final response = await _apiClient.get(_config.userMePath);
    final body = _requireData(response.data);
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Invalid user response');
    }
    return UserPlan.fromJson(body);
  }

  @override
  Future<void> changeMyPlan(String code) async {
    final response = await _apiClient.patch(
      myPlanPath,
      data: <String, dynamic>{'planTier': code},
    );
    final body = _requireData(response.data);
    if (body is! Map<String, dynamic> ||
        UserPlan.fromJson(body).code != code.toUpperCase()) {
      throw const FormatException(
        'Plan change response does not match the requested plan',
      );
    }
  }

  Object? _requireData(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
    throw const FormatException('Invalid plan response');
  }
}

import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/plan/domain/entities/plan_option.dart';

abstract interface class PlanRemoteDataSource {
  Future<List<PlanOption>> getPlans();
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

  // 아래 두 경로는 백엔드에 요청한 계약이다. 서버에 생기기 전에는 404가 온다.
  static const plansPath = '/api/plans';
  static const myPlanPath = '/api/users/me/plan';

  @override
  Future<List<PlanOption>> getPlans() async {
    final response = await _apiClient.get(plansPath);
    final body = _requireData(response.data);
    if (body is! List) throw const FormatException('Invalid plan list');
    return [
      for (final item in body)
        if (item is Map<String, dynamic> && _code(item) != null)
          PlanOption(
            code: _code(item)!,
            dailyLimit: (item['dailyLimit'] as num?)?.toInt(),
            proAvailable: item['proAvailable'] as bool?,
          ),
    ];
  }

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

  String? _code(Map<String, dynamic> item) {
    final code = (item['plan'] ?? item['planTier'] ?? item['code'])?.toString();
    return code == null || code.isEmpty ? null : code;
  }

  Object? _requireData(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
    throw const FormatException('Invalid plan response');
  }
}

import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_dashboard_dto.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';

abstract interface class AdminDashboardRemoteDataSource {
  Future<AdminDashboardSummary> getSummary();

  Future<AdminModelPerformance> getModelPerformance({required int days});
}

class AdminDashboardRemoteDataSourceImpl
    implements AdminDashboardRemoteDataSource {
  const AdminDashboardRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<AdminDashboardSummary> getSummary() async {
    final body = await _getData('${_config.adminBasePath}/dashboard');
    return AdminDashboardSummaryDto(body).toEntity();
  }

  @override
  Future<AdminModelPerformance> getModelPerformance({required int days}) async {
    final body = await _getData(
      '${_config.adminBasePath}/model-performance',
      queryParameters: {'days': days},
    );
    return AdminModelPerformanceDto(body).toEntity();
  }

  Future<Map<String, dynamic>> _getData(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.get(
      path,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) return body;
    }
    throw Exception('Invalid response format');
  }
}

import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/admin/data/admin_paging.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_report_dto.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';

abstract interface class AdminReportRemoteDataSource {
  Future<AdminPage<AdminReport>> getReports({
    String? status,
    required int page,
    required int size,
  });

  Future<void> updateStatus({
    required int reportId,
    required String status,
    String? adminComment,
  });
}

class AdminReportRemoteDataSourceImpl implements AdminReportRemoteDataSource {
  const AdminReportRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  String get _basePath => '${_config.adminBasePath}/reports';

  @override
  Future<AdminPage<AdminReport>> getReports({
    String? status,
    required int page,
    required int size,
  }) async {
    final response = await _apiClient.get(
      _basePath,
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'size': size,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return parseAdminPage<AdminReport>(
          body,
          page: page,
          mapItem: (json) => AdminReportDto(json).toEntity(),
        );
      }
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<void> updateStatus({
    required int reportId,
    required String status,
    String? adminComment,
  }) async {
    final response = await _apiClient.patch(
      '$_basePath/$reportId',
      data: <String, dynamic>{
        'status': status,
        'adminComment': ?adminComment,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }
}

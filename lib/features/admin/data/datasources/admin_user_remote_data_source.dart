import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/admin/data/admin_paging.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_user_dto.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';

abstract interface class AdminUserRemoteDataSource {
  Future<AdminPage<AdminUser>> getUsers({required int page, required int size});
  Future<AdminUser> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  });
}

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  const AdminUserRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<AdminPage<AdminUser>> getUsers({
    required int page,
    required int size,
  }) async {
    final response = await _apiClient.get(
      '${_config.adminBasePath}/users',
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return parseAdminPage<AdminUser>(
          body,
          page: page,
          mapItem: (json) => AdminUserDto(json).toEntity(),
        );
      }
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<AdminUser> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  }) async {
    final response = await _apiClient.patch(
      '${_config.adminBasePath}/users/$userId/plan',
      data: {
        'planTier': planTier.name.toUpperCase(),
        // 서버는 offset 없는 LocalDateTime을 받는다. FREE는 만료 시각을 비운다.
        if (planTier != AdminPlanTier.free && expiresAt != null)
          'expiresAt': expiresAt.toLocal().toIso8601String(),
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return AdminUserDto(body).toEntity();
      }
    }
    throw Exception('Invalid response format');
  }
}

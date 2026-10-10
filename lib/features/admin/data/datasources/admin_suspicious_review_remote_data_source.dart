import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/admin/data/admin_paging.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_suspicious_review_dto.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';

abstract interface class AdminSuspiciousReviewRemoteDataSource {
  Future<AdminPage<AdminSuspiciousReview>> getReviews({
    required int maxRti,
    required int page,
    required int size,
  });
}

class AdminSuspiciousReviewRemoteDataSourceImpl
    implements AdminSuspiciousReviewRemoteDataSource {
  const AdminSuspiciousReviewRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  String get _path => '${_config.adminBasePath}/reviews/suspicious';

  @override
  Future<AdminPage<AdminSuspiciousReview>> getReviews({
    required int maxRti,
    required int page,
    required int size,
  }) async {
    final response = await _apiClient.get(
      _path,
      queryParameters: {'maxRti': maxRti, 'page': page, 'size': size},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) {
        return parseAdminPage<AdminSuspiciousReview>(
          body,
          page: page,
          mapItem: (json) => AdminSuspiciousReviewDto(json).toEntity(),
        );
      }
    }
    throw Exception('Invalid response format');
  }
}

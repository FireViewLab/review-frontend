import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/admin/data/admin_paging.dart';
import 'package:re_view_front/features/admin/data/dtos/admin_analysis_feedback_dto.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';

abstract interface class AdminAnalysisFeedbackRemoteDataSource {
  Future<AdminPage<AdminAnalysisFeedback>> getFeedbacks({
    String? status,
    required int page,
    required int size,
  });

  Future<void> updateStatus({
    required int feedbackId,
    required String status,
    String? adminComment,
  });
}

class AdminAnalysisFeedbackRemoteDataSourceImpl
    implements AdminAnalysisFeedbackRemoteDataSource {
  const AdminAnalysisFeedbackRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  String get _basePath => '${_config.adminBasePath}/analysis-feedbacks';

  @override
  Future<AdminPage<AdminAnalysisFeedback>> getFeedbacks({
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
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();
      if (body is Map<String, dynamic>) {
        return parseAdminPage<AdminAnalysisFeedback>(
          body,
          page: page,
          mapItem: (json) => AdminAnalysisFeedbackDto(json).toEntity(),
        );
      }
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<void> updateStatus({
    required int feedbackId,
    required String status,
    String? adminComment,
  }) async {
    final response = await _apiClient.patch(
      '$_basePath/$feedbackId',
      data: <String, dynamic>{
        'status': status,
        'adminComment': ?adminComment,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // success=false면 ApiResponseException을 던진다. data 본문은 사용하지 않는다.
      ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
  }
}

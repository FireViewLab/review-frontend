import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/review_report/data/dtos/review_report_dto.dart';

abstract interface class ReviewReportRemoteDataSource {
  Future<ReviewReportDto> submitReport({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence,
    String? attachmentUrl,
  });
}

class ReviewReportRemoteDataSourceImpl implements ReviewReportRemoteDataSource {
  const ReviewReportRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<ReviewReportDto> submitReport({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) async {
    final body = <String, dynamic>{
      'reason': reason,
      'detail': detail,
      'includeAiEvidence': includeAiEvidence,
      'attachmentUrl': ?attachmentUrl,
    };

    final response = await _apiClient.post(
      '${_config.reportBasePath}/reviews/$reviewId',
      data: body,
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body2 = payload.requireSuccess();
      if (body2 is Map<String, dynamic>) {
        return ReviewReportDto.fromJson(body2);
      }
    }
    throw Exception('Invalid response format');
  }
}

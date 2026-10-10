import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/feedback_history/data/dtos/feedback_item_dto.dart';

abstract interface class FeedbackHistoryRemoteDataSource {
  Future<List<FeedbackItemDto>> getFeedbackHistory();
}

class FeedbackHistoryRemoteDataSourceImpl
    implements FeedbackHistoryRemoteDataSource {
  const FeedbackHistoryRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  })  : _apiClient = apiClient,
        _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<List<FeedbackItemDto>> getFeedbackHistory() async {
    final response = await _apiClient.get(_config.userFeedbackPath);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final body = payload.requireSuccess();

      if (body is List<dynamic>) {
        return FeedbackItemDto.fromList(body);
      }
    }

    return const [];
  }
}

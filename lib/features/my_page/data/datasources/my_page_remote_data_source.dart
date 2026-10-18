import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/my_page/data/dtos/user_profile_dto.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_activity.dart';

abstract interface class MyPageRemoteDataSource {
  Future<UserProfileDto> getMyProfile();

  Future<List<UserActivity>> getMyActivities();
}

class MyPageRemoteDataSourceImpl implements MyPageRemoteDataSource {
  const MyPageRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<UserProfileDto> getMyProfile() async {
    final response = await _apiClient.get(_config.userMePath);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final payload = ApiResponse<Object?>.fromJson(data);
      final profile = payload.requireSuccess();

      if (profile is Map<String, dynamic>) {
        return UserProfileDto.fromJson(profile);
      }
    }

    return const UserProfileDto(
      id: 0,
      email: '',
      nickname: '',
      role: '',
      createdAt: null,
      onboardingCompleted: false,
    );
  }

  @override
  Future<List<UserActivity>> getMyActivities() async {
    final response = await _apiClient.get('${_config.userMePath}/activities');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is List) {
        return [
          for (final item in body.whereType<Map<String, dynamic>>())
            UserActivity(
              type: item['activityType']?.toString() ?? '',
              description: item['description']?.toString() ?? '',
              targetId: item['targetId']?.toString(),
              createdAt: DateTime.tryParse(item['createdAt']?.toString() ?? ''),
            ),
        ];
      }
    }
    return const [];
  }
}

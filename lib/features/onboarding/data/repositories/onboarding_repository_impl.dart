import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/onboarding/data/dtos/onboarding_preferences_dto.dart';
import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';
import 'package:re_view_front/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this.client);
  final ApiClient client;
  static const path = '/api/onboarding/preferences';
  @override
  Future<Result<OnboardingPreferences>> getPreferences() =>
      _request(() => client.get(path));
  @override
  Future<Result<OnboardingPreferences>> savePreferences(
    Set<String> categories,
    int minTrustScore,
  ) => _request(
    () => client.post(
      path,
      data: {
        'preferredCategories': categories.toList(),
        'minTrustScore': minTrustScore,
      },
    ),
  );
  Future<Result<OnboardingPreferences>> _request(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid response');
      }
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is! Map<String, dynamic>) {
        throw const FormatException('Invalid preferences');
      }
      return Success(OnboardingPreferencesDto(body).toEntity());
    } on ApiResponseException catch (e) {
      return FailureResult(failureFromApiResponseException(e));
    } on DioException catch (e) {
      return FailureResult(failureFromDioException(e));
    } on Object {
      return const FailureResult(
        Failure(message: '관심 설정을 불러오거나 저장하지 못했습니다. 다시 시도해 주세요.'),
      );
    }
  }
}

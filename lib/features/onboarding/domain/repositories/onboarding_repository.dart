import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';

abstract interface class OnboardingRepository {
  Future<Result<OnboardingPreferences>> getPreferences();
  Future<Result<OnboardingPreferences>> savePreferences(
    Set<String> categories,
    int minTrustScore,
  );
}

import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';

class OnboardingPreferencesDto {
  const OnboardingPreferencesDto(this.json);
  final Map<String, dynamic> json;
  OnboardingPreferences toEntity() {
    final categories = json['preferredCategories'];
    final available = json['availableCategories'];
    final threshold = json['minTrustScore'];
    if (categories is! List ||
        available is! List ||
        threshold is! num ||
        threshold < 0 ||
        threshold > 100) {
      throw const FormatException('Invalid onboarding preferences');
    }
    return OnboardingPreferences(
      categories: categories.whereType<String>().toSet(),
      minTrustScore: threshold.toInt(),
      availableCategories: [
        for (final value in available)
          if (value is Map<String, dynamic> &&
              value['value'] is String &&
              value['displayName'] is String)
            PreferenceCategory(
              value: value['value'] as String,
              displayName: value['displayName'] as String,
            ),
      ],
    );
  }
}

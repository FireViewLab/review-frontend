class PreferenceCategory {
  const PreferenceCategory({required this.value, required this.displayName});
  final String value;
  final String displayName;
}

class OnboardingPreferences {
  const OnboardingPreferences({
    required this.categories,
    required this.minTrustScore,
    required this.availableCategories,
  });
  final Set<String> categories;
  final int minTrustScore;
  final List<PreferenceCategory> availableCategories;
}

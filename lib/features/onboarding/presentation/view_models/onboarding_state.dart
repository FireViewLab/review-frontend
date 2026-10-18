import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

enum OnboardingStep { category, notification }

enum OnboardingSubmitStatus { idle, loading, success, failure }

class OnboardingState {
  const OnboardingState({
    this.step = OnboardingStep.category,
    this.selectedCategories = const {},
    this.availableCategories = const [],
    this.minTrustScore = 60,
    this.settings = const SettingsData(),
    this.isInitializing = false,
    this.isLoaded = false,
    this.status = OnboardingSubmitStatus.idle,
    this.failureMessage,
  });
  final OnboardingStep step;
  final Set<String> selectedCategories;
  final List<PreferenceCategory> availableCategories;
  final int minTrustScore;
  final SettingsData settings;
  final bool isInitializing;
  final bool isLoaded;
  final OnboardingSubmitStatus status;
  final String? failureMessage;
  bool get canProceed => isLoaded && !isLoading;
  bool get isLoading =>
      isInitializing || status == OnboardingSubmitStatus.loading;
  bool get isSuccess => status == OnboardingSubmitStatus.success;
  OnboardingState copyWith({
    OnboardingStep? step,
    Set<String>? selectedCategories,
    List<PreferenceCategory>? availableCategories,
    int? minTrustScore,
    SettingsData? settings,
    bool? isInitializing,
    bool? isLoaded,
    OnboardingSubmitStatus? status,
    String? failureMessage,
    bool clearFailureMessage = false,
  }) => OnboardingState(
    step: step ?? this.step,
    selectedCategories: selectedCategories ?? this.selectedCategories,
    availableCategories: availableCategories ?? this.availableCategories,
    minTrustScore: minTrustScore ?? this.minTrustScore,
    settings: settings ?? this.settings,
    isInitializing: isInitializing ?? this.isInitializing,
    isLoaded: isLoaded ?? this.isLoaded,
    status: status ?? this.status,
    failureMessage: clearFailureMessage
        ? null
        : failureMessage ?? this.failureMessage,
  );
}

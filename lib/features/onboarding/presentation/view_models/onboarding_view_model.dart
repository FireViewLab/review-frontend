import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';

class OnboardingViewModel extends Notifier<OnboardingState> {
  int _generation = 0;
  Set<String> _savedCategories = {};
  int _savedThreshold = 60;
  @override
  OnboardingState build() {
    _generation++;
    ref.watch(authSessionProvider).isLoggedIn;
    Future.microtask(() {
      if (ref.mounted) load();
    });
    return const OnboardingState(isInitializing: true);
  }

  Future<void> load() async {
    if (state.status == OnboardingSubmitStatus.loading) return;
    final generation = ++_generation;
    if (!ref.read(isLoggedInProvider)) {
      state = state.copyWith(
        isInitializing: false,
        failureMessage: '로그인이 필요합니다.',
      );
      return;
    }
    state = state.copyWith(isInitializing: true, clearFailureMessage: true);
    final preferences = await ref
        .read(onboardingRepositoryProvider)
        .getPreferences();
    final settings = await ref.read(settingsRepositoryProvider).getSettings();
    if (!ref.mounted || generation != _generation) return;
    if (preferences is FailureResult<OnboardingPreferences> ||
        settings is FailureResult<SettingsData>) {
      final message = preferences is FailureResult<OnboardingPreferences>
          ? preferences.failure.message
          : (settings as FailureResult<SettingsData>).failure.message;
      state = state.copyWith(isInitializing: false, failureMessage: message);
      return;
    }
    final data = (preferences as Success<OnboardingPreferences>).value;
    _savedCategories = Set<String>.from(data.categories);
    _savedThreshold = data.minTrustScore;
    state = state.copyWith(
      selectedCategories: _savedCategories,
      availableCategories: data.availableCategories,
      minTrustScore: data.minTrustScore,
      settings: (settings as Success<SettingsData>).value,
      isInitializing: false,
      isLoaded: true,
      status: OnboardingSubmitStatus.idle,
    );
  }

  void toggleCategory(String value) {
    if (!state.canProceed ||
        !state.availableCategories.any((c) => c.value == value)) {
      return;
    }
    final updated = Set<String>.from(state.selectedCategories);
    if (!updated.remove(value)) updated.add(value);
    state = state.copyWith(selectedCategories: updated);
  }

  void setThreshold(int value) {
    if (state.canProceed) {
      state = state.copyWith(minTrustScore: value.clamp(0, 100));
    }
  }

  void updateSettings(SettingsData settings) {
    if (state.canProceed) state = state.copyWith(settings: settings);
  }

  void goToNotificationStep() {
    if (state.canProceed) {
      state = state.copyWith(step: OnboardingStep.notification);
    }
  }

  void goToCategoryStep() {
    if (state.canProceed) {
      state = state.copyWith(step: OnboardingStep.category);
    }
  }

  Future<void> complete() => _save(skip: false);
  Future<void> skip() => _save(skip: true);
  Future<void> _save({required bool skip}) async {
    if (!state.canProceed || !ref.read(isLoggedInProvider)) return;
    final generation = ++_generation;
    final current = state;
    state = state.copyWith(
      status: OnboardingSubmitStatus.loading,
      clearFailureMessage: true,
    );
    // Save notification preferences before completing onboarding on the server.
    if (!skip) {
      final notifications = await ref
          .read(settingsRepositoryProvider)
          .updateSettings(current.settings);
      if (!ref.mounted || generation != _generation) return;
      if (notifications is FailureResult<SettingsData>) {
        state = state.copyWith(
          status: OnboardingSubmitStatus.failure,
          failureMessage: notifications.failure.message,
        );
        return;
      }
      final saved = (notifications as Success<SettingsData>).value;
      if (saved.notifyRiskyProduct != current.settings.notifyRiskyProduct ||
          saved.notifyAnalysisComplete !=
              current.settings.notifyAnalysisComplete ||
          saved.notifyFeedbackResult != current.settings.notifyFeedbackResult ||
          saved.notifyMarketing != current.settings.notifyMarketing) {
        state = state.copyWith(
          status: OnboardingSubmitStatus.failure,
          failureMessage: '알림 설정 저장 응답이 선택과 다릅니다. 다시 불러와 확인해 주세요.',
        );
        return;
      }
      ref.invalidate(settingsViewModelProvider);
    }
    final categories = skip ? _savedCategories : current.selectedCategories;
    final threshold = skip ? _savedThreshold : current.minTrustScore;
    final result = await ref
        .read(onboardingRepositoryProvider)
        .savePreferences(categories, threshold);
    if (!ref.mounted || generation != _generation) return;
    result.when(
      success: (saved) {
        if (saved.minTrustScore != threshold ||
            saved.categories.length != categories.length ||
            !saved.categories.containsAll(categories)) {
          state = state.copyWith(
            status: OnboardingSubmitStatus.failure,
            failureMessage: '관심 설정 저장 응답이 선택과 다릅니다. 다시 불러와 확인해 주세요.',
          );
          return;
        }
        ref.read(authTokenStoreProvider.notifier).completeOnboarding();
        state = state.copyWith(status: OnboardingSubmitStatus.success);
      },
      failure: (failure) => state = state.copyWith(
        status: OnboardingSubmitStatus.failure,
        failureMessage: failure.message,
      ),
    );
  }
}

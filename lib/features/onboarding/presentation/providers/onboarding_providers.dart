import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:re_view_front/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_view_model.dart';

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
      OnboardingViewModel.new,
    );

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(ref.watch(apiClientProvider)),
);

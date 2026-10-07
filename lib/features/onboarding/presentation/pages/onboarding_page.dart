import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/onboarding/presentation/widgets/category_step.dart';
import 'package:re_view_front/features/onboarding/presentation/widgets/notification_step.dart';
import 'package:re_view_front/features/onboarding/presentation/widgets/onboarding_step_indicator.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(onboardingViewModelProvider, (_, state) {
      if (state.isSuccess) {
        ref.read(refreshHomeDashboardOnEnterProvider.notifier).request();
        ref.invalidate(homeDashboardViewModelProvider);
        context.go(
          GoRouterState.of(context).uri.queryParameters['edit'] == 'true'
              ? RoutePaths.settings
              : RoutePaths.home,
        );
      }
    });

    final state = ref.watch(onboardingViewModelProvider);
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final stepNumber = state.step == OnboardingStep.category ? 1 : 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AppContentView(
                maxWidth: 1200,
                padding: context.pagePadding.copyWith(
                  top: AppSpacing.xxl,
                  bottom: AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OnboardingStepIndicator(currentStep: stepNumber),
                    const SizedBox(height: AppSpacing.xl),
                    if (state.failureMessage != null) ...[
                      Text(
                        state.failureMessage!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      TextButton(
                        onPressed: state.isLoading ? null : vm.load,
                        child: const Text('다시 불러오기'),
                      ),
                    ],
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (state.isLoaded && !state.isLoading)
                      _OnboardingCard(
                        child: state.step == OnboardingStep.category
                            ? CategoryStep(
                                selectedCategories: state.selectedCategories,
                                availableCategories: state.availableCategories,
                                minTrustScore: state.minTrustScore,
                                onThresholdChanged: vm.setThreshold,
                                onToggle: vm.toggleCategory,
                                onNext: state.canProceed
                                    ? vm.goToNotificationStep
                                    : null,
                                onSkip: vm.skip,
                              )
                            : NotificationStep(
                                state: state,
                                onChanged: vm.updateSettings,
                                onPrevious: vm.goToCategoryStep,
                                onComplete: vm.complete,
                              ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.isMobile ? AppSpacing.lg : AppSpacing.xxxl,
        ),
        child: child,
      ),
    );
  }
}

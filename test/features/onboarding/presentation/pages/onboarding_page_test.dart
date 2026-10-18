import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:re_view_front/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_view_model.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets(
    'invalidates home dashboard before navigating home on success',
    (tester) async {
      final repository = _CountingHomeRepository();
      final onboardingViewModel = _TestOnboardingViewModel();
      final container = ProviderContainer(
        overrides: [
          onboardingViewModelProvider.overrideWith(() => onboardingViewModel),
          getHomeDashboardUseCaseProvider.overrideWithValue(
            GetHomeDashboardUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen<HomeDashboardState>(
        homeDashboardViewModelProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await tester.pump();
      await tester.pump();
      expect(repository.callCount, 1);

      final router = GoRouter(
        initialLocation: RoutePaths.onboarding,
        routes: [
          GoRoute(
            path: RoutePaths.onboarding,
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) =>
                const Scaffold(body: Text('home page')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: localizedApp(router: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      onboardingViewModel.markSuccess();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, RoutePaths.home);
      expect(repository.callCount, greaterThanOrEqualTo(2));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}

class _TestOnboardingViewModel extends OnboardingViewModel {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void markSuccess() {
    state = state.copyWith(status: OnboardingSubmitStatus.success);
  }
}

class _CountingHomeRepository implements HomeRepository {
  int callCount = 0;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    callCount += 1;
    return const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    );
  }
}

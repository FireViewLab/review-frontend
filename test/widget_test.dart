import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_view_model.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/app/app.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';
import 'package:re_view_front/features/landing/presentation/pages/landing_page.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_hero_section.dart';

import 'helpers/landing_data.dart';
import 'helpers/pump_app.dart';

void main() {
  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        homeCatalogProvider.overrideWith((ref) async => []),
        loginViewModelProvider.overrideWith(_TestLoginViewModel.new),
        apiClientProvider.overrideWith((ref) {
          throw StateError('Unexpected API access in app test');
        }),
        landingDataProvider.overrideWith(
          (ref) async => (stats: landingStats, featuredProduct: null),
        ),
        getHomeDashboardUseCaseProvider.overrideWithValue(
          GetHomeDashboardUseCase(const _HomeRepositoryFake()),
        ),
      ],
      child: const ReViewApp(),
    );
  }

  testWidgets('shows landing page on initial route', (tester) async {
    await pumpApp(tester, buildSubject());

    final container = ProviderScope.containerOf(
      tester.element(find.byType(LandingPage)),
    );
    expect(
      container.read(appRouterProvider).routeInformationProvider.value.uri.path,
      RoutePaths.landing,
    );
    expect(find.byType(LandingHeroSection), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LandingHeroSection),
        matching: find.text('시작하기'),
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('홈으로').hitTestable(), findsOneWidget);
  });

  testWidgets('navigates to login route from home page', (tester) async {
    await pumpApp(tester, buildSubject());

    await tester.tap(find.byTooltip('홈으로'));
    await tester.pumpAndSettle();
    expect(find.text('시작하기'), findsNothing);
    expect(find.byType(LandingPage), findsNothing);
    expect(find.byType(HeroBannerCarousel), findsOneWidget);

    await tester.tap(find.byTooltip('로그인').hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('안전한 쇼핑을 위한 로그인'), findsOneWidget);
  });
}

class _HomeRepositoryFake implements HomeRepository {
  const _HomeRepositoryFake();

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    return const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    );
  }
}

class _TestLoginViewModel extends LoginViewModel {
  @override
  LoginState build() {
    return const LoginState();
  }
}

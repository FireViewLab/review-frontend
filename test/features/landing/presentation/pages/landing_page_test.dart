import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';
import 'package:re_view_front/features/home/domain/usecases/get_home_dashboard_use_case.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/landing/presentation/pages/landing_page.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';

import '../../../../helpers/landing_data.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: RoutePaths.landing,
      routes: [
        GoRoute(
          path: RoutePaths.landing,
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const Scaffold(body: Text('home page')),
        ),
        GoRoute(
          path: RoutePaths.signup,
          builder: (context, state) =>
              const Scaffold(body: Text('signup page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    return ProviderScope(
      overrides: [
        apiClientProvider.overrideWith((ref) {
          throw StateError('Unexpected API access in landing test');
        }),
        landingDataProvider.overrideWith(
          (ref) async => (stats: landingStats, featuredProduct: null),
        ),
        getHomeDashboardUseCaseProvider.overrideWithValue(
          GetHomeDashboardUseCase(_HomeRepositoryFake()),
        ),
      ],
      child: localizedApp(router: router),
    );
  }

  testWidgets('uses a lighter backdrop overlay', (tester) async {
    await pumpApp(tester, buildSubject());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container && widget.color == const Color(0x660F172A),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows a static home preview instead of building HomePage', (
    tester,
  ) async {
    await pumpApp(tester, buildSubject());

    expect(find.byType(HomePage), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.startsWith(
              'assets/images/landing/home_',
            ),
      ),
      findsOneWidget,
    );
  });
}

class _HomeRepositoryFake implements HomeRepository {
  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    return const Success(
      DashboardSummary(recommendedProducts: [], trendingKeywords: []),
    );
  }
}

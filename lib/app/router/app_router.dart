import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_analysis_feedbacks_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_reports_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_suspicious_reviews_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_users_page.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_shell.dart';
import 'package:re_view_front/features/auth/presentation/pages/login_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/password_reset_page.dart';
import 'package:re_view_front/features/auth/presentation/pages/signup_page.dart';
import 'package:re_view_front/features/home/presentation/pages/home_page.dart';
import 'package:re_view_front/features/landing/presentation/pages/landing_page.dart';
import 'package:re_view_front/features/my_page/presentation/pages/my_page.dart';
import 'package:re_view_front/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:re_view_front/features/product_detail/presentation/pages/analysis_report_page.dart';
import 'package:re_view_front/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:re_view_front/features/cart/presentation/pages/cart_page.dart';
import 'package:re_view_front/features/search/presentation/pages/search_results_page.dart';
import 'package:re_view_front/features/review_report/presentation/pages/review_report_page.dart';
import 'package:re_view_front/features/settings/presentation/pages/settings_page.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/pages/external_product_page.dart';
import 'package:re_view_front/features/feedback_history/presentation/pages/feedback_history_page.dart';
import 'package:re_view_front/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:re_view_front/features/notifications/presentation/pages/notifications_page.dart';
import 'package:re_view_front/features/plan/presentation/pages/plan_page.dart';
import 'package:re_view_front/features/chat/presentation/widgets/popup_route_tracker.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Ref ref) {
    ref.listen<bool>(isLoggedInProvider, (_, _) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthNotifier(ref);

  final router = GoRouter(
    initialLocation: RoutePaths.landing,
    refreshListenable: authNotifier,
    observers: [popupRouteTracker],
    redirect: (context, state) {
      if (state.matchedLocation == RoutePaths.passwordReset ||
          state.matchedLocation == RoutePaths.resetPassword) {
        return null;
      }
      final isLoggedIn = ref.read(isLoggedInProvider);
      final tokenStore = ref.read(authTokenStoreProvider.notifier);
      const authPages = {
        RoutePaths.landing,
        RoutePaths.login,
        RoutePaths.signup,
      };
      if (isLoggedIn && authPages.contains(state.matchedLocation)) {
        if (!tokenStore.onboardingCompleted) {
          return RoutePaths.onboarding;
        }
        return RoutePaths.home;
      }
      if (isLoggedIn &&
          state.matchedLocation == RoutePaths.onboarding &&
          tokenStore.onboardingCompleted) {
        return RoutePaths.home;
      }
      const protectedPages = {
        RoutePaths.myPage,
        RoutePaths.wishlist,
        RoutePaths.cart,
        RoutePaths.settings,
        RoutePaths.feedbackHistory,
        RoutePaths.notifications,
        RoutePaths.plan,
      };
      if (!isLoggedIn && protectedPages.contains(state.matchedLocation)) {
        return _loginRedirect(state.uri);
      }
      const adminPages = {
        RoutePaths.admin,
        RoutePaths.adminReviews,
        RoutePaths.adminReports,
        RoutePaths.adminAnalysisFeedbacks,
        RoutePaths.adminUsers,
      };
      if (adminPages.contains(state.matchedLocation)) {
        if (!isLoggedIn) return _loginRedirect(state.uri);
        if (!tokenStore.isAdmin) return RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.landing,
        name: RouteNames.landing,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const LandingPage()),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const HomePage()),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) =>
            _buildTransitionPage(
              state,
              LoginPage(from: state.uri.queryParameters['from']),
            ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SignupPage()),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const OnboardingPage()),
      ),
      // 예전에 쓰던 빈 대시보드 경로. 북마크 등으로 들어오면 마이페이지로 보낸다.
      GoRoute(
        path: RoutePaths.dashboard,
        redirect: (context, state) => RoutePaths.myPage,
      ),
      GoRoute(
        path: RoutePaths.myPage,
        name: RouteNames.myPage,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const MyPage()),
      ),
      GoRoute(
        path: RoutePaths.search,
        name: RouteNames.search,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          SearchResultsPage(
            query: state.uri.queryParameters['q'] ?? '',
            categoryId: state.uri.queryParameters['categoryId'],
            categoryLabel: state.uri.queryParameters['category'],
            initialSort: SearchSortOption.values
                .where((o) => o.name == state.uri.queryParameters['sort'])
                .firstOrNull,
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        name: RouteNames.productDetail,
        pageBuilder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return _buildTransitionPage(state, ProductDetailPage(productId: id));
        },
      ),
      GoRoute(
        path: RoutePaths.analysisReport,
        name: RouteNames.analysisReport,
        pageBuilder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return _buildTransitionPage(state, AnalysisReportPage(productId: id));
        },
      ),
      // 위의 '/product/:id/analysis'보다 뒤에 둬야 분석 화면 경로를 가로채지 않는다.
      GoRoute(
        path: RoutePaths.externalProduct,
        name: RouteNames.externalProduct,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          ExternalProductPage(
            productRef: ExternalProductRef(
              platform: state.pathParameters['platform'] ?? '',
              productId: state.pathParameters['productId'] ?? '',
            ),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.oauthCallback,
        name: RouteNames.oauthCallback,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          OAuthCallbackPage(queryParams: state.uri.queryParameters),
        ),
      ),
      GoRoute(
        path: RoutePaths.passwordReset,
        name: RouteNames.passwordReset,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          PasswordResetPage(resetToken: state.uri.queryParameters['token']),
        ),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: RouteNames.resetPassword,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          PasswordResetPage(resetToken: state.uri.queryParameters['token']),
        ),
      ),
      GoRoute(
        path: RoutePaths.wishlist,
        name: RouteNames.wishlist,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const WishlistPage()),
      ),
      GoRoute(
        path: RoutePaths.cart,
        name: RouteNames.cart,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const CartPage()),
      ),
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SettingsPage()),
      ),
      GoRoute(
        path: RoutePaths.reviewReport,
        name: RouteNames.reviewReport,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _buildTransitionPage(
            state,
            ReviewReportPage(
              reviewId: extra['reviewId'] as int? ?? 0,
              productId: extra['productId'] as int?,
              productName: extra['productName'] as String? ?? '',
              reviewContent: extra['reviewContent'] as String? ?? '',
              rtiScore: extra['rtiScore'] as double? ?? 0,
              rtiGrade: extra['rtiGrade'] as String? ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.feedbackHistory,
        name: RouteNames.feedbackHistory,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const FeedbackHistoryPage()),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        name: RouteNames.notifications,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const NotificationsPage()),
      ),
      GoRoute(
        path: RoutePaths.plan,
        name: RouteNames.plan,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const PlanPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.admin,
            name: RouteNames.admin,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminDashboardPage()),
          ),
          GoRoute(
            path: RoutePaths.adminReviews,
            name: RouteNames.adminReviews,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminSuspiciousReviewsPage()),
          ),
          GoRoute(
            path: RoutePaths.adminReports,
            name: RouteNames.adminReports,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminReportsPage()),
          ),
          GoRoute(
            path: RoutePaths.adminAnalysisFeedbacks,
            name: RouteNames.adminAnalysisFeedbacks,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminAnalysisFeedbacksPage()),
          ),
          GoRoute(
            path: RoutePaths.adminUsers,
            name: RouteNames.adminUsers,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminUsersPage()),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    authNotifier.dispose();
    router.dispose();
  });

  return router;
});

CustomTransitionPage<void> _buildTransitionPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 280),
    child: child,
    transitionsBuilder: _buildTransition,
  );
}

Widget _buildTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  );

  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.04),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    ),
  );
}

/// 로그인이 필요한 화면에서 로그인 화면으로 보낼 때, 로그인 후 돌아올 위치를 담는다.
String _loginRedirect(Uri target) {
  return Uri(
    path: RoutePaths.login,
    queryParameters: {'from': target.toString()},
  ).toString();
}

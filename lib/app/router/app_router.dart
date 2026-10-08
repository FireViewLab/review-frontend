import 'package:re_view_front/features/payments/presentation/pages/test_payment_page.dart';
import 'package:re_view_front/app/router/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_shell.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_analysis_feedbacks_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_reports_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_suspicious_reviews_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_users_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_banners_page.dart';
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
    ref.listen(authSessionProvider, (_, _) => notifyListeners());
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
        final from = state.uri.queryParameters['from'];
        return _safeReturnPath(from) ?? RoutePaths.home;
      }
      if (isLoggedIn &&
          state.matchedLocation == RoutePaths.onboarding &&
          tokenStore.onboardingCompleted &&
          state.uri.queryParameters['edit'] != 'true') {
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
        RoutePaths.adminBanners,
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
        path: RoutePaths.oauthCallback,
        name: RouteNames.oauthCallback,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          OAuthCallbackPage(queryParams: state.uri.queryParameters),
        ),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) =>
            _buildTransitionPage(state, AppShell(uri: state.uri, child: child)),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const HomePage()),
          ),
          GoRoute(
            path: RoutePaths.login,
            name: RouteNames.login,
            pageBuilder: (context, state) => _buildContentPage(
              state,
              LoginPage(from: state.uri.queryParameters['from']),
            ),
          ),
          GoRoute(
            path: RoutePaths.signup,
            name: RouteNames.signup,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const SignupPage()),
          ),
          GoRoute(
            path: RoutePaths.onboarding,
            name: RouteNames.onboarding,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const OnboardingPage()),
          ),
          // 예전에 쓰던 빈 대시보드 경로. 북마크 등으로 들어오면 마이페이지로 보낸다.
          GoRoute(
            path: RoutePaths.dashboard,
            redirect: (context, state) => RoutePaths.myPage,
          ),
          GoRoute(
            path: RoutePaths.search,
            name: RouteNames.search,
            pageBuilder: (context, state) => _buildContentPage(
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
              return _buildContentPage(state, ProductDetailPage(productId: id));
            },
          ),
          GoRoute(
            path: RoutePaths.analysisReport,
            name: RouteNames.analysisReport,
            pageBuilder: (context, state) {
              final idStr = state.pathParameters['id'] ?? '0';
              final id = int.tryParse(idStr) ?? 0;
              return _buildContentPage(
                state,
                AnalysisReportPage(productId: id),
              );
            },
          ),
          // 위의 '/product/:id/analysis'보다 뒤에 둬야 분석 화면 경로를 가로채지 않는다.
          GoRoute(
            path: RoutePaths.externalProduct,
            name: RouteNames.externalProduct,
            pageBuilder: (context, state) => _buildContentPage(
              state,
              ExternalProductPage(
                viewAlreadyRecorded:
                    state.extra is ProductRouteContext &&
                    (state.extra as ProductRouteContext).viewAlreadyRecorded,
                summary: state.extra is ProductRouteContext
                    ? (state.extra as ProductRouteContext).summary
                    : null,
                productRef: ExternalProductRef(
                  platform: state.pathParameters['platform'] ?? '',
                  productId: state.pathParameters['productId'] ?? '',
                ),
              ),
            ),
          ),
          GoRoute(
            path: RoutePaths.passwordReset,
            name: RouteNames.passwordReset,
            pageBuilder: (context, state) => _buildContentPage(
              state,
              PasswordResetPage(resetToken: state.uri.queryParameters['token']),
            ),
          ),
          GoRoute(
            path: RoutePaths.resetPassword,
            name: RouteNames.resetPassword,
            pageBuilder: (context, state) => _buildContentPage(
              state,
              PasswordResetPage(resetToken: state.uri.queryParameters['token']),
            ),
          ),
          GoRoute(
            path: RoutePaths.wishlist,
            name: RouteNames.wishlist,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const WishlistPage()),
          ),
          GoRoute(
            path: RoutePaths.cart,
            name: RouteNames.cart,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const CartPage()),
          ),
          GoRoute(
            path: RoutePaths.reviewReport,
            name: RouteNames.reviewReport,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return _buildContentPage(
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
            path: RoutePaths.notifications,
            name: RouteNames.notifications,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const NotificationsPage()),
          ),
          GoRoute(
            path: RoutePaths.testPayment,
            pageBuilder: (context, state) =>
                _buildContentPage(state, const TestPaymentPage()),
          ),
          // 계정 영역: 헤더와 메뉴는 그대로 두고 내용만 바꾼다.
          ShellRoute(
            pageBuilder: (context, state, child) => _buildContentPage(
              state,
              AccountShell(location: state.uri.path, child: child),
            ),
            routes: [
              GoRoute(
                path: RoutePaths.myPage,
                name: RouteNames.myPage,
                pageBuilder: (context, state) => _buildContentPage(
                  state,
                  AccountContent(child: const MyPage()),
                ),
              ),
              GoRoute(
                path: RoutePaths.plan,
                name: RouteNames.plan,
                pageBuilder: (context, state) => _buildContentPage(
                  state,
                  AccountContent(child: const PlanContent()),
                ),
              ),
              GoRoute(
                path: RoutePaths.feedbackHistory,
                name: RouteNames.feedbackHistory,
                pageBuilder: (context, state) => _buildContentPage(
                  state,
                  AccountContent(child: const FeedbackHistoryPage()),
                ),
              ),
              GoRoute(
                path: RoutePaths.settings,
                name: RouteNames.settings,
                pageBuilder: (context, state) => _buildContentPage(
                  state,
                  AccountContent(child: const SettingsPage()),
                ),
              ),
            ],
          ),
        ],
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
          GoRoute(
            path: RoutePaths.adminBanners,
            name: RouteNames.adminBanners,
            pageBuilder: (context, state) =>
                _buildTransitionPage(state, const AdminBannersPage()),
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
    // 뒤로 갈 때의 기본값은 300ms라 함께 지정한다.
    transitionDuration: AppMotion.fast,
    reverseTransitionDuration: AppMotion.fast,
    child: child,
    transitionsBuilder: _buildTransition,
  );
}

/// 공통 틀 안에서 내용만 바뀔 때 쓴다. 틀은 그대로 있고 내용만 짧게 밝아진다.
CustomTransitionPage<void> _buildContentPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: AppMotion.fast,
    reverseTransitionDuration: Duration.zero,
    child: child,
    transitionsBuilder: _buildTransition,
  );
}

/// 화면을 옮길 때는 짧게 밝아지기만 한다.
Widget _buildTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  if (MediaQuery.disableAnimationsOf(context)) return child;
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: AppMotion.enter),
    child: child,
  );
}

/// 로그인이 필요한 화면에서 로그인 화면으로 보낼 때, 로그인 후 돌아올 위치를 담는다.
String _loginRedirect(Uri target) {
  return Uri(
    path: RoutePaths.login,
    queryParameters: {'from': target.toString()},
  ).toString();
}

String? _safeReturnPath(String? value) {
  if (value == null ||
      !value.startsWith('/') ||
      value.startsWith('//') ||
      value.contains('\\')) {
    return null;
  }
  final uri = Uri.tryParse(value);
  if (uri == null ||
      uri.hasScheme ||
      uri.hasAuthority ||
      {
        RoutePaths.landing,
        RoutePaths.login,
        RoutePaths.signup,
      }.contains(uri.path)) {
    return null;
  }
  return value;
}

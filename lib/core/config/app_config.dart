import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.homeDashboardPath,
    required this.searchPath,
    required this.productPath,
    required this.analysisPath,
    required this.analysisHealthPath,
    required this.reviewFeedbackBasePath,
    required this.reportBasePath,
    required this.analysisFeedbackBasePath,
    required this.adminBasePath,
    required this.loginPath,
    required this.signupPath,
    required this.naverOAuthPath,
    required this.googleOAuthPath,
    required this.passwordResetRequestPath,
    required this.passwordResetPath,
    required this.userMePath,
    required this.userSettingsPath,
    required this.userFeedbackPath,
    required this.landingStatsPath,
    required this.chatBasePath,
    required this.notificationBasePath,
    required this.chatReceiveTimeout,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment() {
    const explicitBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );
    final apiBaseUrl = explicitBaseUrl.isNotEmpty
        ? explicitBaseUrl
        : _defaultApiBaseUrl();

    return AppConfig(
      apiBaseUrl: apiBaseUrl,
      homeDashboardPath: const String.fromEnvironment(
        'HOME_DASHBOARD_PATH',
        defaultValue: '/api/dashboard',
      ),
      searchPath: const String.fromEnvironment(
        'SEARCH_PATH',
        defaultValue: '/api/products',
      ),
      productPath: const String.fromEnvironment(
        'PRODUCT_PATH',
        defaultValue: '/api/products',
      ),
      analysisPath: const String.fromEnvironment(
        'ANALYSIS_PATH',
        defaultValue: '/api/analysis/product',
      ),
      analysisHealthPath: const String.fromEnvironment(
        'ANALYSIS_HEALTH_PATH',
        defaultValue: '/api/analysis/health',
      ),
      reviewFeedbackBasePath: const String.fromEnvironment(
        'REVIEW_FEEDBACK_BASE_PATH',
        defaultValue: '/api/reviews',
      ),
      reportBasePath: const String.fromEnvironment(
        'REPORT_BASE_PATH',
        defaultValue: '/api/reports',
      ),
      analysisFeedbackBasePath: const String.fromEnvironment(
        'ANALYSIS_FEEDBACK_BASE_PATH',
        defaultValue: '/api/analysis-feedbacks',
      ),
      adminBasePath: const String.fromEnvironment(
        'ADMIN_BASE_PATH',
        defaultValue: '/api/admin',
      ),
      loginPath: const String.fromEnvironment(
        'LOGIN_PATH',
        defaultValue: '/api/auth/login',
      ),
      signupPath: const String.fromEnvironment(
        'SIGNUP_PATH',
        defaultValue: '/api/auth/signup',
      ),
      naverOAuthPath: const String.fromEnvironment(
        'NAVER_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/naver',
      ),
      googleOAuthPath: const String.fromEnvironment(
        'GOOGLE_OAUTH_PATH',
        defaultValue: '/oauth2/authorization/google',
      ),
      passwordResetRequestPath: const String.fromEnvironment(
        'PASSWORD_RESET_REQUEST_PATH',
        defaultValue: '/api/auth/password/reset-request',
      ),
      passwordResetPath: const String.fromEnvironment(
        'PASSWORD_RESET_PATH',
        defaultValue: '/api/auth/password/reset',
      ),
      userMePath: const String.fromEnvironment(
        'USER_ME_PATH',
        defaultValue: '/api/users/me',
      ),
      userFeedbackPath: const String.fromEnvironment(
        'USER_FEEDBACK_PATH',
        defaultValue: '/api/users/me/feedback',
      ),
      userSettingsPath: const String.fromEnvironment(
        'USER_SETTINGS_PATH',
        defaultValue: '/api/users/me/settings',
      ),
      landingStatsPath: const String.fromEnvironment(
        'LANDING_STATS_PATH',
        defaultValue: '/api/landing/stats',
      ),
      notificationBasePath: const String.fromEnvironment(
        'NOTIFICATION_BASE_PATH',
        defaultValue: '/api/notifications',
      ),
      chatBasePath: const String.fromEnvironment(
        'CHAT_BASE_PATH',
        defaultValue: '/api/chat',
      ),
      // 서버가 LLM 응답을 최대 70초 기다리므로 그보다 길게 잡는다.
      chatReceiveTimeout: const Duration(seconds: 75),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  final String apiBaseUrl;
  final String homeDashboardPath;
  final String searchPath;
  final String productPath;
  final String analysisPath;
  final String analysisHealthPath;
  final String reviewFeedbackBasePath;
  final String reportBasePath;
  final String analysisFeedbackBasePath;
  final String adminBasePath;
  final String loginPath;
  final String signupPath;
  final String naverOAuthPath;
  final String googleOAuthPath;
  final String passwordResetRequestPath;
  final String passwordResetPath;
  final String userMePath;
  final String userSettingsPath;
  final String userFeedbackPath;
  final String landingStatsPath;
  final String chatBasePath;
  final String notificationBasePath;
  final Duration chatReceiveTimeout;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}

String _defaultApiBaseUrl() {
  if (!kIsWeb) return 'https://api.re-view.kr';

  final host = Uri.base.host;
  final isLocalWeb =
      host == 'localhost' ||
      host == '127.0.0.1' ||
      host == '::1' ||
      host.endsWith('.localhost');

  return isLocalWeb ? 'https://api.re-view.kr' : Uri.base.origin;
}

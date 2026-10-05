abstract final class RoutePaths {
  static const landing = '/landing';
  static const home = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const myPage = '/my-page';
  static const search = '/search';
  static const productDetail = '/product/:id';
  static const oauthCallback = '/auth/callback';
  static const passwordReset = '/password-reset';
  static const resetPassword = '/reset-password';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const analysisReport = '/product/:id/analysis';

  /// Data 서버 상품. 쇼핑몰 이름과 상품 번호가 함께 있어야 한다.
  static const externalProduct = '/product/:platform/:productId';
  static const settings = '/settings';
  static const reviewReport = '/report/review';
  static const feedbackHistory = '/feedback-history';
  static const notifications = '/notifications';
  static const plan = '/plan';

  static const admin = '/admin';
  static const adminReviews = '/admin/reviews';
  static const adminReports = '/admin/reports';
  static const adminAnalysisFeedbacks = '/admin/analysis-feedbacks';
  static const adminUsers = '/admin/users';
}

abstract final class RouteNames {
  static const landing = 'landing';
  static const home = 'home';
  static const login = 'login';
  static const signup = 'signup';
  static const onboarding = 'onboarding';
  static const dashboard = 'dashboard';
  static const myPage = 'myPage';
  static const search = 'search';
  static const productDetail = 'productDetail';
  static const oauthCallback = 'oauthCallback';
  static const passwordReset = 'passwordReset';
  static const resetPassword = 'resetPassword';
  static const wishlist = 'wishlist';
  static const cart = 'cart';
  static const analysisReport = 'analysisReport';
  static const externalProduct = 'externalProduct';
  static const settings = 'settings';
  static const reviewReport = 'reviewReport';
  static const feedbackHistory = 'feedbackHistory';
  static const notifications = 'notifications';
  static const plan = 'plan';

  static const admin = 'admin';
  static const adminReviews = 'adminReviews';
  static const adminReports = 'adminReports';
  static const adminAnalysisFeedbacks = 'adminAnalysisFeedbacks';
  static const adminUsers = 'adminUsers';
}

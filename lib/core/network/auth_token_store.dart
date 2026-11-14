import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/storage/app_storage.dart';
import 'package:re_view_front/core/storage/secure_storage.dart';

class AuthTokenStore extends Notifier<bool> {
  static const _keyRefreshToken = 'review_refresh_token';
  static const _keyAccessToken = 'review_access_token';
  static const _keyTokenType = 'review_token_type';
  static const _keyOnboardingCompleted = 'review_onboarding_completed';
  static const _keyNickname = 'review_nickname';
  static const _keyRole = 'review_role';

  String? _refreshToken = kIsWeb ? null : SecureStorage.read(_keyRefreshToken);
  String? _accessToken = SecureStorage.read(_keyAccessToken);
  String? _tokenType = SecureStorage.read(_keyTokenType);
  bool _onboardingCompleted =
      AppStorage.read(_keyOnboardingCompleted) == 'true';
  String? _nickname = AppStorage.read(_keyNickname);
  String? _role = AppStorage.read(_keyRole);

  String? get refreshToken => _refreshToken;
  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;
  bool get onboardingCompleted => _onboardingCompleted;
  String? get nickname => _nickname;
  String? get role => _role;
  bool get isAdmin => _role?.toUpperCase() == 'ADMIN';

  @override
  bool build() => _accessToken != null;

  @override
  bool updateShouldNotify(bool previous, bool next) => true;

  void save({
    required String accessToken,
    required String tokenType,
    bool onboardingCompleted = false,
    String? nickname,
    String? role,
  }) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _onboardingCompleted = onboardingCompleted;
    _nickname = nickname;
    _role = role;
    SecureStorage.write(_keyAccessToken, accessToken);
    SecureStorage.write(_keyTokenType, tokenType);
    AppStorage.write(_keyOnboardingCompleted, onboardingCompleted.toString());
    if (nickname != null && nickname.isNotEmpty) {
      AppStorage.write(_keyNickname, nickname);
    } else {
      AppStorage.remove(_keyNickname);
    }
    if (role != null && role.isNotEmpty) {
      AppStorage.write(_keyRole, role);
    } else {
      AppStorage.remove(_keyRole);
    }
    state = true;
    ref.read(authSessionRevisionProvider.notifier).advance();
  }

  void updateAccessToken({
    required String accessToken,
    required String tokenType,
  }) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    SecureStorage.write(_keyAccessToken, accessToken);
    SecureStorage.write(_keyTokenType, tokenType);
  }

  void updateRefreshToken(String? refreshToken) {
    if (kIsWeb) return;
    _refreshToken = refreshToken != null && refreshToken.isNotEmpty
        ? refreshToken
        : null;
    if (_refreshToken case final token?) {
      SecureStorage.write(_keyRefreshToken, token);
    } else {
      SecureStorage.remove(_keyRefreshToken);
    }
  }

  void saveNickname(String nickname) {
    _nickname = nickname;
    AppStorage.write(_keyNickname, nickname);
  }

  void saveRole(String role) {
    _role = role;
    AppStorage.write(_keyRole, role);
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    AppStorage.write(_keyOnboardingCompleted, 'true');
  }

  /// 저장된 토큰으로 보낸 요청이 401을 받았을 때 부른다. 로그아웃하고 만료를 알린다.
  void expireSession() {
    if (_accessToken == null) {
      updateRefreshToken(null);
      return;
    }
    clear();
    ref.read(sessionExpiredProvider.notifier).notify();
  }

  void clear() {
    updateRefreshToken(null);
    _accessToken = null;
    _tokenType = null;
    _onboardingCompleted = false;
    _nickname = null;
    _role = null;
    SecureStorage.remove(_keyAccessToken);
    SecureStorage.remove(_keyTokenType);
    AppStorage.remove(_keyOnboardingCompleted);
    AppStorage.remove(_keyNickname);
    AppStorage.remove(_keyRole);
    state = false;
    ref.read(authSessionRevisionProvider.notifier).advance();
  }
}

/// 로그인 만료 알림. 값은 만료가 일어난 횟수이며, 화면은 변화만 구독한다.
final sessionExpiredProvider = NotifierProvider<SessionExpiredNotifier, int>(
  SessionExpiredNotifier.new,
);

class SessionExpiredNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void notify() => state++;
}

/// Non-sensitive revision; never exposes authentication credentials.
final authSessionRevisionProvider = NotifierProvider<AuthSessionRevision, int>(
  AuthSessionRevision.new,
);

class AuthSessionRevision extends Notifier<int> {
  @override
  int build() => 0;
  void advance() => state++;
}

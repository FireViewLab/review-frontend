import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/storage/web_storage.dart';

class AuthTokenStore extends Notifier<bool> {
  static const _keyAccessToken = 'review_access_token';
  static const _keyTokenType = 'review_token_type';
  static const _keyOnboardingCompleted = 'review_onboarding_completed';
  static const _keyNickname = 'review_nickname';
  static const _keyRole = 'review_role';

  String? _accessToken = WebStorage.read(_keyAccessToken);
  String? _tokenType = WebStorage.read(_keyTokenType);
  bool _onboardingCompleted =
      WebStorage.read(_keyOnboardingCompleted) == 'true';
  String? _nickname = WebStorage.read(_keyNickname);
  String? _role = WebStorage.read(_keyRole);

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
    WebStorage.write(_keyAccessToken, accessToken);
    WebStorage.write(_keyTokenType, tokenType);
    WebStorage.write(_keyOnboardingCompleted, onboardingCompleted.toString());
    if (nickname != null && nickname.isNotEmpty) {
      WebStorage.write(_keyNickname, nickname);
    } else {
      WebStorage.remove(_keyNickname);
    }
    if (role != null && role.isNotEmpty) {
      WebStorage.write(_keyRole, role);
    } else {
      WebStorage.remove(_keyRole);
    }
    state = true;
    ref.read(authSessionRevisionProvider.notifier).advance();
  }

  void saveNickname(String nickname) {
    _nickname = nickname;
    WebStorage.write(_keyNickname, nickname);
  }

  void saveRole(String role) {
    _role = role;
    WebStorage.write(_keyRole, role);
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    WebStorage.write(_keyOnboardingCompleted, 'true');
  }

  /// 저장된 토큰으로 보낸 요청이 401을 받았을 때 부른다. 로그아웃하고 만료를 알린다.
  void expireSession() {
    if (_accessToken == null) return;
    clear();
    ref.read(sessionExpiredProvider.notifier).notify();
  }

  void clear() {
    _accessToken = null;
    _tokenType = null;
    _onboardingCompleted = false;
    _nickname = null;
    _role = null;
    WebStorage.remove(_keyAccessToken);
    WebStorage.remove(_keyTokenType);
    WebStorage.remove(_keyOnboardingCompleted);
    WebStorage.remove(_keyNickname);
    WebStorage.remove(_keyRole);
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

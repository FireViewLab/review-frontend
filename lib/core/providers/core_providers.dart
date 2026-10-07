import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final authTokenStoreProvider = NotifierProvider<AuthTokenStore, bool>(
  AuthTokenStore.new,
);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authTokenStoreProvider);
});

final authSessionProvider = Provider<({int revision, bool isLoggedIn})>(
  (ref) => (
    revision: ref.watch(authSessionRevisionProvider),
    isLoggedIn: ref.watch(isLoggedInProvider),
  ),
);

final isAdminProvider = Provider<bool>((ref) {
  final loggedIn = ref.watch(authSessionProvider).isLoggedIn;
  if (!loggedIn) return false;
  return ref.read(authTokenStoreProvider.notifier).isAdmin;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(appConfigProvider),
    tokenStore: ref.read(authTokenStoreProvider.notifier),
  );
});

/// WebStorage에 닉네임이 있으면 즉시 반환, 없으면 GET /api/users/me 로 fetch 후 저장.
final userNicknameProvider = FutureProvider.autoDispose<String?>((ref) async {
  final session = ref.watch(authSessionProvider);
  final isLoggedIn = session.isLoggedIn;
  if (!isLoggedIn) return null;

  final tokenStore = ref.read(authTokenStoreProvider.notifier);
  final cached = tokenStore.nickname;
  if (cached != null && cached.isNotEmpty) return cached;

  try {
    final apiClient = ref.read(apiClientProvider);
    final config = ref.read(appConfigProvider);
    final response = await apiClient.get(config.userMePath);
    if (!ref.mounted ||
        ref.read(authSessionProvider).revision != session.revision)
      return null;
    if (response.data is Map<String, dynamic>) {
      final payload = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
      );
      final data = payload.data;
      if (data is Map<String, dynamic>) {
        final nickname =
            data['name']?.toString() ?? data['nickname']?.toString();
        if (nickname != null && nickname.isNotEmpty) {
          tokenStore.saveNickname(nickname);
          return nickname;
        }
      }
    }
  } catch (_) {}

  return null;
});

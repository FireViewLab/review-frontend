import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/core/providers/core_providers.dart';

void main() {
  test('expires the session once even when several requests fail', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final store = container.read(authTokenStoreProvider.notifier);
    store.save(accessToken: 'token', tokenType: 'Bearer');
    expect(container.read(isLoggedInProvider), isTrue);

    store.expireSession();
    store.expireSession();

    expect(container.read(isLoggedInProvider), isFalse);
    expect(container.read(sessionExpiredProvider), 1);
  });

  test('does not report expiry for a request made without a token', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(authTokenStoreProvider.notifier).expireSession();

    expect(container.read(sessionExpiredProvider), 0);
  });
}

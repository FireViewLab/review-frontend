import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/widgets/startup_focus_scope.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/providers/locale_provider.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_overlay.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/app/router/route_paths.dart';

/// 로그인 만료 안내처럼 화면과 상관없이 띄우는 알림에 쓴다.
final _messengerKey = GlobalKey<ScaffoldMessengerState>();

class ReViewApp extends ConsumerWidget {
  const ReViewApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    ref.listen(sessionExpiredProvider, (_, _) {
      final messenger = _messengerKey.currentState;
      final context = _messengerKey.currentContext;
      if (messenger == null || context == null) return;
      final l10n = AppLocalizations.of(context);
      final location = router.routerDelegate.currentConfiguration.uri;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.sessionExpiredMessage),
            action: SnackBarAction(
              label: l10n.sessionExpiredLogin,
              onPressed: () => router.go(
                Uri(
                  path: RoutePaths.login,
                  queryParameters: {'from': location.toString()},
                ).toString(),
              ),
            ),
          ),
        );
    });

    return StartupFocusScope(
      child: MaterialApp.router(
        title: 'Re:view',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
        scaffoldMessengerKey: _messengerKey,
        builder: (context, child) => ChatOverlay(child: child!),
        locale: locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}

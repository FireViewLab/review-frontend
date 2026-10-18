import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/core/providers/locale_provider.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

Widget localizedApp({required GoRouter router, ThemeData? theme}) {
  return MaterialApp.router(
    theme: theme ?? AppTheme.light,
    routerConfig: router,
    locale: const Locale('ko'),
    supportedLocales: supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  );
}

Future<void> pumpApp(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

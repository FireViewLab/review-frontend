import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/storage/app_storage.dart';

const _storageKey = 'review_locale';

const supportedLocales = [
  Locale('ko'),
  Locale('en'),
  Locale('ja'),
  Locale('zh'),
];

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final saved = AppStorage.read(_storageKey);
    if (saved != null) {
      final match = supportedLocales.where((l) => l.languageCode == saved);
      if (match.isNotEmpty) return match.first;
    }
    return const Locale('ko');
  }

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    AppStorage.write(_storageKey, locale.languageCode);
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

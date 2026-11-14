// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

class SecureStorage {
  static Future<void> init() async {}

  static String? read(String key) => html.window.localStorage[key];
  static void write(String key, String value) =>
      html.window.localStorage[key] = value;
  static void remove(String key) => html.window.localStorage.remove(key);
}

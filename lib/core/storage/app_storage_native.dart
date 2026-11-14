import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final Map<String, String> _memory = {};
  static SharedPreferencesAsync? _backend;
  static Future<void>? _initialization;
  static Future<void> _pending = Future.value();

  static Future<void> init() => _initialization ??= _initialize();

  static Future<void> _initialize() async {
    try {
      final backend = SharedPreferencesAsync();
      final values = await backend.getAll();
      _memory.addAll({
        for (final entry in values.entries)
          if (entry.value is String) entry.key: entry.value as String,
      });
      _backend = backend;
    } on Object {
      // 저장소를 사용할 수 없으면 메모리로 계속 동작한다.
    }
  }

  static String? read(String key) => _memory[key];

  static void write(String key, String value) {
    _memory[key] = value;
    final backend = _backend;
    if (backend != null) _persist(() => backend.setString(key, value));
  }

  static void remove(String key) {
    _memory.remove(key);
    final backend = _backend;
    if (backend != null) _persist(() => backend.remove(key));
  }

  static void _persist(Future<void> Function() operation) {
    // 연속 저장·삭제가 호출 순서대로 반영되도록 한다.
    _pending = _pending.then((_) async {
      try {
        await operation();
      } on Object {
        return;
      }
    });
    unawaited(_pending);
  }
}

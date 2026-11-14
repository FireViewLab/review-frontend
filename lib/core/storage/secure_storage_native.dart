import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final Map<String, String> _memory = {};
  static FlutterSecureStorage? _backend;
  static Future<void>? _initialization;
  static Future<void> _pending = Future.value();

  static Future<void> init() => _initialization ??= _initialize();

  static Future<void> _initialize() async {
    try {
      const backend = FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );
      _memory.addAll(await backend.readAll());
      _backend = backend;
    } on Object {
      // 저장소를 사용할 수 없으면 메모리로 계속 동작한다.
    }
  }

  static String? read(String key) => _memory[key];

  static void write(String key, String value) {
    _memory[key] = value;
    final backend = _backend;
    if (backend != null) _persist(() => backend.write(key: key, value: value));
  }

  static void remove(String key) {
    _memory.remove(key);
    final backend = _backend;
    if (backend != null) _persist(() => backend.delete(key: key));
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

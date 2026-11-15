import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final Map<String, String> _memory = {};
  static FlutterSecureStorage? _backend;
  static Future<void>? _initialization;
  static Future<void> _pending = Future.value();

  static Future<void> init() => _initialization ??= _initialize();

  static Future<void> _initialize() async {
    const backend = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    _backend = backend;
    try {
      _memory.addAll(await backend.readAll());
    } on Object {
      // 읽지 못하면 로그아웃 상태로 시작하고, 남은 값이 다음 실행에 다시 나타나지 않게 지운다.
      _persist(backend.deleteAll);
    }
  }

  static String? read(String key) => _memory[key];

  static void write(String key, String value) {
    _memory[key] = value;
    final backend = _backend;
    if (backend == null) return;
    _persist(() async {
      try {
        await backend.write(key: key, value: value);
      } on Object {
        // 새 값을 못 쓰면 이전 값이라도 남지 않게 지운다.
        await backend.delete(key: key);
      }
    });
  }

  static void remove(String key) {
    _memory.remove(key);
    final backend = _backend;
    if (backend == null) return;
    _persist(() async {
      try {
        await backend.delete(key: key);
      } on Object {
        await backend.delete(key: key);
      }
    });
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

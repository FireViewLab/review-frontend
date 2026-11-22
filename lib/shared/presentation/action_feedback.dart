import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract final class ActionFeedback {
  static void selection() {
    if (!kIsWeb) unawaited(_selectionClick());
  }

  static Future<void> _selectionClick() async {
    try {
      await HapticFeedback.selectionClick();
    } on PlatformException {
      // 기기의 피드백 지원 여부가 성공한 상품 작업에 영향을 주지 않는다.
    } on MissingPluginException {
      // 햅틱을 제공하지 않는 플랫폼에서는 표시 상태만 갱신한다.
    }
  }
}

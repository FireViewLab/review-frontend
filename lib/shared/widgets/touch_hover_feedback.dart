import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// 마우스 hover 로만 보이던 강조를 터치로 누르는 동안에도 보이게 한다.
///
/// 마우스 클릭은 건드리지 않아 기존 hover 동작이 그대로 남는다.
mixin TouchHoverFeedback<T extends StatefulWidget> on State<T> {
  bool _touchPressed = false;

  /// hover 강조를 켜고 끈다.
  void setHover(bool value);

  void handleTouchDown(TapDownDetails details) {
    if (details.kind == PointerDeviceKind.mouse) return;
    _touchPressed = true;
    setHover(true);
  }

  void handleTouchEnd() {
    if (!_touchPressed || !mounted) return;
    _touchPressed = false;
    setHover(false);
  }
}

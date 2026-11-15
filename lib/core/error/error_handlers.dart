import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 앱에서 처리되지 않은 예외를 한곳에서 받는다. 원격 수집은 하지 않고 디버그에서만 출력한다.
/// 웹은 기존 동작을 그대로 둔다.
void installErrorHandlers() {
  if (kIsWeb) return;
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) debugPrint('Uncaught $error\n$stack');
    return true;
  };
  // 릴리스 빌드에서는 위젯 오류 자리에 빨간 화면 대신 빈 대체 화면을 둔다.
  if (kReleaseMode) {
    ErrorWidget.builder = (_) => const _ErrorFallback();
  }
}

class _ErrorFallback extends StatelessWidget {
  const _ErrorFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Color(0xFF9E9E9E),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

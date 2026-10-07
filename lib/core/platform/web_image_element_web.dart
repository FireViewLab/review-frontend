import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// HtmlElementView로 만든 `<img>`를 설정한다.
///
/// 화면 밖 이미지는 보일 때 받도록 지연 로딩하고, 디코딩이 메인 스레드를
/// 막지 않게 한다. 로딩에 실패하면 [onError]로 알려 placeholder로 바꾼다.
void configureWebImageElement(
  Object element, {
  required String url,
  required String objectFit,
  required VoidCallback onError,
}) {
  final img = element as web.HTMLImageElement;
  img
    ..loading = 'lazy'
    ..decoding = 'async'
    ..alt = '';
  img.style
    ..width = '100%'
    ..height = '100%'
    ..objectFit = objectFit
    ..display = 'block'
    ..pointerEvents = 'none';
  img.addEventListener(
    'error',
    ((web.Event _) => onError()).toJS,
    web.AddEventListenerOptions(once: true),
  );
  // 리스너를 단 뒤에 src를 넣어야 바로 실패하는 경우도 잡힌다.
  img.src = url;
}

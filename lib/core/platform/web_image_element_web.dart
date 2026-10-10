import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// HtmlElementView의 bounded viewport 안에서 외부 CDN 이미지를 표시한다.
///
/// 화면 밖 이미지는 보일 때 받도록 지연 로딩하고, 디코딩이 메인 스레드를
/// 막지 않게 한다. 로딩에 실패하면 [onError]로 알려 placeholder로 바꾼다.
void configureWebImageElement(
  Object element, {
  required String url,
  required String objectFit,
  required VoidCallback onError,
}) {
  final viewport = element as web.HTMLDivElement;
  // Own only this view's DOM. Never mutate Flutter's host/slot or global z-index.
  viewport.style
    ..position = 'relative'
    ..width = '100%'
    ..height = '100%'
    ..minWidth = '0'
    ..minHeight = '0'
    ..maxWidth = '100%'
    ..maxHeight = '100%'
    ..boxSizing = 'border-box'
    ..overflow = 'hidden'
    ..contain = 'layout paint'
    ..pointerEvents = 'none';
  final img = web.HTMLImageElement()
    ..loading = 'lazy'
    ..decoding = 'async'
    ..alt = '';
  img.style
    ..position = 'absolute'
    ..inset = '0'
    ..width = '100%'
    ..height = '100%'
    ..maxWidth = '100%'
    ..maxHeight = '100%'
    ..boxSizing = 'border-box'
    ..objectFit = objectFit
    ..objectPosition = 'center'
    ..display = 'block'
    ..pointerEvents = 'none';
  viewport.append(img);
  img.addEventListener(
    'error',
    ((web.Event _) => onError()).toJS,
    web.AddEventListenerOptions(once: true),
  );
  // 리스너를 단 뒤에 src를 넣어야 바로 실패하는 경우도 잡힌다.
  img.src = url;
}

import 'package:flutter/foundation.dart';

/// 웹이 아닌 플랫폼에서는 쓰지 않는다.
void configureWebImageElement(
  Object element, {
  required String url,
  required String objectFit,
  required VoidCallback onError,
}) {}

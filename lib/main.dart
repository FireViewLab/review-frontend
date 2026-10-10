import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:re_view_front/app/app.dart';

void main() {
  // OAuth 콜백(/auth/callback?accessToken=...)처럼 서버가 경로와 쿼리로
  // 돌려보내는 URL을 읽으려면 해시(#/) 대신 경로 URL을 써야 한다.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: ReViewApp()));
}

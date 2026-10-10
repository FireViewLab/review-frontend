import 'package:flutter/material.dart';

/// 앱 전체에서 쓰는 애니메이션 시간과 곡선.
///
/// 로딩 반복 주기, 자동 재생 간격, 입력 대기(debounce) 같은 값은 여기 넣지 않는다.
abstract final class AppMotion {
  /// 페이지 전환, 호버 색 변화, 아이콘 교체.
  static const fast = Duration(milliseconds: 120);

  /// 메뉴·패널 열기, 작은 상태 변화.
  static const base = Duration(milliseconds: 180);

  /// 단계 전환, 값이 채워지는 그래프, 사용자가 누른 스크롤.
  static const slow = Duration(milliseconds: 240);

  /// 나타날 때의 기본 곡선.
  static const enter = Curves.easeOutCubic;

  /// 사라질 때의 곡선.
  static const exit = Curves.easeInCubic;

  /// 사용자가 움직임 줄이기를 켰으면 0을 돌려준다.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}

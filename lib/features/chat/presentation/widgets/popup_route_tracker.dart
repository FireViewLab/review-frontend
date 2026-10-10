import 'package:flutter/widgets.dart';

/// 루트 Navigator에 떠 있는 팝업(다이얼로그, 바텀시트, 메뉴) 수를 센다.
///
/// 챗봇 레이어는 Navigator 위에 있으므로, 팝업이 열려 있는 동안 숨겨야
/// 모달 배리어를 넘어 클릭되지 않는다.
class PopupRouteTracker extends NavigatorObserver implements Listenable {
  final _openCount = ValueNotifier<int>(0);

  bool get hasPopup => _openCount.value > 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) _openCount.value++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _closed(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _closed(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _closed(oldRoute);
    if (newRoute is PopupRoute) _openCount.value++;
  }

  void _closed(Route<dynamic> route) {
    if (route is PopupRoute && _openCount.value > 0) _openCount.value--;
  }

  @override
  void addListener(VoidCallback listener) => _openCount.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _openCount.removeListener(listener);
}

final popupRouteTracker = PopupRouteTracker();

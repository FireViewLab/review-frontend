import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_motion.dart';

/// 화면에 처음 나타날 때 한 번 짧게 떠오르는 효과.
///
/// 내용이 늦게 보이지 않도록 지연은 짧게만 허용한다. 움직임 줄이기를 켠 사용자에게는
/// 바로 보여 준다.
class AppFadeIn extends StatefulWidget {
  const AppFadeIn({required this.child, this.delay = 0, super.key});

  final Widget child;

  /// 차례로 나타나게 할 때의 순서 값(밀리초 기준). 실제 지연은 [_maxDelay]를 넘지 않는다.
  final int delay;

  static const _maxDelay = Duration(milliseconds: 60);

  @override
  State<AppFadeIn> createState() => _AppFadeInState();
}

class _AppFadeInState extends State<AppFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.base,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 8),
    end: Offset.zero,
  ).animate(_opacity);
  Timer? _timer;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _timer?.cancel();
      _controller.value = 1;
      _started = true;
      return;
    }
    if (_started) return;
    _started = true;
    // 지연은 원래 값의 1/4만 쓰고 상한을 둔다.
    final delay = Duration(milliseconds: widget.delay ~/ 4);
    final capped = delay > AppFadeIn._maxDelay ? AppFadeIn._maxDelay : delay;
    if (capped == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(capped, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: AnimatedBuilder(
        animation: _offset,
        child: widget.child,
        builder: (context, child) =>
            Transform.translate(offset: _offset.value, child: child),
      ),
    );
  }
}

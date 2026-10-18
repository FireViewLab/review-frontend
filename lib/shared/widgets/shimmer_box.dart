import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const _baseColor = Color(0xFFE0E0E0);
const _highlightColor = Color(0xFFF5F5F5);

// ShimmerBox는 반드시 ShimmerWrapper 안에서 사용해야 sweep이 동기화됩니다.
// 단독 사용 시엔 ShimmerWrapper로 감싸세요.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.width, this.height, this.radius = 0});

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
      ),
    );
    return child;
  }
}

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: !MediaQuery.disableAnimationsOf(context),
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

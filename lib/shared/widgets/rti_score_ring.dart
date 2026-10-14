import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

/// RTI 점수를 원형 게이지로 보여 준다. 점수가 없으면 쓰지 않는다.
class RtiScoreRing extends StatelessWidget {
  const RtiScoreRing({
    super.key,
    required this.score,
    required this.color,
    this.size = 96,
  });

  final num score;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final value = score.clamp(0, 100);
    final label = value == value.roundToDouble()
        ? '${value.toInt()}'
        : value.toStringAsFixed(1);
    return Semantics(
      label: 'RTI $label',
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _RingPainter(
            progress: value / 100,
            color: color,
            strokeWidth: size * .09,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: size * .3,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1,
                  ),
                ),
                if (size >= 72) ...[
                  const SizedBox(height: 2),
                  Text(
                    'RTI',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);
    final track = Paint()
      ..color = color.withValues(alpha: .14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, track);
    if (progress <= 0) return;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}

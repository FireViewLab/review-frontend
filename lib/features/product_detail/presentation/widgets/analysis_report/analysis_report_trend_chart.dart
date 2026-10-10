// ignore_for_file: use_key_in_widget_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';

// Chart Widget
class AnalysisReportTrendChart extends StatelessWidget {
  const AnalysisReportTrendChart({required this.points});
  final List<AnalysisTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      painter: AnalysisReportTrendChartPainter(points: points),
      size: Size.infinite,
    );
  }
}

class AnalysisReportTrendChartPainter extends CustomPainter {
  const AnalysisReportTrendChartPainter({required this.points});
  final List<AnalysisTrendPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    const leftPad = 36.0;
    const bottomPad = 24.0;
    const topPad = 8.0;

    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final chartLeft = leftPad;
    final chartTop = topPad;
    final chartBottom = size.height - bottomPad;

    // Grid lines (0, 25, 50, 75, 100)
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10);

    for (var i = 0; i <= 4; i++) {
      final y = chartTop + chartH * (1 - i / 4);
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartW, y),
        gridPaint,
      );
      final label = '${(i * 25).toInt()}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Compute point positions
    Offset pt(int i, double value) {
      final x = chartLeft + chartW * i / (points.length - 1);
      final y = chartTop + chartH * (1 - value.clamp(0, 100) / 100);
      return Offset(x, y);
    }

    final rtiPts = List.generate(
      points.length,
      (i) => pt(i, points[i].averageRti),
    );
    final dangerPts = List.generate(points.length, (i) {
      final rc = points[i].reviewCount;
      final pct = rc > 0 ? points[i].dangerCount / rc * 100 : 0.0;
      return pt(i, pct);
    });

    // Draw RTI filled area
    final fillPath = Path()..moveTo(rtiPts.first.dx, chartBottom);
    for (final pt in rtiPts) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(rtiPts.last.dx, chartBottom);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFF2563EB).withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Draw RTI smooth line
    _drawSmoothLine(
      canvas,
      rtiPts,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw danger% dashed line
    _drawDashedLine(
      canvas,
      dangerPts,
      Paint()
        ..color = const Color(0xFFF97316)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // X-axis date labels
    final labelCount = math.min(5, points.length);
    final step = (points.length / labelCount).ceil().clamp(1, 999);
    for (var i = 0; i < points.length; i += step) {
      final x = chartLeft + chartW * i / (points.length - 1);
      final dateLabel = _fmtDate(points[i].date);
      final tp = TextPainter(
        text: TextSpan(text: dateLabel, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - bottomPad + 6));
    }
    // Always show last
    {
      final tp = TextPainter(
        text: TextSpan(text: '오늘', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(chartLeft + chartW - tp.width, size.height - bottomPad + 6),
      );
    }
  }

  static void _drawSmoothLine(Canvas canvas, List<Offset> pts, Paint paint) {
    if (pts.length < 2) return;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final cp1x =
          pts[i].dx + (pts[i + 1].dx - (i > 0 ? pts[i - 1].dx : pts[0].dx)) / 6;
      final cp1y =
          pts[i].dy + (pts[i + 1].dy - (i > 0 ? pts[i - 1].dy : pts[0].dy)) / 6;
      final cp2x =
          pts[i + 1].dx -
          (i + 2 < pts.length
                  ? pts[i + 2].dx - pts[i].dx
                  : pts[i + 1].dx - pts[i].dx) /
              6;
      final cp2y =
          pts[i + 1].dy -
          (i + 2 < pts.length
                  ? pts[i + 2].dy - pts[i].dy
                  : pts[i + 1].dy - pts[i].dy) /
              6;
      path.cubicTo(cp1x, cp1y, cp2x, cp2y, pts[i + 1].dx, pts[i + 1].dy);
    }
    canvas.drawPath(path, paint);
  }

  static void _drawDashedLine(Canvas canvas, List<Offset> pts, Paint paint) {
    const dashLen = 6.0;
    const gapLen = 4.0;
    for (var i = 0; i < pts.length - 1; i++) {
      final dx = pts[i + 1].dx - pts[i].dx;
      final dy = pts[i + 1].dy - pts[i].dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist == 0) continue;
      final ux = dx / dist;
      final uy = dy / dist;
      var remaining = dist;
      var x = pts[i].dx;
      var y = pts[i].dy;
      var drawing = true;
      while (remaining > 0) {
        final len = math.min(drawing ? dashLen : gapLen, remaining);
        if (drawing) {
          canvas.drawLine(
            Offset(x, y),
            Offset(x + ux * len, y + uy * len),
            paint,
          );
        }
        x += ux * len;
        y += uy * len;
        remaining -= len;
        drawing = !drawing;
      }
    }
  }

  static String _fmtDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return raw.length > 5 ? raw.substring(5) : raw;
    }
  }

  @override
  bool shouldRepaint(AnalysisReportTrendChartPainter old) =>
      old.points != points;
}

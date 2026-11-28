import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/presentation/formatters/analysis_trend_period.dart';

void main() {
  group('filterAnalysisTrendByPeriod', () {
    test('includes both local calendar endpoints across a month boundary', () {
      final firstDay = _point('2026-11-28');
      final lastInstantToday = _point(
        DateTime(2026, 12, 4, 23, 59, 59).toUtc().toIso8601String(),
      );
      final nextDay = _point(DateTime(2026, 12, 5).toUtc().toIso8601String());

      final result = filterAnalysisTrendByPeriod(
        [_point('2026-11-27'), firstDay, lastInstantToday, nextDay],
        now: DateTime(2026, 12, 4, 12),
        days: 7,
      );

      expect(result.map((observation) => observation.point), [
        firstDay,
        lastInstantToday,
      ]);
    });

    test('excludes malformed dates and calendar overflows', () {
      final valid = _point('2026-03-01');
      final result = filterAnalysisTrendByPeriod(
        [
          _point('not-a-date'),
          _point('2026-02-30'),
          _point('2026-03-01T25:00:00'),
          _point('2026-0301'),
          valid,
        ],
        now: DateTime(2026, 3, 3),
        days: 7,
      );

      expect(result.map((observation) => observation.point), [valid]);
    });

    test(
      'returns an empty list when every observation is outside the period',
      () {
        final result = filterAnalysisTrendByPeriod(
          [_point('2026-10-01'), _point('2026-12-05')],
          now: DateTime(2026, 12, 4),
          days: 30,
        );

        expect(result, isEmpty);
      },
    );

    test('preserves the score and local date of a single observation', () {
      final date = DateTime(2026, 12, 4, 18);
      final point = _point(date.toUtc().toIso8601String());
      final result = filterAnalysisTrendByPeriod(
        [point],
        now: DateTime(2026, 12, 4, 8),
        days: 7,
      );

      expect(result, [(point: point, localDate: date)]);
    });
  });
}

AnalysisTrendPoint _point(String date) => AnalysisTrendPoint(
  date: date,
  averageRti: 82.5,
  reviewCount: 10,
  safeCount: 8,
  warnCount: 1,
  dangerCount: 1,
);

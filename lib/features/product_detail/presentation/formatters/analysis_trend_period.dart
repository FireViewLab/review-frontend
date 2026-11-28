import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';

typedef DatedAnalysisTrendPoint = ({
  AnalysisTrendPoint point,
  DateTime localDate,
});

final _isoDate = RegExp(
  r'^(\d{4})(-?)(\d{2})\2(\d{2})(?:[T ](?:[01]\d|2[0-3])'
  r'(?::?[0-5]\d(?::?[0-5]\d(?:[.,]\d+)?)?)?'
  r'(?: ?(?:[zZ]|[+-](?:[01]\d|2[0-3])(?::?[0-5]\d)?))?)?$',
);

List<DatedAnalysisTrendPoint> filterAnalysisTrendByPeriod(
  Iterable<AnalysisTrendPoint> points, {
  required DateTime now,
  required int days,
}) {
  if (days <= 0) return const [];
  final today = now.toLocal();
  // 달력 날짜로 경계를 계산해 일광 절약 시간 전환의 영향을 피한다.
  final firstDay = DateTime(today.year, today.month, today.day - days + 1);
  final nextDay = DateTime(today.year, today.month, today.day + 1);
  final filtered = <DatedAnalysisTrendPoint>[];
  for (final point in points) {
    final localDate = _parseLocalDate(point.date);
    if (localDate == null ||
        localDate.isBefore(firstDay) ||
        !localDate.isBefore(nextDay)) {
      continue;
    }
    filtered.add((point: point, localDate: localDate));
  }
  return filtered;
}

DateTime? _parseLocalDate(String value) {
  final match = _isoDate.firstMatch(value);
  if (match == null) return null;

  final year = int.parse(match[1]!);
  final month = int.parse(match[3]!);
  final day = int.parse(match[4]!);
  // DateTime.parse는 2월 30일 같은 값을 다음 달로 넘겨 해석한다.
  final calendarDate = DateTime.utc(year, month, day);
  if (calendarDate.month != month || calendarDate.day != day) return null;
  return DateTime.tryParse(value)?.toLocal();
}

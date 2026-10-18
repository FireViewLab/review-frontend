/// 관리자 화면 공통 날짜/숫자 포맷 유틸.

String _two(int n) => n.toString().padLeft(2, '0');

/// 'yyyy.MM.dd HH:mm' 형식. null이면 '-'.
String formatAdminDateTime(DateTime? dt) {
  if (dt == null) return '-';
  final local = dt.toLocal();
  return '${local.year}.${_two(local.month)}.${_two(local.day)} '
      '${_two(local.hour)}:${_two(local.minute)}';
}

/// 'yyyy.MM.dd' 형식. null이면 '-'.
String formatAdminDate(DateTime? dt) {
  if (dt == null) return '-';
  final local = dt.toLocal();
  return '${local.year}.${_two(local.month)}.${_two(local.day)}';
}

/// 천 단위 콤마. 예: 1248 -> '1,248'.
String formatAdminCount(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

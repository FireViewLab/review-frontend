import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

String formatSearchPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return '$buffer원';
}

String formatSearchCount(int? count) {
  if (count == null) return '';
  final digits = count.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}

Color colorFromHex(String? hex) {
  final normalized = (hex ?? '').replaceFirst('#', '');
  if (normalized.length == 6) {
    final value = int.tryParse('FF$normalized', radix: 16);
    if (value != null) return Color(value);
  } else if (normalized.length == 8) {
    final value = int.tryParse(normalized, radix: 16);
    if (value != null) return Color(value);
  }
  return AppColors.textTertiary;
}

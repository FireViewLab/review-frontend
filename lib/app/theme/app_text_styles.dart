import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'Freesentation';

  static const List<String> _cjkFallback = [
    'Noto Sans JP',
    'Noto Sans SC',
    'sans-serif',
  ];

  static const displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _cjkFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  static const display = displayMedium;
  static const title = titleLarge;
  static const body = bodyLarge;
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

/// AI 어시스턴트 화면에서만 쓰는 색과 모양.
abstract final class ChatStyle {
  static const accent = Color(0xFF7C3AED);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, accent],
  );

  static const ink = AppColors.primaryDark;
  static const line = Color(0xFFE2E8F0);
  static const wash = Color(0xFFF3F1FF);

  static const noticeBackground = Color(0xFFFFFBEB);
  static const noticeBorder = Color(0xFFFDE68A);
  static const noticeText = Color(0xFF92400E);
  static const errorBackground = Color(0xFFFEF2F2);
  static const errorBorder = Color(0xFFFECACA);
  static const errorText = Color(0xFF991B1B);
}

/// 어시스턴트를 나타내는 그라데이션 아이콘.
class ChatSparkle extends StatelessWidget {
  const ChatSparkle({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: ChatStyle.gradient,
        borderRadius: BorderRadius.circular(size / 3),
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        size: size * 0.55,
        color: AppColors.onPrimary,
      ),
    );
  }
}

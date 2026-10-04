import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

/// 어시스턴트 화면에서 쓰는 색. 사이트의 다른 화면과 같은 톤을 유지한다.
abstract final class ChatStyle {
  static const ink = AppColors.primaryDark;
  static const line = AppColors.border;

  static const noticeBackground = Color(0xFFFFFBEB);
  static const noticeBorder = Color(0xFFFDE68A);
  static const noticeText = Color(0xFF92400E);
  static const errorBackground = Color(0xFFFEF2F2);
  static const errorBorder = Color(0xFFFECACA);
  static const errorText = Color(0xFF991B1B);
}

/// 어시스턴트를 나타내는 표시. 브랜드 파랑 바탕에 말풍선 아이콘을 쓴다.
class ChatMark extends StatelessWidget {
  const ChatMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.question_answer_rounded,
        size: size * 0.5,
        color: AppColors.onPrimary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

/// 상태 배지 색조. 각 페이지의 상태 enum을 이 톤에 매핑해서 사용한다.
enum AdminBadgeTone { neutral, info, success, warning, danger }

/// 목록/상세에서 처리 상태·등급을 표시하는 작은 컬러 배지.
class AdminStatusBadge extends StatelessWidget {
  const AdminStatusBadge({
    super.key,
    required this.label,
    this.tone = AdminBadgeTone.neutral,
  });

  final String label;
  final AdminBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
          height: 1.2,
        ),
      ),
    );
  }

  (Color, Color) get _colors => switch (tone) {
        AdminBadgeTone.neutral => (AppColors.surfaceMuted, AppColors.textSecondary),
        AdminBadgeTone.info => (AppColors.primaryLight, AppColors.primary),
        AdminBadgeTone.success => (AppColors.successSoft, AppColors.success),
        AdminBadgeTone.warning => (AppColors.warningSoft, AppColors.warning),
        AdminBadgeTone.danger => (AppColors.errorSoft, AppColors.error),
      };
}

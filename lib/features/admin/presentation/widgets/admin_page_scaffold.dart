import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class AdminPageScaffold extends StatelessWidget {
  const AdminPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actions,
    this.scrollable = false,
  });

  final String title;
  final Widget body;

  /// 제목 아래 보조 설명 텍스트.
  final String? subtitle;

  /// 제목 행 우측에 배치되는 액션들 (예: 기간 선택, 새로고침).
  final List<Widget>? actions;

  /// true면 body를 스크롤 영역에 담는다(대시보드처럼 세로로 긴 페이지).
  /// false면 body가 남은 높이를 채운다(테이블 페이지).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: actions!,
          ),
        ],
      ],
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            const SizedBox(height: AppSpacing.lg),
            if (scrollable)
              Expanded(child: SingleChildScrollView(child: body))
            else
              Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class AdminEmptyBody extends StatelessWidget {
  const AdminEmptyBody({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

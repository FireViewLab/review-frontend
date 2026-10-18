import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/side_panel_header.dart';

class ReportProcessCard extends StatelessWidget {
  const ReportProcessCard({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('신고 접수', '대상 리뷰와 신고 사유가 저장됩니다.'),
      ('AI 보조 검토', 'RTI 신호와 유사 리뷰 이력을 함께 확인합니다.'),
      ('운영팀 판단', '허위/악의성이면 무선 검토 상태가 갱신됩니다.'),
      ('결과 알림', '검토 완료되면 피드백 내역에 결과가 반영됩니다.'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SidePanelHeader(
            icon: Icons.task_alt,
            title: '처리 절차',
            description: '신고 접수 후 운영팀이 검토하는 흐름이에요.',
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < steps.length; i++) ...[
            _ProcessRow(
              number: i + 1,
              title: steps[i].$1,
              subtitle: steps[i].$2,
            ),
            if (i < steps.length - 1) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final int number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

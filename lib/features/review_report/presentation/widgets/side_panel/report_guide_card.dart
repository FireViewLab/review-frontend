import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/side_panel/side_panel_header.dart';

class ReportGuideCard extends StatelessWidget {
  const ReportGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('반복 문구를 구체적으로 적기', '정확한 위치/문장/패턴 등 눈에 띄는 표현을 적어주세요.'),
      ('상품 사용 맥락 확인', '실제 사용 경험이 없거나 상품과 무관한 부분을 알려주세요.'),
      ('첨부 자료 첨부', '해당 근거가 여러 상황에 반복된다면 첨부가 좋습니다.'),
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
            icon: Icons.lightbulb_outline,
            title: '신고 가이드',
            description: '이런 경우 신고가 더 잘 처리돼요.',
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < items.length; i++) ...[
            _GuideRow(title: items[i].$1, subtitle: items[i].$2),
            if (i < items.length - 1) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.check, size: 12, color: Colors.white),
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

import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';

class AiEvidenceSection extends StatelessWidget {
  const AiEvidenceSection({
    super.key,
    required this.checked,
    required this.onChanged,
    this.onShowEvidence,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onShowEvidence;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '분석 근거 함께 제출 (선택)',
      description: '현재 리뷰의 RTI 분석 신호를 신고 근거로 첨부할 수 있어요.',
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.base),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: checked
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: checked ? AppColors.primary : AppColors.border,
            width: checked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: checked,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI 분석 근거 첨부',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'RTI 신호 데이터가 신고 근거와 함께 제출돼요.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (onShowEvidence != null)
              TextButton(
                onPressed: onShowEvidence,
                child: const Text(
                  '근거 보기',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({
    super.key,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.onPrivacyChanged,
    required this.onNotFalseChanged,
  });

  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ValueChanged<bool> onPrivacyChanged;
  final ValueChanged<bool> onNotFalseChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg + AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        _AgreementRow(
          checked: agreePrivacy,
          onChanged: onPrivacyChanged,
          title: '개인정보 수집 및 신고 처리 안내에 동의합니다.',
          subtitle: '신고 내용은 리뷰 접수, 처리 결과 안내, 모델 품질 개선을 위해 사용되며 필요한 기간 동안 보관됩니다.',
        ),
        const SizedBox(height: AppSpacing.sm),
        _AgreementRow(
          checked: agreeNotFalse,
          onChanged: onNotFalseChanged,
          title: '허위 신고가 아님을 확인합니다.',
          subtitle: '신고 내용이 사실과 다를 경우 처리 우선순위가 낮아질 수 있습니다.',
        ),
        ],
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.checked,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

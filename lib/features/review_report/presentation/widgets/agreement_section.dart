import 'package:re_view_front/l10n/generated/app_localizations.dart';
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
            title: AppLocalizations.of(context).reportPrivacyConsent,
            subtitle: AppLocalizations.of(context).reportPrivacyDescription,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AgreementRow(
            checked: agreeNotFalse,
            onChanged: onNotFalseChanged,
            title: AppLocalizations.of(context).reportTruthConsent,
            subtitle: AppLocalizations.of(context).reportTruthDescription,
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
      borderRadius: AppRadius.small,
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
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
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

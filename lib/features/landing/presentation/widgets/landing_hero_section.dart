import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class LandingHeroSection extends StatelessWidget {
  const LandingHeroSection({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
    super.key,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.shield_outlined, AppLocalizations.of(context).landingFeatureRti),
      (
        Icons.bar_chart_outlined,
        AppLocalizations.of(context).landingFeatureAdPatterns,
      ),
      (
        Icons.list_alt_outlined,
        AppLocalizations.of(context).landingFeatureEvidence,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ServiceBadge(),
        const SizedBox(height: AppSpacing.lg),
        _Headline(),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocalizations.of(context).landingHeroDescription,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (icon, label) in features)
              _FeatureChip(icon: icon, label: label),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _CtaRow(
          onStartPressed: onStartPressed,
          onRtiInfoPressed: onRtiInfoPressed,
        ),
        const SizedBox(height: AppSpacing.lg),
        _CloseHint(),
      ],
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: [
        const Icon(Icons.shield, color: AppColors.primary, size: 14),
        Text(
          'RE:VIEW TRUST COMMERCE',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.headlineSmall,
        children: [
          TextSpan(text: AppLocalizations.of(context).landingHeroHeadline),
          TextSpan(
            text: 'Re:view',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaRow extends StatelessWidget {
  const _CtaRow({required this.onStartPressed, required this.onRtiInfoPressed});

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(
          height: 52,
          child: AppButton(
            label: AppLocalizations.of(context).landingStart,
            onPressed: onStartPressed,
          ),
        ),
        SizedBox(
          height: 52,
          child: AppButton(
            label: AppLocalizations.of(context).landingLearnRti,
            onPressed: onRtiInfoPressed,
            variant: AppButtonVariant.outlined,
          ),
        ),
      ],
    );
  }
}

class _CloseHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: [
        const Icon(Icons.lock_outline, size: 13, color: AppColors.textTertiary),
        Text(
          AppLocalizations.of(context).landingCloseHint,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

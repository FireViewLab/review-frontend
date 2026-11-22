import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class PasswordResetValuePanel extends StatelessWidget {
  const PasswordResetValuePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Badge(),
          const SizedBox(height: AppSpacing.lg),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1.16,
              ),
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).authResetVerifyHeadline,
                ),
                TextSpan(
                  text: AppLocalizations.of(context).authResetHeadlineEmphasis,
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).authResetHeadlineEnd,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).authResetValueDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          const _ProcessCard(),
          const SizedBox(height: AppSpacing.lg),
          const _BenefitGrid(),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          AppLocalizations.of(context).authResetRecoveryBadge,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard();

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        label: AppLocalizations.of(context).authVerifyEmail,
        desc: AppLocalizations.of(context).authResetEmailStepDescription,
      ),
      (
        label: AppLocalizations.of(context).authResetCodeStep,
        desc: AppLocalizations.of(context).authResetCodeStepDescription(6),
      ),
      (
        label: AppLocalizations.of(context).authResetNewPasswordStep,
        desc: AppLocalizations.of(context).authResetNewPasswordStepDescription,
      ),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).authResetProcessTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SecurityBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppLocalizations.of(context).authResetProcessDescription,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (int i = 0; i < steps.length; i++) ...[
              _ProcessStep(
                number: i + 1,
                label: steps[i].label,
                desc: steps[i].desc,
              ),
              if (i < steps.length - 1) const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context).authResetSecurityBadge,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({
    required this.number,
    required this.label,
    required this.desc,
  });

  final int number;
  final String label;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$number',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        label: 'A',
        title: AppLocalizations.of(context).authResetKeepData,
        body: AppLocalizations.of(context).authResetKeepDataDescription,
      ),
      (
        label: 'B',
        title: AppLocalizations.of(context).authResetProtectCode,
        body: AppLocalizations.of(context).authResetProtectCodeDescription,
      ),
      (
        label: 'C',
        title: AppLocalizations.of(context).authResetSignInAgain,
        body: AppLocalizations.of(context).authResetSignInAgainDescription,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in items)
            _BenefitCard(label: item.label, title: item.title, body: item.body),
        ];

        if (!useRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.label,
    required this.title,
    required this.body,
  });

  final String label;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

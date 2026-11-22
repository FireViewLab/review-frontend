import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class SignupValuePanel extends StatelessWidget {
  const SignupValuePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SignupBadge(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).authSignupFilterHeadline,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).authSignupFilterDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          const _SignupFlowCard(),
          const SizedBox(height: AppSpacing.lg),
          const _SignupBenefitGrid(),
        ],
      ),
    );
  }
}

class _SignupBadge extends StatelessWidget {
  const _SignupBadge();

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
          AppLocalizations.of(context).authSignupCreateAccount,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SignupFlowCard extends StatelessWidget {
  const _SignupFlowCard();

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        number: '1',
        title: AppLocalizations.of(context).authSignupAccountStep,
        body: AppLocalizations.of(context).authSignupAccountStepDescription,
        status: AppLocalizations.of(context).authSignupCurrentStep,
      ),
      (
        number: '2',
        title: AppLocalizations.of(context).authSignupInterestStep,
        body: AppLocalizations.of(context).authSignupInterestStepDescription,
        status: AppLocalizations.of(context).authNext,
      ),
      (
        number: '3',
        title: AppLocalizations.of(context).authSignupFilterStep,
        body: AppLocalizations.of(context).authSignupFilterStepDescription,
        status: AppLocalizations.of(context).myPageOnboardingComplete,
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
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).authSignupFollowupFlow,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).authSignupFollowupDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _StepBadge(
                  label: AppLocalizations.of(context).authSetupMinutes(3),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final step in steps) ...[
              _FlowStep(
                number: step.number,
                title: step.title,
                body: step.body,
                status: step.status,
              ),
              if (step != steps.last) const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.label});

  final String label;

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
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.number,
    required this.title,
    required this.body,
    required this.status,
  });

  final String number;
  final String title;
  final String body;
  final String status;

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
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _StepBadge(label: status),
          ],
        ),
      ),
    );
  }
}

class _SignupBenefitGrid extends StatelessWidget {
  const _SignupBenefitGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        mark: 'A',
        title: AppLocalizations.of(context).authSignupPersonalizedBrowse,
        body: AppLocalizations.of(
          context,
        ).authSignupPersonalizedBrowseDescription,
      ),
      (
        mark: 'B',
        title: AppLocalizations.of(context).authSignupSavedAlerts,
        body: AppLocalizations.of(context).authSignupSavedAlertsDescription,
      ),
      (
        mark: 'C',
        title: AppLocalizations.of(context).authSignupFeedbackHistory,
        body: AppLocalizations.of(context).authSignupFeedbackHistoryDescription,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in items)
            _BenefitCard(mark: item.mark, title: item.title, body: item.body),
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
    required this.mark,
    required this.title,
    required this.body,
  });

  final String mark;
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
                mark,
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

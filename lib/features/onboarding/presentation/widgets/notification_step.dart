import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

class NotificationStep extends StatelessWidget {
  const NotificationStep({
    super.key,
    required this.state,
    required this.onChanged,
    required this.onPrevious,
    required this.onComplete,
  });
  final OnboardingState state;
  final ValueChanged<SettingsData> onChanged;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;
  @override
  Widget build(BuildContext context) {
    final settings = state.settings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).settingsNotifications,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(AppLocalizations.of(context).onboardingNotificationDescription),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(AppLocalizations.of(context).settingsRiskyProduct),
          value: settings.notifyRiskyProduct,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyRiskyProduct: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(AppLocalizations.of(context).settingsAnalysisComplete),
          value: settings.notifyAnalysisComplete,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyAnalysisComplete: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(AppLocalizations.of(context).onboardingFeedbackResults),
          value: settings.notifyFeedbackResult,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyFeedbackResult: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(AppLocalizations.of(context).onboardingMarketingConsent),
          value: settings.notifyMarketing,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyMarketing: value)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppLocalizations.of(context).onboardingNotificationAvailability),
        const SizedBox(height: AppSpacing.lg),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          spacing: 12,
          children: [
            OutlinedButton(
              onPressed: onPrevious,
              child: Text(AppLocalizations.of(context).onboardingPrevious),
            ),
            FilledButton(
              onPressed: onComplete,
              child: Text(AppLocalizations.of(context).onboardingSaveComplete),
            ),
          ],
        ),
      ],
    );
  }
}

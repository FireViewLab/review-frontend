import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_section_widgets.dart';

class SettingsServerSettingsSections extends StatelessWidget {
  const SettingsServerSettingsSections({
    super.key,
    required this.data,
    required this.onChanged,
  });
  final SettingsData data;
  final ValueChanged<SettingsData> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget section(String title, IconData icon, List<Widget> children) =>
        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsSectionHeader(
                icon: icon,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
                title: title,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...children,
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        section(l10n.settingsNotifications, Icons.notifications_outlined, [
          SettingsToggleRow(
            icon: Icons.warning_amber_outlined,
            label: l10n.settingsRiskyProduct,
            description: l10n.settingsRiskyProductDesc,
            value: data.notifyRiskyProduct,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyRiskyProduct: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.analytics_outlined,
            label: l10n.settingsAnalysisComplete,
            description: l10n.settingsAnalysisCompleteDesc,
            value: data.notifyAnalysisComplete,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyAnalysisComplete: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.feedback_outlined,
            label: l10n.settingsFeedbackResult,
            description: l10n.settingsFeedbackResultDesc,
            value: data.notifyFeedbackResult,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyFeedbackResult: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.campaign_outlined,
            label: l10n.settingsMarketing,
            description: l10n.settingsMarketingDesc,
            value: data.notifyMarketing,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyMarketing: value)),
            isLast: true,
          ),
        ]),
        const SizedBox(height: AppSpacing.lg),
        section(l10n.settingsReviewDisplay, Icons.tune_outlined, [
          SettingsFilterInputLabel(
            label: l10n.settingsRtiThreshold,
            description: l10n.settingsRtiThresholdDesc,
          ),
          Text('${data.rtiThreshold}', textAlign: TextAlign.end),
          Slider(
            value: data.rtiThreshold.toDouble().clamp(0, 100),
            min: 0,
            max: 100,
            divisions: 100,
            label: '${data.rtiThreshold}',
            onChanged: (value) =>
                onChanged(data.copyWith(rtiThreshold: value.round())),
          ),
          SettingsToggleRow(
            icon: Icons.visibility_off_outlined,
            label: l10n.settingsHideRisky,
            description: l10n.settingsHideRiskyDesc,
            value: data.hideRiskyReviews,
            onChanged: (value) =>
                onChanged(data.copyWith(hideRiskyReviews: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.label_outline,
            label: l10n.settingsSuspiciousLabel,
            description: l10n.settingsSuspiciousLabelDesc,
            value: data.showSuspiciousLabel,
            onChanged: (value) =>
                onChanged(data.copyWith(showSuspiciousLabel: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.verified_outlined,
            label: l10n.settingsVerifiedFirst,
            description: l10n.settingsVerifiedFirstDesc,
            value: data.prioritizeVerifiedReviews,
            onChanged: (value) =>
                onChanged(data.copyWith(prioritizeVerifiedReviews: value)),
            isLast: false,
          ),
          SettingsToggleRow(
            icon: Icons.open_in_new,
            label: l10n.settingsAutoAnalysis,
            description: l10n.settingsAutoAnalysisDesc,
            value: data.autoOpenAnalysisPopup,
            onChanged: (value) =>
                onChanged(data.copyWith(autoOpenAnalysisPopup: value)),
            isLast: true,
          ),
          SettingsSelect(
            label: l10n.settingsReviewSort,
            value: data.reviewSortOrder,
            options: {
              'VERIFIED_RECENT': l10n.settingsSortVerifiedRecent,
              'RECENT': l10n.settingsSortRecent,
              'HELPFUL': l10n.settingsSortHelpful,
            },
            onChanged: (value) =>
                onChanged(data.copyWith(reviewSortOrder: value)),
          ),
          SettingsSelect(
            label: l10n.settingsRtiLabel,
            value: data.rtiLabelStyle,
            options: {
              'BADGE_SMALL': l10n.settingsLabelSmall,
              'BADGE_LARGE': l10n.settingsLabelLarge,
              'NONE': l10n.settingsLabelNone,
            },
            onChanged: (value) =>
                onChanged(data.copyWith(rtiLabelStyle: value)),
          ),
          SettingsSelect(
            label: l10n.settingsCardDensity,
            value: data.cardDensity,
            options: {
              'COMFORTABLE': l10n.settingsDensityComfortable,
              'COMPACT': l10n.settingsDensityCompact,
            },
            onChanged: (value) => onChanged(data.copyWith(cardDensity: value)),
          ),
        ]),
        const SizedBox(height: AppSpacing.lg),
        section(l10n.settingsPrivacy, Icons.privacy_tip_outlined, [
          SettingsToggleRow(
            icon: Icons.privacy_tip_outlined,
            label: l10n.settingsDataAnalysis,
            description: l10n.settingsDataAnalysisDesc,
            value: data.allowDataAnalysis,
            onChanged: (value) =>
                onChanged(data.copyWith(allowDataAnalysis: value)),
            isLast: true,
          ),
        ]),
      ],
    );
  }
}

class SettingsSelect extends StatelessWidget {
  const SettingsSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('$label:$value'),
            initialValue: value,
            isExpanded: true,
            decoration: settingsInputDecoration(),
            items: [
              for (final entry in options.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value, overflow: TextOverflow.ellipsis),
                ),
              if (!options.containsKey(value))
                DropdownMenuItem(value: value, child: Text(value)),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class SettingsFailure extends StatelessWidget {
  const SettingsFailure({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => SettingsCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(message),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).actionRetry),
        ),
      ],
    ),
  );
}

InputDecoration settingsInputDecoration({String? suffixText}) {
  return InputDecoration(
    suffixText: suffixText,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: AppRadius.small,
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.small,
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.small,
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    filled: true,
    fillColor: AppColors.surface,
  );
}

class SettingsFilterInputLabel extends StatelessWidget {
  const SettingsFilterInputLabel({
    super.key,
    required this.label,
    required this.description,
  });
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Account panel (right column top)
// ─────────────────────────────────────────────────────────────

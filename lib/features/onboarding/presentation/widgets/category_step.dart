import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';

class CategoryStep extends StatelessWidget {
  const CategoryStep({
    super.key,
    required this.selectedCategories,
    required this.availableCategories,
    required this.minTrustScore,
    required this.onThresholdChanged,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
  });
  final Set<String> selectedCategories;
  final List<PreferenceCategory> availableCategories;
  final int minTrustScore;
  final ValueChanged<int> onThresholdChanged;
  final ValueChanged<String> onToggle;
  final VoidCallback? onNext;
  final VoidCallback onSkip;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        AppLocalizations.of(context).onboardingCategoryTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(AppLocalizations.of(context).onboardingCategoryDescription),
      const SizedBox(height: AppSpacing.lg),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final category in availableCategories)
            FilterChip(
              label: Text(category.displayName),
              selected: selectedCategories.contains(category.value),
              onSelected: (_) => onToggle(category.value),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Text(
        AppLocalizations.of(context).onboardingTrustThreshold(minTrustScore),
      ),
      Text(AppLocalizations.of(context).onboardingUnanalyzedNotice),
      Slider(
        value: minTrustScore.toDouble(),
        min: 0,
        max: 100,
        divisions: 100,
        label: '$minTrustScore',
        onChanged: (value) => onThresholdChanged(value.round()),
      ),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(AppLocalizations.of(context).onboardingSkipExisting),
          ),
          FilledButton(
            onPressed: onNext,
            child: Text(AppLocalizations.of(context).authNext),
          ),
        ],
      ),
    ],
  );
}

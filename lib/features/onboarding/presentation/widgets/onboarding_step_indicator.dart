import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';

class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepNode(
          step: 1,
          label: AppLocalizations.of(context).onboardingPreferredCategories,
          isActive: currentStep == 1,
          isDone: currentStep > 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Container(
              height: 2,
              color: currentStep > 1 ? AppColors.primary : AppColors.border,
            ),
          ),
        ),
        _StepNode(
          step: 2,
          label: AppLocalizations.of(context).settingsNotifications,
          isActive: currentStep == 2,
          isDone: false,
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.step,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  final int step;
  final String label;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepCircle(step: step, isActive: isActive, isDone: isDone),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isActive ? AppColors.primary : AppColors.textTertiary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.step,
    required this.isActive,
    required this.isDone,
  });

  final int step;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = isActive || isDone;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHighlighted ? AppColors.primary : Colors.transparent,
        border: isHighlighted
            ? null
            : Border.all(color: AppColors.borderStrong, width: 1.5),
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 18, color: AppColors.onPrimary)
            : Text(
                '$step',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? AppColors.onPrimary
                      : AppColors.textTertiary,
                ),
              ),
      ),
    );
  }
}

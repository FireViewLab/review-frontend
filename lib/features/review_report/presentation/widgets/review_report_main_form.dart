import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/agreement_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/ai_evidence_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/detail_input_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/reason_selector_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_step_indicator.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_target_card.dart';

class ReviewReportMainForm extends StatelessWidget {
  const ReviewReportMainForm({
    super.key,
    required this.productName,
    required this.reviewContent,
    required this.rtiScore,
    required this.rtiGrade,
    required this.selectedReasons,
    required this.detailController,
    required this.reportType,
    required this.disclosure,
    required this.includeAiEvidence,
    required this.agreePrivacy,
    required this.agreeNotFalse,
    required this.currentStep,
    required this.maxReachedStep,
    required this.onStepChanged,
    required this.onReasonToggled,
    required this.onReportTypeChanged,
    required this.onDisclosureChanged,
    required this.onIncludeAiChanged,
    required this.onAgreePrivacyChanged,
    required this.onAgreeNotFalseChanged,
    required this.attachments,
    required this.onAttachmentsChanged,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final String productName;
  final String reviewContent;
  final double rtiScore;
  final String rtiGrade;
  final Set<ReportReason> selectedReasons;
  final TextEditingController detailController;
  final String? reportType;
  final String? disclosure;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final ReportStep currentStep;
  final ReportStep maxReachedStep;
  final ValueChanged<ReportStep> onStepChanged;
  final ValueChanged<ReportReason> onReasonToggled;
  final ValueChanged<String?> onReportTypeChanged;
  final ValueChanged<String?> onDisclosureChanged;
  final ValueChanged<bool> onIncludeAiChanged;
  final ValueChanged<bool> onAgreePrivacyChanged;
  final ValueChanged<bool> onAgreeNotFalseChanged;
  final List<PlatformFile> attachments;
  final ValueChanged<List<PlatformFile>> onAttachmentsChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  bool get _detailReady => detailController.text.trim().length >= 20;
  bool get _agreed => agreePrivacy && agreeNotFalse;

  bool _canAdvanceFrom(ReportStep step) => switch (step) {
    ReportStep.target => true,
    ReportStep.reason => selectedReasons.isNotEmpty,
    ReportStep.detail => _detailReady,
    ReportStep.submit => _agreed && selectedReasons.isNotEmpty && _detailReady,
  };

  void _goNext() {
    final next = ReportStep.values[currentStep.index + 1];
    onStepChanged(next);
  }

  void _goPrev() {
    if (currentStep.index == 0) return;
    final prev = ReportStep.values[currentStep.index - 1];
    onStepChanged(prev);
  }

  Widget _stepContent() {
    switch (currentStep) {
      case ReportStep.target:
        return ReviewTargetCard(
          productName: productName,
          reviewContent: reviewContent,
          rtiScore: rtiScore,
          rtiGrade: rtiGrade,
        );
      case ReportStep.reason:
        return ReasonSelectorSection(
          selectedReasons: selectedReasons,
          onToggled: onReasonToggled,
        );
      case ReportStep.detail:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetailInputSection(
              controller: detailController,
              reportType: reportType,
              disclosure: disclosure,
              onReportTypeChanged: onReportTypeChanged,
              onDisclosureChanged: onDisclosureChanged,
              attachments: attachments,
              onAttachmentsChanged: onAttachmentsChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            AiEvidenceSection(
              checked: includeAiEvidence,
              onChanged: onIncludeAiChanged,
            ),
          ],
        );
      case ReportStep.submit:
        return AgreementSection(
          agreePrivacy: agreePrivacy,
          agreeNotFalse: agreeNotFalse,
          onPrivacyChanged: onAgreePrivacyChanged,
          onNotFalseChanged: onAgreeNotFalseChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAdvance = _canAdvanceFrom(currentStep);
    final isLastStep = currentStep == ReportStep.submit;
    final isFirstStep = currentStep == ReportStep.target;
    final stepContent = KeyedSubtree(
      key: ValueKey(currentStep),
      child: _stepContent(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewReportStepIndicator(
          currentStep: currentStep,
          maxReachedStep: maxReachedStep,
          onStepTapped: onStepChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (MediaQuery.disableAnimationsOf(context))
          stepContent
        else
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.slow),
            curve: AppMotion.enter,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: AppMotion.of(context, AppMotion.slow),
              switchInCurve: AppMotion.enter,
              switchOutCurve: AppMotion.exit,
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnim, child: child),
                );
              },
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [...previousChildren, ?currentChild],
                );
              },
              child: stepContent,
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _StepNavigationBar(
          isFirstStep: isFirstStep,
          isLastStep: isLastStep,
          canAdvance: canAdvance,
          isSubmitting: isSubmitting,
          onPrev: _goPrev,
          onNext: _goNext,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}

class _StepNavigationBar extends StatelessWidget {
  const _StepNavigationBar({
    required this.isFirstStep,
    required this.isLastStep,
    required this.canAdvance,
    required this.isSubmitting,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
  });

  final bool isFirstStep;
  final bool isLastStep;
  final bool canAdvance;
  final bool isSubmitting;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isFirstStep)
          OutlinedButton.icon(
            onPressed: isSubmitting ? null : onPrev,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text(
              '이전',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
        else
          const SizedBox.shrink(),
        FilledButton(
          onPressed: isSubmitting
              ? null
              : isLastStep
              ? (canAdvance ? onSubmit : null)
              : (canAdvance ? onNext : null),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textTertiary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isSubmitting
              ? SizedBox.square(
                  dimension: 18,
                  child: TickerMode(
                    enabled: !MediaQuery.disableAnimationsOf(context),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLastStep ? '신고 접수하기' : '다음',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (!isLastStep) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

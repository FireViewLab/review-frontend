import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset/password_reset_form_fields.dart';

class PasswordResetEmailStep extends StatelessWidget {
  const PasswordResetEmailStep({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSendCode,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback? onSendCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasswordResetFieldLabel(
          label: AppLocalizations.of(context).authRegisteredEmail,
        ),
        const SizedBox(height: AppSpacing.xs),
        PasswordResetInputField(
          controller: controller,
          hintText: 'review@example.com',
          prefixIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSendCode?.call(),
        ),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetPrimaryButton(
          label: AppLocalizations.of(context).authSendVerification,
          isLoading: isLoading,
          onPressed: onSendCode,
        ),
      ],
    );
  }
}

class PasswordResetEmailSentStep extends StatelessWidget {
  const PasswordResetEmailSentStep({
    super.key,
    required this.email,
    required this.isLoading,
    required this.onProceed,
    required this.onResendCode,
  });

  final String email;
  final bool isLoading;
  final VoidCallback? onProceed;
  final VoidCallback onResendCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.successSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA7D7A9)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.success,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).authEmailSent,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocalizations.of(context).authEmailSentGuide,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetPrimaryButton(
          label: AppLocalizations.of(context).authNext,
          isLoading: isLoading,
          onPressed: onProceed,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: isLoading ? null : onResendCode,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(AppLocalizations.of(context).authResendEmail),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ResendHelp(),
      ],
    );
  }
}

class PasswordResetNewPasswordStep extends StatelessWidget {
  const PasswordResetNewPasswordStep({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.state,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onResetPassword,
    required this.onResendCode,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final PasswordResetState state;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback? onResetPassword;
  final VoidCallback onResendCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasswordResetFieldLabel(
          label: AppLocalizations.of(context).authNewPassword,
        ),
        const SizedBox(height: AppSpacing.xs),
        PasswordResetInputField(
          controller: newPasswordController,
          hintText: AppLocalizations.of(context).authNewPasswordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: obscureNewPassword,
          textInputAction: TextInputAction.next,
          trailing: IconButton(
            onPressed: onToggleNewPasswordVisibility,
            icon: Icon(
              obscureNewPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).authNewPasswordGuide,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetFieldLabel(
          label: AppLocalizations.of(context).authConfirmNewPassword,
        ),
        const SizedBox(height: AppSpacing.xs),
        PasswordResetInputField(
          controller: confirmPasswordController,
          hintText: AppLocalizations.of(context).authConfirmNewPasswordHint,
          prefixIcon: Icons.check_outlined,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onResetPassword?.call(),
          trailing: IconButton(
            onPressed: onToggleConfirmPasswordVisibility,
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _PasswordRequirements(state: state),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetPrimaryButton(
          label: AppLocalizations.of(context).authCompleteReset,
          isLoading: state.isLoading,
          onPressed: onResetPassword,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: state.isLoading ? null : onResendCode,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(AppLocalizations.of(context).authResendVerification),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ResendHelp(),
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements({required this.state});

  final PasswordResetState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequirementRow(
          label: AppLocalizations.of(context).authMinLength,
          isMet: state.hasMinLength,
          hasInput: state.newPassword.isNotEmpty,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _RequirementRow(
          label: AppLocalizations.of(context).authLettersNumbers,
          isMet: state.hasLetterAndNumber,
          hasInput: state.newPassword.isNotEmpty,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _RequirementRow(
          label: AppLocalizations.of(context).authSymbolsRecommended,
          isMet: state.hasSpecialChar,
          hasInput: state.newPassword.isNotEmpty,
          isOptional: true,
        ),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({
    required this.label,
    required this.isMet,
    required this.hasInput,
    this.isOptional = false,
  });

  final String label;
  final bool isMet;
  final bool hasInput;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final color = !hasInput
        ? AppColors.textTertiary
        : isMet
        ? AppColors.success
        : (isOptional ? AppColors.textTertiary : AppColors.error);

    return Row(
      children: [
        Icon(Icons.check, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ResendHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).authNoEmail,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    AppLocalizations.of(context).authNoEmailGuide,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
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

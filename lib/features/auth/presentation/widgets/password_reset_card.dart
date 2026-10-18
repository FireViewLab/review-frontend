import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset/password_reset_step_indicator.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset/password_reset_steps.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset/password_reset_form_fields.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset/password_reset_success_view.dart';

class PasswordResetCard extends StatelessWidget {
  const PasswordResetCard({
    required this.state,
    required this.emailController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onSendCode,
    required this.onProceed,
    required this.onResetPassword,
    required this.onResendCode,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onLoginPressed,
    super.key,
  });

  final PasswordResetState state;
  final TextEditingController emailController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback? onSendCode;
  final VoidCallback? onProceed;
  final VoidCallback? onResetPassword;
  final VoidCallback onResendCode;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 42,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 34),
          child: state.isSuccess
              ? PasswordResetSuccessView(onLoginPressed: onLoginPressed)
              : _FormView(
                  state: state,
                  emailController: emailController,
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confirmPasswordController,
                  obscureNewPassword: obscureNewPassword,
                  obscureConfirmPassword: obscureConfirmPassword,
                  onSendCode: onSendCode,
                  onProceed: onProceed,
                  onResetPassword: onResetPassword,
                  onResendCode: onResendCode,
                  onToggleNewPasswordVisibility: onToggleNewPasswordVisibility,
                  onToggleConfirmPasswordVisibility:
                      onToggleConfirmPasswordVisibility,
                  onLoginPressed: onLoginPressed,
                ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.state,
    required this.emailController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onSendCode,
    required this.onProceed,
    required this.onResetPassword,
    required this.onResendCode,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onLoginPressed,
  });

  final PasswordResetState state;
  final TextEditingController emailController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback? onSendCode;
  final VoidCallback? onProceed;
  final VoidCallback? onResetPassword;
  final VoidCallback onResendCode;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Reset password',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).authResetTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppLocalizations.of(context).authResetDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PasswordResetStepIndicator(currentStep: state.step),
        const SizedBox(height: AppSpacing.xl),
        if (state.step == PasswordResetStep.email)
          PasswordResetEmailStep(
            controller: emailController,
            isLoading: state.isLoading,
            onSendCode: onSendCode,
          )
        else if (state.step == PasswordResetStep.emailSent)
          PasswordResetEmailSentStep(
            email: state.email,
            isLoading: state.isLoading,
            onProceed: state.resetToken?.isNotEmpty == true ? onProceed : null,
            onResendCode: onResendCode,
          )
        else
          PasswordResetNewPasswordStep(
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
            state: state,
            obscureNewPassword: obscureNewPassword,
            obscureConfirmPassword: obscureConfirmPassword,
            onToggleNewPasswordVisibility: onToggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility:
                onToggleConfirmPasswordVisibility,
            onResetPassword: onResetPassword,
            onResendCode: onResendCode,
          ),
        if (state.failureMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          PasswordResetErrorMessage(message: state.failureMessage!),
        ],
        const SizedBox(height: AppSpacing.xl),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).authRememberAccount,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: onLoginPressed,
              child: Text(AppLocalizations.of(context).authBackToLogin),
            ),
          ],
        ),
      ],
    );
  }
}

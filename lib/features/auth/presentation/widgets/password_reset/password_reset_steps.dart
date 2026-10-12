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
        PasswordResetFieldLabel(label: '가입 이메일'),
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
          label: '인증 이메일 발송',
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
                        '이메일을 발송했습니다',
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
          '이메일의 링크를 클릭하거나, 받은 토큰을 확인한 후 다음 단계로 진행하세요.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetPrimaryButton(
          label: '다음',
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
          child: const Text('이메일 다시 받기'),
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
        PasswordResetFieldLabel(label: '새 비밀번호'),
        const SizedBox(height: AppSpacing.xs),
        PasswordResetInputField(
          controller: newPasswordController,
          hintText: '새 비밀번호를 입력하세요',
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
          '이전에 사용한 비밀번호와 다르게 설정하고, 영문·숫자·특수문자를 조합해 주세요.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PasswordResetFieldLabel(label: '새 비밀번호 확인'),
        const SizedBox(height: AppSpacing.xs),
        PasswordResetInputField(
          controller: confirmPasswordController,
          hintText: '새 비밀번호를 한 번 더 입력하세요',
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
          label: '비밀번호 변경 완료',
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
          child: const Text('인증 이메일 다시 받기'),
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
          label: '8자 이상',
          isMet: state.hasMinLength,
          hasInput: state.newPassword.isNotEmpty,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _RequirementRow(
          label: '영문과 숫자 포함',
          isMet: state.hasLetterAndNumber,
          hasInput: state.newPassword.isNotEmpty,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _RequirementRow(
          label: '특수문자 포함 권장',
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
                    '이메일을 받지 못했나요?',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '스팸함을 확인하거나, 가입한 이메일이 맞는지 다시 확인해 주세요.',
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

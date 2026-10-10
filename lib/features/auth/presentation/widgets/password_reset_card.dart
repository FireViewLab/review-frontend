import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

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
              color: Color(0x1A0F172A),
              blurRadius: 42,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 34),
          child: state.isSuccess
              ? _SuccessView(onLoginPressed: onLoginPressed)
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
          '비밀번호 재설정',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '가입한 이메일을 확인하고 새 비밀번호를 등록하세요.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _StepIndicator(currentStep: state.step),
        const SizedBox(height: AppSpacing.xl),
        if (state.step == PasswordResetStep.email)
          _EmailStep(
            controller: emailController,
            isLoading: state.isLoading,
            onSendCode: onSendCode,
          )
        else if (state.step == PasswordResetStep.emailSent)
          _EmailSentStep(
            email: state.email,
            isLoading: state.isLoading,
            onProceed: state.resetToken?.isNotEmpty == true ? onProceed : null,
            onResendCode: onResendCode,
          )
        else
          _NewPasswordStep(
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
          _ErrorMessage(message: state.failureMessage!),
        ],
        const SizedBox(height: AppSpacing.xl),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '계정이 기억났나요?',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: onLoginPressed,
              child: const Text('로그인으로 돌아가기'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final PasswordResetStep currentStep;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (PasswordResetStep.email, '이메일 확인'),
      (PasswordResetStep.emailSent, '인증 코드'),
      (PasswordResetStep.newPassword, '새 비밀번호'),
    ];
    final currentIndex = PasswordResetStep.values.indexOf(currentStep);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 20),
              color: currentIndex > i ~/ 2
                  ? AppColors.primary
                  : AppColors.border,
            ),
          );
        }
        final idx = i ~/ 2;
        final isActive = currentIndex == idx;
        final isDone = currentIndex > idx;
        final bgColor = (isActive || isDone)
            ? AppColors.primary
            : AppColors.border;
        final fgColor = (isActive || isDone)
            ? Colors.white
            : AppColors.textSecondary;
        final labelColor = (isActive || isDone)
            ? AppColors.primary
            : AppColors.textSecondary;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isDone
                  ? Icon(Icons.check, size: 16, color: fgColor)
                  : Text(
                      '${idx + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: fgColor,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              steps[idx].$2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: labelColor,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _EmailStep extends StatelessWidget {
  const _EmailStep({
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
        _FieldLabel(label: '가입 이메일'),
        const SizedBox(height: AppSpacing.xs),
        _InputField(
          controller: controller,
          hintText: 'review@example.com',
          prefixIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSendCode?.call(),
        ),
        const SizedBox(height: AppSpacing.lg),
        _PrimaryButton(
          label: '인증 이메일 발송',
          isLoading: isLoading,
          onPressed: onSendCode,
        ),
      ],
    );
  }
}

class _EmailSentStep extends StatelessWidget {
  const _EmailSentStep({
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
        _PrimaryButton(label: '다음', isLoading: isLoading, onPressed: onProceed),
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

class _NewPasswordStep extends StatelessWidget {
  const _NewPasswordStep({
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
        _FieldLabel(label: '새 비밀번호'),
        const SizedBox(height: AppSpacing.xs),
        _InputField(
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
        _FieldLabel(label: '새 비밀번호 확인'),
        const SizedBox(height: AppSpacing.xs),
        _InputField(
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
        _PrimaryButton(
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.trailing,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? trailing;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: trailing,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF7C6C6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onLoginPressed});

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 32,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '비밀번호가 변경되었습니다',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '새 비밀번호로 로그인해 주세요.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 58,
          child: FilledButton(
            onPressed: onLoginPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('로그인하러 가기'),
          ),
        ),
      ],
    );
  }
}

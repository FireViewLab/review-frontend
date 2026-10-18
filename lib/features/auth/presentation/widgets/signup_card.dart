import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class SignupCard extends StatefulWidget {
  const SignupCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.obscurePassword,
    required this.obscurePasswordConfirm,
    required this.agreedToTerms,
    required this.agreedToMarketing,
    required this.nameError,
    required this.emailError,
    required this.passwordError,
    required this.passwordConfirmError,
    required this.termsError,
    required this.failureMessage,
    required this.isLoading,
    required this.onPasswordVisibilityPressed,
    required this.onPasswordConfirmVisibilityPressed,
    required this.onTermsChanged,
    required this.onMarketingChanged,
    required this.onSignupPressed,
    required this.onOAuthPressed,
    required this.onLoginPressed,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool obscurePassword;
  final bool obscurePasswordConfirm;
  final bool agreedToTerms;
  final bool agreedToMarketing;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? passwordConfirmError;
  final String? termsError;
  final String? failureMessage;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityPressed;
  final VoidCallback onPasswordConfirmVisibilityPressed;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onMarketingChanged;
  final VoidCallback? onSignupPressed;
  final ValueChanged<OAuthProvider>? onOAuthPressed;
  final VoidCallback onLoginPressed;

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

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
          padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppLocalizations.of(context).authSignup,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppLocalizations.of(context).authSignupDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SignupInputField(
                controller: widget.nameController,
                label: AppLocalizations.of(context).authName,
                hintText: AppLocalizations.of(context).authNameHint,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                errorText: widget.nameError,
                onSubmitted: () => _emailFocusNode.requestFocus(),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SignupInputField(
                controller: widget.emailController,
                label: AppLocalizations.of(context).authEmail,
                hintText: AppLocalizations.of(context).authEmailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.mail_outline,
                errorText: widget.emailError,
                focusNode: _emailFocusNode,
                onSubmitted: () => _passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SignupInputField(
                controller: widget.passwordController,
                label: AppLocalizations.of(context).authPassword,
                hintText: AppLocalizations.of(context).authPasswordHint,
                obscureText: widget.obscurePassword,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.lock_outline,
                errorText: widget.passwordError,
                helperText: AppLocalizations.of(context).authPasswordGuidance,
                focusNode: _passwordFocusNode,
                onSubmitted: () => _passwordConfirmFocusNode.requestFocus(),
                trailing: TextButton(
                  onPressed: widget.isLoading
                      ? null
                      : widget.onPasswordVisibilityPressed,
                  child: Text(
                    widget.obscurePassword
                        ? AppLocalizations.of(context).authShow
                        : AppLocalizations.of(context).authHide,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SignupInputField(
                controller: widget.passwordConfirmController,
                label: AppLocalizations.of(context).authConfirmPassword,
                hintText: AppLocalizations.of(context).authConfirmPasswordHint,
                obscureText: widget.obscurePasswordConfirm,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.check,
                errorText: widget.passwordConfirmError,
                focusNode: _passwordConfirmFocusNode,
                onSubmitted: widget.isLoading ? null : widget.onSignupPressed,
                trailing: TextButton(
                  onPressed: widget.isLoading
                      ? null
                      : widget.onPasswordConfirmVisibilityPressed,
                  child: Text(
                    widget.obscurePasswordConfirm
                        ? AppLocalizations.of(context).authShow
                        : AppLocalizations.of(context).authHide,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _AgreementBox(
                agreedToTerms: widget.agreedToTerms,
                agreedToMarketing: widget.agreedToMarketing,
                termsError: widget.termsError,
                isLoading: widget.isLoading,
                onTermsChanged: widget.onTermsChanged,
                onMarketingChanged: widget.onMarketingChanged,
              ),
              if (widget.failureMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _SignupFailureMessage(message: widget.failureMessage!),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: widget.isLoading ? null : widget.onSignupPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.large,
                    ),
                  ),
                  child: widget.isLoading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Text(AppLocalizations.of(context).authSignupOnboarding),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const _NextStepNotice(),
              const SizedBox(height: AppSpacing.md),
              _DividerLabel(label: AppLocalizations.of(context).authOr),
              const SizedBox(height: AppSpacing.md),
              _SocialSignupButton(
                label: AppLocalizations.of(context).authSignupNaver,
                mark: 'N',
                onPressed: widget.isLoading || widget.onOAuthPressed == null
                    ? null
                    : () => widget.onOAuthPressed!(OAuthProvider.naver),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SocialSignupButton(
                label: AppLocalizations.of(context).authSignupGoogle,
                mark: 'G',
                onPressed: widget.isLoading || widget.onOAuthPressed == null
                    ? null
                    : () => widget.onOAuthPressed!(OAuthProvider.google),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).authHasAccount,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onLoginPressed,
                    child: Text(AppLocalizations.of(context).authLoginAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupInputField extends StatelessWidget {
  const _SignupInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.errorText,
    this.helperText,
    this.trailing,
    this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? errorText;
  final String? helperText;
  final Widget? trailing;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 56,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
              prefixIcon: Icon(prefixIcon),
              suffixIcon: trailing,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.large,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.large,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.large,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}

class _AgreementBox extends StatelessWidget {
  const _AgreementBox({
    required this.agreedToTerms,
    required this.agreedToMarketing,
    required this.termsError,
    required this.isLoading,
    required this.onTermsChanged,
    required this.onMarketingChanged,
  });

  final bool agreedToTerms;
  final bool agreedToMarketing;
  final String? termsError;
  final bool isLoading;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onMarketingChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          children: [
            CheckboxListTile(
              value: agreedToTerms,
              onChanged: isLoading
                  ? null
                  : (value) => onTermsChanged(value ?? false),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                AppLocalizations.of(context).authTermsConsent,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            CheckboxListTile(
              value: agreedToMarketing,
              onChanged: isLoading
                  ? null
                  : (value) => onMarketingChanged(value ?? false),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                AppLocalizations.of(context).authMarketingConsent,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (termsError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    termsError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SignupFailureMessage extends StatelessWidget {
  const _SignupFailureMessage({required this.message});

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

class _NextStepNotice extends StatelessWidget {
  const _NextStepNotice();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppRadius.large,
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
              child: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppLocalizations.of(context).authOnboardingNotice,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
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

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialSignupButton extends StatelessWidget {
  const _SocialSignupButton({
    required this.label,
    required this.mark,
    required this.onPressed,
  });

  final String label;
  final String mark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.small,
            ),
            child: Text(
              mark,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      ),
    );
  }
}

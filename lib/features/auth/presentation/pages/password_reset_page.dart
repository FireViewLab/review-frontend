import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/shared/widgets/app_fade_in.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/password_reset_value_panel.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({this.resetToken, super.key});

  final String? resetToken;

  @override
  ConsumerState<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _newPasswordController.addListener(_onNewPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void didUpdateWidget(covariant PasswordResetPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetToken != widget.resetToken) {
      _emailController.removeListener(_onEmailChanged);
      _newPasswordController.removeListener(_onNewPasswordChanged);
      _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
      _emailController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _emailController.addListener(_onEmailChanged);
      _newPasswordController.addListener(_onNewPasswordChanged);
      _confirmPasswordController.addListener(_onConfirmPasswordChanged);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _newPasswordController.removeListener(_onNewPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    ref
        .read(passwordResetViewModelProvider(widget.resetToken).notifier)
        .emailChanged(_emailController.text);
  }

  void _onNewPasswordChanged() {
    ref
        .read(passwordResetViewModelProvider(widget.resetToken).notifier)
        .newPasswordChanged(_newPasswordController.text);
  }

  void _onConfirmPasswordChanged() {
    ref
        .read(passwordResetViewModelProvider(widget.resetToken).notifier)
        .confirmPasswordChanged(_confirmPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetViewModelProvider(widget.resetToken));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AppContentView(
                maxWidth: 1360,
                padding: _pagePadding(context),
                child: context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AppFadeIn(
                            delay: 0,
                            child: PasswordResetValuePanel(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AppFadeIn(delay: 90, child: _buildCard(state)),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: AppFadeIn(
                              delay: 0,
                              child: PasswordResetValuePanel(),
                            ),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AppFadeIn(
                                delay: 120,
                                child: _buildCard(state),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const AppFadeIn(delay: 220, child: LoginFooter()),
        ],
      ),
    );
  }

  PasswordResetCard _buildCard(PasswordResetState state) {
    return PasswordResetCard(
      state: state,
      emailController: _emailController,
      newPasswordController: _newPasswordController,
      confirmPasswordController: _confirmPasswordController,
      obscureNewPassword: _obscureNewPassword,
      obscureConfirmPassword: _obscureConfirmPassword,
      onSendCode: state.isLoading
          ? null
          : () => ref
                .read(
                  passwordResetViewModelProvider(widget.resetToken).notifier,
                )
                .sendVerificationCode(),
      onProceed: state.isLoading
          ? null
          : () => ref
                .read(
                  passwordResetViewModelProvider(widget.resetToken).notifier,
                )
                .proceedToNewPassword(),
      onResetPassword: state.isLoading
          ? null
          : () => ref
                .read(
                  passwordResetViewModelProvider(widget.resetToken).notifier,
                )
                .resetPassword(),
      onResendCode: () => ref
          .read(passwordResetViewModelProvider(widget.resetToken).notifier)
          .resendCode(),
      onToggleNewPasswordVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      onToggleConfirmPasswordVisibility: () =>
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
      onLoginPressed: () => context.go(RoutePaths.login),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    if (context.isMobile) return const EdgeInsets.fromLTRB(16, 28, 16, 48);
    if (context.isTablet) return const EdgeInsets.fromLTRB(24, 48, 24, 64);
    return const EdgeInsets.fromLTRB(32, 56, 32, 48);
  }
}

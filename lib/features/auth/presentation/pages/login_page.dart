import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/shared/widgets/app_fade_in.dart';
import 'package:re_view_front/core/platform/external_redirect.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_value_panel.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.from});

  /// 로그인 후 돌아갈 앱 내부 경로. 로그인이 필요한 화면에서 넘어왔을 때만 있다.
  final String? from;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_handlePasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_handleEmailChanged);
    _passwordController.removeListener(_handlePasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.status == LoginSubmissionStatus.success) {
        final from = widget.from;
        // 외부 주소로 보내지 않도록 앱 내부 경로만 허용한다.
        final canReturn =
            from != null &&
            from.startsWith('/') &&
            !from.startsWith('//') &&
            !from.startsWith(RoutePaths.login);
        context.go(
          !next.onboardingCompleted
              ? RoutePaths.onboarding
              : canReturn
              ? from
              : RoutePaths.home,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      // AppShell already resizes the nested route for the keyboard.
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AppContentView(
                maxWidth: 1360,
                padding: _pagePadding(context),
                child: !context.isDesktop
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppFadeIn(
                            delay: 0,
                            child: LoginValuePanel(compact: context.isMobile),
                          ),
                          SizedBox(
                            height: context.isMobile
                                ? AppSpacing.md
                                : AppSpacing.xl,
                          ),
                          AppFadeIn(
                            delay: 90,
                            child: _buildLoginCard(context, loginState),
                          ),
                          if (context.isMobile) const LoginFooter(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: AppFadeIn(
                              delay: 0,
                              child: LoginValuePanel(),
                            ),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AppFadeIn(
                                delay: 120,
                                child: _buildLoginCard(context, loginState),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (!context.isMobile)
            const AppFadeIn(delay: 220, child: LoginFooter()),
        ],
      ),
    );
  }

  LoginCard _buildLoginCard(BuildContext context, LoginState loginState) {
    return LoginCard(
      emailController: _emailController,
      passwordController: _passwordController,
      rememberMe: loginState.rememberMe,
      obscurePassword: _obscurePassword,
      emailError: loginState.emailError,
      passwordError: loginState.passwordError,
      failureMessage: loginState.failureMessage,
      isLoading: loginState.isLoading,
      onRememberChanged: (value) {
        ref.read(loginViewModelProvider.notifier).rememberMeChanged(value);
      },
      onPasswordVisibilityPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      onLoginPressed: loginState.isLoading ? null : _handleLoginPressed,
      onOAuthPressed: loginState.isLoading ? null : _handleOAuthPressed,
      onSignupPressed: () => context.go(RoutePaths.signup),
      onForgotPasswordPressed: () => context.go(RoutePaths.passwordReset),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    if (context.isMobile) {
      return const EdgeInsets.fromLTRB(16, 16, 16, 24);
    }

    if (context.isTablet) {
      return const EdgeInsets.fromLTRB(24, 48, 24, 64);
    }

    return const EdgeInsets.fromLTRB(32, 56, 32, 48);
  }

  void _handleEmailChanged() {
    ref
        .read(loginViewModelProvider.notifier)
        .emailChanged(_emailController.text);
  }

  void _handlePasswordChanged() {
    ref
        .read(loginViewModelProvider.notifier)
        .passwordChanged(_passwordController.text);
  }

  void _handleLoginPressed() {
    ref.read(loginViewModelProvider.notifier).submit();
  }

  Future<void> _handleOAuthPressed(OAuthProvider provider) async {
    final uri = await ref
        .read(loginViewModelProvider.notifier)
        .startOAuth(provider);
    if (uri == null) {
      return;
    }

    redirectToExternalUrl(uri);
  }
}

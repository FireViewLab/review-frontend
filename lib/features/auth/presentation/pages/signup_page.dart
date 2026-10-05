import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/shared/widgets/app_fade_in.dart';
import 'package:re_view_front/core/platform/external_redirect.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/auth/domain/entities/oauth_provider.dart';
import 'package:re_view_front/features/auth/presentation/widgets/login_footer.dart';
import 'package:re_view_front/features/auth/presentation/widgets/signup_card.dart';
import 'package:re_view_front/features/auth/presentation/widgets/signup_value_panel.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_state.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _emailController.removeListener(_handleEmailChanged);
    _passwordController.removeListener(_handlePasswordChanged);
    _passwordConfirmController.removeListener(_handlePasswordConfirmChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_handlePasswordChanged);
    _passwordConfirmController.addListener(_handlePasswordConfirmChanged);
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupViewModelProvider);

    ref.listen<SignupState>(signupViewModelProvider, (previous, next) {
      if (next.status == SignupSubmissionStatus.success) {
        context.go(RoutePaths.onboarding);
      } else if (next.status == SignupSubmissionStatus.autoLoginFailure) {
        context.go(RoutePaths.login);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            navItems: homeNavItems,
            selectedNavItem: '홈',
            onLoginPressed: () => context.go(RoutePaths.login),
            onWishPressed: () => context.go(RoutePaths.home),
            onCartPressed: () => context.go(RoutePaths.home),
            onNavItemPressed: (item) => openHomeNavItem(context, item),
            onLogoPressed: () => context.go(RoutePaths.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AppContentView(
                maxWidth: 1360,
                padding: _pagePadding(context),
                child: context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AppFadeIn(delay: 0, child: SignupValuePanel()),
                          const SizedBox(height: AppSpacing.xl),
                          AppFadeIn(
                            delay: 90,
                            child: _buildSignupCard(signupState),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 12,
                            child: AppFadeIn(delay: 0, child: SignupValuePanel()),
                          ),
                          const SizedBox(width: 64),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AppFadeIn(
                                delay: 120,
                                child: _buildSignupCard(signupState),
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

  SignupCard _buildSignupCard(SignupState signupState) {
    return SignupCard(
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      passwordConfirmController: _passwordConfirmController,
      obscurePassword: _obscurePassword,
      obscurePasswordConfirm: _obscurePasswordConfirm,
      agreedToTerms: signupState.agreedToTerms,
      agreedToMarketing: signupState.agreedToMarketing,
      nameError: signupState.nameError,
      emailError: signupState.emailError,
      passwordError: signupState.passwordError,
      passwordConfirmError: signupState.passwordConfirmError,
      termsError: signupState.termsError,
      failureMessage: signupState.failureMessage,
      isLoading: signupState.isLoading,
      onPasswordVisibilityPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      onPasswordConfirmVisibilityPressed: () {
        setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm);
      },
      onTermsChanged: (value) {
        ref.read(signupViewModelProvider.notifier).termsChanged(value);
      },
      onMarketingChanged: (value) {
        ref.read(signupViewModelProvider.notifier).marketingChanged(value);
      },
      onSignupPressed: _handleSignupPressed,
      onOAuthPressed: signupState.isLoading ? null : _handleOAuthPressed,
      onLoginPressed: () => context.go(RoutePaths.login),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    if (context.isMobile) {
      return const EdgeInsets.fromLTRB(16, 28, 16, 48);
    }

    if (context.isTablet) {
      return const EdgeInsets.fromLTRB(24, 48, 24, 64);
    }

    return const EdgeInsets.fromLTRB(32, 56, 32, 48);
  }

  void _handleNameChanged() {
    ref
        .read(signupViewModelProvider.notifier)
        .nameChanged(_nameController.text);
  }

  void _handleEmailChanged() {
    ref
        .read(signupViewModelProvider.notifier)
        .emailChanged(_emailController.text);
  }

  void _handlePasswordChanged() {
    ref
        .read(signupViewModelProvider.notifier)
        .passwordChanged(_passwordController.text);
  }

  void _handlePasswordConfirmChanged() {
    ref
        .read(signupViewModelProvider.notifier)
        .passwordConfirmChanged(_passwordConfirmController.text);
  }

  void _handleSignupPressed() {
    ref.read(signupViewModelProvider.notifier).submit();
  }

  Future<void> _handleOAuthPressed(OAuthProvider provider) async {
    final uri = await ref
        .read(signupViewModelProvider.notifier)
        .startOAuth(provider);
    if (uri == null) {
      return;
    }

    redirectToExternalUrl(uri);
  }
}


import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/oauth_callback_state.dart';

class OAuthCallbackPage extends ConsumerStatefulWidget {
  const OAuthCallbackPage({super.key, required this.queryParams});

  final Map<String, String> queryParams;

  @override
  ConsumerState<OAuthCallbackPage> createState() => _OAuthCallbackPageState();
}

class _OAuthCallbackPageState extends ConsumerState<OAuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(oauthCallbackViewModelProvider.notifier)
          .processCallback(widget.queryParams);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(oauthCallbackViewModelProvider, (_, next) {
      if (next.status == OAuthCallbackStatus.success) {
        context.go(
          next.onboardingCompleted ? RoutePaths.home : RoutePaths.onboarding,
        );
      }
    });

    final state = ref.watch(oauthCallbackViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: switch (state.status) {
          OAuthCallbackStatus.processing => const CircularProgressIndicator(),
          OAuthCallbackStatus.success => const SizedBox.shrink(),
          OAuthCallbackStatus.failure => _OAuthErrorView(
            message:
                state.errorMessage ??
                AppLocalizations.of(context).authOAuthLoginFailed,
            onBack: () => context.go(RoutePaths.login),
          ),
        },
      ),
    );
  }
}

class _OAuthErrorView extends StatelessWidget {
  const _OAuthErrorView({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
        const SizedBox(height: 16),
        Text(message, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        TextButton(
          onPressed: onBack,
          child: Text(AppLocalizations.of(context).authBackToLogin),
        ),
      ],
    );
  }
}

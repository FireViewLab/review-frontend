import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/failure_messages.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/widgets/app_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    this.message,
    this.failure,
    this.title,
    this.onRetry,
    this.retryLabel,
    this.centered = true,
    super.key,
  }) : assert(message != null || failure != null);

  final Failure? failure;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final problem = failure;
    final icon = switch (problem?.kind) {
      FailureKind.offline => Icons.wifi_off_rounded,
      FailureKind.timeout => Icons.timer_outlined,
      FailureKind.unauthorized => Icons.lock_outline_rounded,
      FailureKind.forbidden => Icons.block_rounded,
      FailureKind.notFound => Icons.search_off_rounded,
      FailureKind.rateLimited => Icons.hourglass_top_rounded,
      FailureKind.server => Icons.dns_outlined,
      FailureKind.cancelled => Icons.cancel_outlined,
      _ => Icons.error_outline,
    };
    return _StatusView(
      title:
          title ??
          (problem == null ? '문제가 발생했어요' : failureTitle(context, problem)),
      message: problem == null ? message! : failureMessage(context, problem),
      icon: icon,
      iconColor: AppColors.error,
      action: onRetry == null
          ? null
          : AppButton(
              label:
                  retryLabel ??
                  (problem == null
                      ? '다시 시도'
                      : AppLocalizations.of(context).failureRetry),
              onPressed: onRetry,
            ),
      centered: centered,
    );
  }
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.title = '아직 표시할 내용이 없어요',
    this.action,
    this.centered = true,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return _StatusView(
      title: title,
      message: message,
      icon: Icons.inbox_outlined,
      iconColor: AppColors.textTertiary,
      action: action,
      centered: centered,
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.centered,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final bool centered;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );

    if (!centered) {
      return content;
    }

    return Center(child: content);
  }
}

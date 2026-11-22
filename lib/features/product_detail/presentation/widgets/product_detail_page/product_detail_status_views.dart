import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class ProductDetailLoadingView extends StatelessWidget {
  const ProductDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class ProductDetailErrorView extends StatelessWidget {
  const ProductDetailErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.failure,
  });

  final Failure? failure;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (failure != null) {
      return SizedBox(
        height: 400,
        child: AppErrorView(failure: failure, onRetry: onRetry),
      );
    }
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}

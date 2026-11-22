import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.isMobile ? AppSpacing.md : AppSpacing.xl,
        AppSpacing.md,
        context.isMobile ? AppSpacing.md : AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: AppContentView(
        maxWidth: 1280,
        padding: EdgeInsets.zero,
        child: !context.isDesktop
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _FooterCopyright(),
                  SizedBox(height: AppSpacing.sm),
                  _FooterLinks(),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_FooterCopyright(), _FooterLinks()],
              ),
      ),
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  const _FooterCopyright();

  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2026 Re:view. Korean commerce review trust analysis service.',
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: AppColors.textTertiary),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      children: [
        for (final link in [
          AppLocalizations.of(context).homeFooterTerms,
          AppLocalizations.of(context).homeFooterPrivacy,
          AppLocalizations.of(context).authFooterContact,
        ])
          Text(
            link,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

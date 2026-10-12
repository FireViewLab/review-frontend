import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class SettingsPageTitle extends StatelessWidget {
  const SettingsPageTitle({super.key, required this.profile});
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SettingsBreadcrumb(
              label: AppLocalizations.of(context).navHome,
              onTap: () => context.go(RoutePaths.home),
            ),
            const SettingsBreadcrumbSep(),
            SettingsBreadcrumb(
              label: AppLocalizations.of(context).navMyPage,
              onTap: () => context.go(RoutePaths.myPage),
            ),
            const SettingsBreadcrumbSep(),
            Text(
              AppLocalizations.of(context).navSettings,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              AppLocalizations.of(context).navSettings,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                profile != null
                    ? AppLocalizations.of(
                        context,
                      ).settingsSubtitleNamed(profile!.nickname)
                    : AppLocalizations.of(context).settingsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsBreadcrumb extends StatelessWidget {
  const SettingsBreadcrumb({
    super.key,
    required this.label,
    required this.onTap,
  });
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SettingsBreadcrumbSep extends StatelessWidget {
  const SettingsBreadcrumbSep({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    child: Icon(Icons.chevron_right, size: 14, color: AppColors.textTertiary),
  );
}

// ─────────────────────────────────────────────────────────────
// Sidebar nav
// ─────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────
// Notification section
// ─────────────────────────────────────────────────────────────

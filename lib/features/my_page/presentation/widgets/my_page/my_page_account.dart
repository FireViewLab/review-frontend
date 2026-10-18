// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageAccountSection extends StatelessWidget {
  const MyPageAccountSection({
    required this.profile,
    required this.onPasswordTap,
    required this.onSettingsTap,
  });

  final UserProfile profile;
  final VoidCallback onPasswordTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      MyPageAccountItem(
        icon: Icons.person_outline,
        title: l10n.myPageAccountInfo,
        subtitle: l10n.myPageAccountInfoSubtitle,
        onTap: () => _showInfoDialog(
          context,
          title: l10n.myPageAccountInfo,
          lines: [
            l10n.myPageAccountNickname(
              profile.nickname.isEmpty
                  ? l10n.myPageDefaultName
                  : profile.nickname,
            ),
            l10n.myPageAccountEmail(profile.email),
            l10n.myPageAccountMemberType(
              profile.role.isEmpty
                  ? l10n.myPageDefaultMemberRole
                  : profile.role,
            ),
          ],
        ),
      ),
      MyPageAccountItem(
        icon: Icons.lock_outline,
        title: l10n.myPageLoginInfo,
        subtitle: l10n.myPageLoginInfoSubtitle,
        onTap: () => _showInfoDialog(
          context,
          title: l10n.myPageLoginInfo,
          lines: [
            l10n.myPageLoginEmail(profile.email),
            l10n.myPageLoginStatus,
            l10n.myPageOnboarding(
              profile.onboardingCompleted
                  ? l10n.myPageOnboardingComplete
                  : l10n.myPageOnboardingIncomplete,
            ),
          ],
        ),
      ),
      MyPageAccountItem(
        icon: Icons.key_outlined,
        title: l10n.myPageChangePassword,
        subtitle: l10n.myPageChangePasswordSubtitle,
        onTap: onPasswordTap,
      ),
      MyPageAccountItem(
        icon: Icons.notifications_none,
        title: l10n.myPageNotificationSettings,
        subtitle: l10n.myPageNotificationSettingsSubtitle,
        onTap: onSettingsTap,
      ),
    ];

    final columns = context.viewportSize.width < 760 ? 1 : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyPageSectionHeader(title: l10n.myPageAccountSecurity),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 96,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemBuilder: (context, index) =>
              MyPageAccountTile(item: items[index]),
        ),
      ],
    );
  }

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required List<String> lines,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(line),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).actionConfirm),
            ),
          ],
        );
      },
    );
  }
}

class MyPageAccountItem {
  const MyPageAccountItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class MyPageAccountTile extends StatelessWidget {
  const MyPageAccountTile({required this.item});

  final MyPageAccountItem item;

  @override
  Widget build(BuildContext context) {
    return MyPagePanel(
      onTap: item.onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

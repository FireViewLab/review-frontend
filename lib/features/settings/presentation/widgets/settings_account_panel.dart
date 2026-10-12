import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_section_widgets.dart';

class SettingsAccountPanel extends ConsumerWidget {
  const SettingsAccountPanel({
    super.key,
    required this.profile,
    required this.onPasswordTap,
  });
  final UserProfile? profile;
  final VoidCallback onPasswordTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginMethod = ref.watch(accountLoginMethodProvider).value;
    // 소셜 로그인 계정은 비밀번호가 없어 변경 링크를 숨긴다.
    final canChangePassword = loginMethod == null || loginMethod == 'LOCAL';
    final createdAt = profile?.createdAt;
    final joinLabel = createdAt != null
        ? '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}'
        : '-';

    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SettingsIconBadge(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                bg: AppColors.primaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).settingsAccountTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (canChangePassword)
                GestureDetector(
                  onTap: onPasswordTap,
                  child: Text(
                    AppLocalizations.of(context).settingsAccountChangePassword,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.sm),
          SettingsInfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelName,
            value: profile?.nickname.isEmpty ?? true
                ? AppLocalizations.of(context).settingsAccountDefaultName
                : profile!.nickname,
          ),
          SettingsInfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelEmail,
            value: profile?.email ?? '-',
          ),
          SettingsInfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelJoinDate,
            value: joinLabel,
          ),
          SettingsInfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelMemberType,
            value: profile?.role.isEmpty ?? true
                ? AppLocalizations.of(
                    context,
                  ).settingsAccountMemberLabel('USER')
                : AppLocalizations.of(
                    context,
                  ).settingsAccountMemberLabel(profile!.role),
          ),
          if (loginMethod != null)
            SettingsInfoRow(
              label: AppLocalizations.of(
                context,
              ).settingsAccountLabelLoginMethod,
              value: switch (loginMethod) {
                'GOOGLE' => 'Google',
                'NAVER' => AppLocalizations.of(
                  context,
                ).settingsLoginMethodNaver,
                _ => AppLocalizations.of(context).settingsLoginMethodEmail,
              },
            ),
        ],
      ),
    );
  }
}

class SettingsInfoRow extends StatelessWidget {
  const SettingsInfoRow({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

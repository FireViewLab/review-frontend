import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/providers/locale_provider.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted && ref.read(isLoggedInProvider)) {
        ref.read(myPageViewModelProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final settingsState = ref.watch(settingsViewModelProvider);
    if (!isLoggedIn) {
      return Center(
        child: FilledButton(
          onPressed: () => context.go(RoutePaths.login),
          child: Text(AppLocalizations.of(context).actionLogin),
        ),
      );
    }
    final currentLocale = ref.watch(localeProvider);
    final myPageState = ref.watch(myPageViewModelProvider);

    final profile = switch (myPageState) {
      MyPageSuccess(:final profile) => profile,
      _ => null,
    };

    return _SettingsBody(
      settingsState: settingsState,
      currentLocale: currentLocale,
      profile: profile,
      onLocaleChanged: (locale) =>
          ref.read(localeProvider.notifier).setLocale(locale),
      onChanged: (data) =>
          ref.read(settingsViewModelProvider.notifier).update(data),
      onReload: () => ref.read(settingsViewModelProvider.notifier).load(),
      onSave: () => ref.read(settingsViewModelProvider.notifier).save(),
      onPasswordTap: () => context.go(RoutePaths.passwordReset),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settingsState,
    required this.currentLocale,
    required this.profile,
    required this.onLocaleChanged,
    required this.onChanged,
    required this.onReload,
    required this.onSave,
    required this.onPasswordTap,
  });

  final SettingsState settingsState;
  final Locale currentLocale;
  final UserProfile? profile;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<SettingsData> onChanged;
  final VoidCallback onReload;
  final VoidCallback onSave;
  final VoidCallback onPasswordTap;

  @override
  Widget build(BuildContext context) {
    final data = settingsState.settings;
    final isSaving = settingsState is SettingsSaving;
    final isSaved = settingsState is SettingsSaved;
    final l10n = AppLocalizations.of(context);
    final Widget mainContent;
    if (settingsState is SettingsLoading) {
      mainContent = _Card(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.settingsLoading),
          ],
        ),
      );
    } else if (settingsState case SettingsError(
      isLoadError: true,
      :final message,
    )) {
      mainContent = _SettingsFailure(
        title: l10n.settingsLoadFailed,
        message: message,
        onRetry: onReload,
      );
    } else {
      mainContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AbsorbPointer(
            absorbing: isSaving,
            child: _ServerSettingsSections(data: data, onChanged: onChanged),
          ),
          if (settingsState case SettingsError(:final message)) ...[
            const SizedBox(height: AppSpacing.lg),
            _SettingsFailure(
              title: l10n.settingsSaveFailed,
              message: message,
              onRetry: onSave,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _SaveBar(isSaving: isSaving, isSaved: isSaved, onSave: onSave),
        ],
      );
    }

    // 우측 컬럼: 계정 카드 → 언어 설정
    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccountPanel(profile: profile, onPasswordTap: onPasswordTap),
        const SizedBox(height: AppSpacing.lg),
        _LanguageSection(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageTitle(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        // 메뉴는 공통 틀이 그린다. 여기서는 설정 내용과 계정 카드만 놓는다.
        if (context.viewportSize.width < 1240) ...[
          mainContent,
          const SizedBox(height: AppSpacing.xl),
          rightColumn,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: mainContent),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(width: 272, child: rightColumn),
            ],
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Page title & breadcrumb
// ─────────────────────────────────────────────────────────────

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.profile});
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Breadcrumb(
              label: AppLocalizations.of(context).navHome,
              onTap: () => context.go(RoutePaths.home),
            ),
            const _BreadcrumbSep(),
            _Breadcrumb(
              label: AppLocalizations.of(context).navMyPage,
              onTap: () => context.go(RoutePaths.myPage),
            ),
            const _BreadcrumbSep(),
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

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.label, required this.onTap});
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

class _BreadcrumbSep extends StatelessWidget {
  const _BreadcrumbSep();

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

class _ServerSettingsSections extends StatelessWidget {
  const _ServerSettingsSections({required this.data, required this.onChanged});
  final SettingsData data;
  final ValueChanged<SettingsData> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget section(String title, IconData icon, List<Widget> children) => _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: icon,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: title,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        section(l10n.settingsNotifications, Icons.notifications_outlined, [
          _ToggleRow(
            icon: Icons.warning_amber_outlined,
            label: l10n.settingsRiskyProduct,
            description: l10n.settingsRiskyProductDesc,
            value: data.notifyRiskyProduct,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyRiskyProduct: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.analytics_outlined,
            label: l10n.settingsAnalysisComplete,
            description: l10n.settingsAnalysisCompleteDesc,
            value: data.notifyAnalysisComplete,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyAnalysisComplete: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.feedback_outlined,
            label: l10n.settingsFeedbackResult,
            description: l10n.settingsFeedbackResultDesc,
            value: data.notifyFeedbackResult,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyFeedbackResult: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.campaign_outlined,
            label: l10n.settingsMarketing,
            description: l10n.settingsMarketingDesc,
            value: data.notifyMarketing,
            onChanged: (value) =>
                onChanged(data.copyWith(notifyMarketing: value)),
            isLast: true,
          ),
        ]),
        const SizedBox(height: AppSpacing.lg),
        section(l10n.settingsReviewDisplay, Icons.tune_outlined, [
          _FilterInputLabel(
            label: l10n.settingsRtiThreshold,
            description: l10n.settingsRtiThresholdDesc,
          ),
          Text('${data.rtiThreshold}', textAlign: TextAlign.end),
          Slider(
            value: data.rtiThreshold.toDouble().clamp(0, 100),
            min: 0,
            max: 100,
            divisions: 100,
            label: '${data.rtiThreshold}',
            onChanged: (value) =>
                onChanged(data.copyWith(rtiThreshold: value.round())),
          ),
          _ToggleRow(
            icon: Icons.visibility_off_outlined,
            label: l10n.settingsHideRisky,
            description: l10n.settingsHideRiskyDesc,
            value: data.hideRiskyReviews,
            onChanged: (value) =>
                onChanged(data.copyWith(hideRiskyReviews: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.label_outline,
            label: l10n.settingsSuspiciousLabel,
            description: l10n.settingsSuspiciousLabelDesc,
            value: data.showSuspiciousLabel,
            onChanged: (value) =>
                onChanged(data.copyWith(showSuspiciousLabel: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.verified_outlined,
            label: l10n.settingsVerifiedFirst,
            description: l10n.settingsVerifiedFirstDesc,
            value: data.prioritizeVerifiedReviews,
            onChanged: (value) =>
                onChanged(data.copyWith(prioritizeVerifiedReviews: value)),
            isLast: false,
          ),
          _ToggleRow(
            icon: Icons.open_in_new,
            label: l10n.settingsAutoAnalysis,
            description: l10n.settingsAutoAnalysisDesc,
            value: data.autoOpenAnalysisPopup,
            onChanged: (value) =>
                onChanged(data.copyWith(autoOpenAnalysisPopup: value)),
            isLast: true,
          ),
          _SettingsSelect(
            label: l10n.settingsReviewSort,
            value: data.reviewSortOrder,
            options: {
              'VERIFIED_RECENT': l10n.settingsSortVerifiedRecent,
              'RECENT': l10n.settingsSortRecent,
              'HELPFUL': l10n.settingsSortHelpful,
            },
            onChanged: (value) =>
                onChanged(data.copyWith(reviewSortOrder: value)),
          ),
          _SettingsSelect(
            label: l10n.settingsRtiLabel,
            value: data.rtiLabelStyle,
            options: {
              'BADGE_SMALL': l10n.settingsLabelSmall,
              'BADGE_LARGE': l10n.settingsLabelLarge,
              'NONE': l10n.settingsLabelNone,
            },
            onChanged: (value) =>
                onChanged(data.copyWith(rtiLabelStyle: value)),
          ),
          _SettingsSelect(
            label: l10n.settingsCardDensity,
            value: data.cardDensity,
            options: {
              'COMFORTABLE': l10n.settingsDensityComfortable,
              'COMPACT': l10n.settingsDensityCompact,
            },
            onChanged: (value) => onChanged(data.copyWith(cardDensity: value)),
          ),
        ]),
        const SizedBox(height: AppSpacing.lg),
        section(l10n.settingsPrivacy, Icons.privacy_tip_outlined, [
          _ToggleRow(
            icon: Icons.privacy_tip_outlined,
            label: l10n.settingsDataAnalysis,
            description: l10n.settingsDataAnalysisDesc,
            value: data.allowDataAnalysis,
            onChanged: (value) =>
                onChanged(data.copyWith(allowDataAnalysis: value)),
            isLast: true,
          ),
        ]),
      ],
    );
  }
}

class _SettingsSelect extends StatelessWidget {
  const _SettingsSelect({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('$label:$value'),
            initialValue: value,
            isExpanded: true,
            decoration: _inputDecoration(),
            items: [
              for (final entry in options.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value, overflow: TextOverflow.ellipsis),
                ),
              if (!options.containsKey(value))
                DropdownMenuItem(value: value, child: Text(value)),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsFailure extends StatelessWidget {
  const _SettingsFailure({
    required this.title,
    required this.message,
    required this.onRetry,
  });
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(message),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).actionRetry),
        ),
      ],
    ),
  );
}

InputDecoration _inputDecoration({String? suffixText}) {
  return InputDecoration(
    suffixText: suffixText,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    filled: true,
    fillColor: AppColors.surface,
  );
}

class _FilterInputLabel extends StatelessWidget {
  const _FilterInputLabel({required this.label, required this.description});
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Account panel (right column top)
// ─────────────────────────────────────────────────────────────

class _AccountPanel extends ConsumerWidget {
  const _AccountPanel({required this.profile, required this.onPasswordTap});
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

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
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
          _InfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelName,
            value: profile?.nickname.isEmpty ?? true
                ? AppLocalizations.of(context).settingsAccountDefaultName
                : profile!.nickname,
          ),
          _InfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelEmail,
            value: profile?.email ?? '-',
          ),
          _InfoRow(
            label: AppLocalizations.of(context).settingsAccountLabelJoinDate,
            value: joinLabel,
          ),
          _InfoRow(
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
            _InfoRow(
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
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

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  static const _langs = [
    (locale: Locale('ko'), label: '한국어', sub: 'Korean'),
    (locale: Locale('en'), label: 'English', sub: 'English'),
    (locale: Locale('ja'), label: '日本語', sub: 'Japanese'),
    (locale: Locale('zh'), label: '中文', sub: 'Chinese'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.language_outlined,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            title: AppLocalizations.of(context).settingsLanguageSection,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context).settingsLanguageApplyNow,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
              mainAxisExtent: 56,
            ),
            itemCount: _langs.length,
            itemBuilder: (context, index) {
              final lang = _langs[index];
              return _LangChip(
                label: lang.label,
                sub: lang.sub,
                selected:
                    currentLocale.languageCode == lang.locale.languageCode,
                onTap: () => onLocaleChanged(lang.locale),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppColors.onPrimary,
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      sub,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? AppColors.onPrimary.withValues(alpha: 0.75)
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Save bar
// ─────────────────────────────────────────────────────────────

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.isSaving,
    required this.isSaved,
    required this.onSave,
  });

  final bool isSaving;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isSaved
                ? Padding(
                    key: const ValueKey('saved'),
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context).settingsSavedFeedback,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('idle')),
          ),
        ),
        FilledButton(
          onPressed: isSaving ? null : onSave,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(100, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
          ),
          child: isSaving
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : Text(
                  AppLocalizations.of(context).actionSave,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBadge(icon: icon, iconColor: iconColor, bg: iconBg),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.iconColor,
    required this.bg,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: AppColors.border, height: 1),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

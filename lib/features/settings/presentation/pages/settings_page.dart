import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
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
import 'package:re_view_front/features/settings/presentation/widgets/settings_page_header.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_server_sections.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_account_panel.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_language_section.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_save_bar.dart';
import 'package:re_view_front/features/settings/presentation/widgets/settings_section_widgets.dart';

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
      mainContent = SettingsCard(
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
      mainContent = SettingsFailure(
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
            child: SettingsServerSettingsSections(
              data: data,
              onChanged: onChanged,
            ),
          ),
          if (settingsState case SettingsError(:final message)) ...[
            const SizedBox(height: AppSpacing.lg),
            SettingsFailure(
              title: l10n.settingsSaveFailed,
              message: message,
              onRetry: onSave,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          SettingsSaveBar(isSaving: isSaving, isSaved: isSaved, onSave: onSave),
        ],
      );
    }

    // 우측 컬럼: 계정 카드 → 언어 설정
    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsAccountPanel(profile: profile, onPasswordTap: onPasswordTap),
        const SizedBox(height: AppSpacing.lg),
        SettingsLanguageSection(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsPageTitle(profile: profile),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => context.push('${RoutePaths.onboarding}?edit=true'),
            icon: const Icon(Icons.interests_outlined),
            label: const Text('관심 카테고리·알림 설정 다시 편집'),
          ),
        ),
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

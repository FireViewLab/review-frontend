import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';

class SettingsViewModel extends Notifier<SettingsState> {
  int _request = 0;

  @override
  SettingsState build() {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    ++_request;
    if (!isLoggedIn) return const SettingsUnauthenticated();
    Future.microtask(() {
      if (ref.mounted) load();
    });
    return const SettingsLoading();
  }

  Future<void> load() async {
    if (!ref.read(isLoggedInProvider) || state is SettingsSaving) return;
    final request = ++_request;
    state = const SettingsLoading();
    final result = await ref.read(settingsRepositoryProvider).getSettings();
    if (!ref.mounted || request != _request || !ref.read(isLoggedInProvider)) {
      return;
    }
    state = result.when(
      success: (settings) => SettingsIdle(settings: settings),
      failure: (failure) => SettingsError(
        settings: const SettingsData(),
        message: failure.message,
        isLoadError: true,
      ),
    );
  }

  void update(SettingsData settings) {
    if (state is SettingsLoading ||
        state is SettingsSaving ||
        state is SettingsUnauthenticated ||
        (state is SettingsError && (state as SettingsError).isLoadError)) {
      return;
    }
    state = SettingsIdle(settings: settings);
  }

  Future<void> save() async {
    if (!ref.read(isLoggedInProvider) ||
        state is SettingsLoading ||
        state is SettingsSaving ||
        state is SettingsUnauthenticated ||
        (state is SettingsError && (state as SettingsError).isLoadError)) {
      return;
    }
    final request = ++_request;
    final current = state.settings;
    state = SettingsSaving(settings: current);
    final result = await ref
        .read(settingsRepositoryProvider)
        .updateSettings(current);
    if (!ref.mounted || request != _request || !ref.read(isLoggedInProvider)) {
      return;
    }
    state = result.when(
      success: (settings) {
        ref.invalidate(savedDisplayPreferencesProvider);
        return SettingsSaved(settings: settings);
      },
      failure: (failure) =>
          SettingsError(settings: current, message: failure.message),
    );
  }
}

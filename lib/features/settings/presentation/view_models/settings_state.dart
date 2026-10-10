import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

sealed class SettingsState {
  const SettingsState({this.settings = const SettingsData()});
  final SettingsData settings;
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsUnauthenticated extends SettingsState {
  const SettingsUnauthenticated();
}

final class SettingsIdle extends SettingsState {
  const SettingsIdle({required super.settings});
}

final class SettingsSaving extends SettingsState {
  const SettingsSaving({required super.settings});
}

final class SettingsSaved extends SettingsState {
  const SettingsSaved({required super.settings});
}

final class SettingsError extends SettingsState {
  const SettingsError({
    required super.settings,
    required this.message,
    this.isLoadError = false,
  });
  final String message;
  final bool isLoadError;
}

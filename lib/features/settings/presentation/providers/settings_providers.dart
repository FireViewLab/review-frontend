import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:re_view_front/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:re_view_front/features/settings/domain/repositories/settings_repository.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_view_model.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((
  ref,
) {
  return SettingsRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));
});

final settingsViewModelProvider =
    NotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
      SettingsViewModel.new,
    );

/// 로그인 방식(LOCAL / GOOGLE / NAVER). 불러오지 못하면 null.
final accountLoginMethodProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  if (!ref.watch(authSessionProvider).isLoggedIn) return null;
  final result = await ref.read(settingsRepositoryProvider).getLoginMethod();
  return result.when(success: (method) => method, failure: (_) => null);
});

/// Server-confirmed values only; an unsaved settings form is not a preference.
final savedDisplayPreferencesProvider = FutureProvider<SettingsData?>((
  ref,
) async {
  ref.watch(authTokenStoreProvider);
  if (!ref.watch(isLoggedInProvider)) return null;
  final result = await ref.read(settingsRepositoryProvider).getSettings();
  return result.when(
    success: (settings) => settings,
    failure: (failure) => throw failure,
  );
});

final confirmedDisplayPreferencesProvider = Provider<SettingsData?>((ref) {
  if (!ref.watch(isLoggedInProvider)) return null;
  final settings = ref.watch(savedDisplayPreferencesProvider);
  return settings.isLoading || settings.hasError ? null : settings.value;
});

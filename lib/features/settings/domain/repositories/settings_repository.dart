import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

abstract interface class SettingsRepository {
  Future<Result<SettingsData>> getSettings();
  Future<Result<SettingsData>> updateSettings(SettingsData settings);
  Future<Result<String>> getLoginMethod();
}

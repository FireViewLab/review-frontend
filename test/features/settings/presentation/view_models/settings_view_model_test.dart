import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/domain/repositories/settings_repository.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_view_model.dart';

final _loginProvider = NotifierProvider<_Login, bool>(_Login.new);

void main() {
  late _FakeSettingsRepository repository;
  late ProviderContainer container;
  late SettingsViewModel viewModel;

  setUp(() {
    repository = _FakeSettingsRepository();
    container = ProviderContainer(
      overrides: [
        isLoggedInProvider.overrideWith((ref) => ref.watch(_loginProvider)),
        settingsRepositoryProvider.overrideWithValue(repository),
        apiClientProvider.overrideWith(
          (ref) => throw StateError('Unexpected API access'),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  void start() {
    container.listen(
      settingsViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    viewModel = container.read(settingsViewModelProvider.notifier);
  }

  Future<void> loaded() async {
    start();
    await Future<void>.delayed(Duration.zero);
  }

  test('loads server settings on entry and preserves theme', () async {
    start();
    expect(container.read(settingsViewModelProvider), isA<SettingsLoading>());
    await Future<void>.delayed(Duration.zero);
    final state = container.read(settingsViewModelProvider);
    expect(state, isA<SettingsIdle>());
    expect(state.settings.rtiThreshold, 73);
    expect(state.settings.notifyMarketing, isTrue);
    expect(state.settings.theme, 'DARK');
    expect(repository.getCalls, 1);
  });

  test('load failure is shown and retry loads settings', () async {
    repository.getResult = const FailureResult(Failure(message: '불러오기 실패'));
    await loaded();
    final state = container.read(settingsViewModelProvider) as SettingsError;
    expect(state.isLoadError, isTrue);
    expect(state.message, '불러오기 실패');
    await viewModel.save();
    viewModel.update(const SettingsData(rtiThreshold: 10));
    expect(repository.updates, isEmpty);
    expect(container.read(settingsViewModelProvider), same(state));
    repository.getResult = const Success(SettingsData(rtiThreshold: 25));
    await viewModel.load();
    expect(container.read(settingsViewModelProvider).settings.rtiThreshold, 25);
  });

  test('saves edited fields and uses the PATCH response', () async {
    await loaded();
    final draft = container
        .read(settingsViewModelProvider)
        .settings
        .copyWith(
          notifyRiskyProduct: false,
          hideRiskyReviews: false,
          rtiThreshold: 42,
          reviewSortOrder: 'HELPFUL',
          cardDensity: 'COMPACT',
          rtiLabelStyle: 'NONE',
          allowDataAnalysis: false,
        );
    viewModel.update(draft);
    repository.updateResult = Success(draft.copyWith(rtiThreshold: 43));
    await viewModel.save();
    final state = container.read(settingsViewModelProvider);
    expect(state, isA<SettingsSaved>());
    expect(repository.updates.single, same(draft));
    expect(state.settings.rtiThreshold, 43);
    expect(state.settings.theme, 'DARK');
    expect(state.settings.allowDataAnalysis, isFalse);
  });

  test('save failure retains edits and can be retried', () async {
    await loaded();
    final draft = container
        .read(settingsViewModelProvider)
        .settings
        .copyWith(notifyFeedbackResult: false);
    viewModel.update(draft);
    repository.updateResult = const FailureResult(Failure(message: '저장 실패'));
    await viewModel.save();
    final state = container.read(settingsViewModelProvider) as SettingsError;
    expect(state.isLoadError, isFalse);
    expect(state.message, '저장 실패');
    expect(state.settings, same(draft));
    repository.updateResult = null;
    await viewModel.save();
    expect(container.read(settingsViewModelProvider), isA<SettingsSaved>());
    expect(repository.updates, hasLength(2));
  });

  test('ignores duplicate saves and edits while saving', () async {
    await loaded();
    final pending = Completer<Result<SettingsData>>();
    repository.onUpdate = () => pending.future;
    final draft = container.read(settingsViewModelProvider).settings;
    final saving = viewModel.save();
    expect(container.read(settingsViewModelProvider), isA<SettingsSaving>());
    viewModel.update(draft.copyWith(rtiThreshold: 0));
    await viewModel.save();
    expect(repository.updates, hasLength(1));
    expect(container.read(settingsViewModelProvider).settings, same(draft));
    pending.complete(Success(draft));
    await saving;
    expect(container.read(settingsViewModelProvider), isA<SettingsSaved>());
  });

  test('does not request settings when logged out', () async {
    container.read(_loginProvider.notifier).setLoggedIn(false);
    start();
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(settingsViewModelProvider),
      isA<SettingsUnauthenticated>(),
    );
    await viewModel.load();
    await viewModel.save();
    expect(repository.getCalls, 0);
    expect(repository.updates, isEmpty);
  });

  test('logout discards a pending response and clears settings', () async {
    final pending = Completer<Result<SettingsData>>();
    repository.onGet = () => pending.future;
    start();
    await Future<void>.delayed(Duration.zero);
    container.read(_loginProvider.notifier).setLoggedIn(false);
    expect(
      container.read(settingsViewModelProvider),
      isA<SettingsUnauthenticated>(),
    );
    pending.complete(
      const Success(SettingsData(theme: 'DARK', rtiThreshold: 1)),
    );
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(settingsViewModelProvider),
      isA<SettingsUnauthenticated>(),
    );
    expect(container.read(settingsViewModelProvider).settings.theme, 'SYSTEM');
  });

  test('latest load wins when requests complete out of order', () async {
    final first = Completer<Result<SettingsData>>();
    repository.onGet = () => first.future;
    start();
    await Future<void>.delayed(Duration.zero);
    repository.onGet = null;
    repository.getResult = const Success(SettingsData(rtiThreshold: 88));
    await viewModel.load();
    first.complete(const Success(SettingsData(rtiThreshold: 1)));
    await Future<void>.delayed(Duration.zero);
    expect(container.read(settingsViewModelProvider).settings.rtiThreshold, 88);
  });

  test('ignores late save response after disposal', () async {
    await loaded();
    final pending = Completer<Result<SettingsData>>();
    repository.onUpdate = () => pending.future;
    final saving = viewModel.save();
    container.dispose();
    pending.complete(const Success(SettingsData()));
    await saving;
    container = ProviderContainer();
  });
}

class _Login extends Notifier<bool> {
  @override
  bool build() => true;
  void setLoggedIn(bool value) => state = value;
}

class _FakeSettingsRepository implements SettingsRepository {
  Result<SettingsData> getResult = const Success(
    SettingsData(rtiThreshold: 73, notifyMarketing: true, theme: 'DARK'),
  );
  Result<SettingsData>? updateResult;
  Future<Result<SettingsData>> Function()? onGet;
  Future<Result<SettingsData>> Function()? onUpdate;
  int getCalls = 0;
  final updates = <SettingsData>[];

  @override
  Future<Result<SettingsData>> getSettings() async {
    ++getCalls;
    return onGet == null ? getResult : await onGet!();
  }

  @override
  Future<Result<SettingsData>> updateSettings(SettingsData settings) async {
    updates.add(settings);
    return onUpdate == null
        ? updateResult ?? Success(settings)
        : await onUpdate!();
  }

  @override
  Future<Result<String>> getLoginMethod() async => const Success('LOCAL');
}

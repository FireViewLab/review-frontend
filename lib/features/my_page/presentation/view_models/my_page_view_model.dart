import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';

class MyPageViewModel extends Notifier<MyPageState> {
  int _generation = 0;
  @override
  MyPageState build() {
    ref.watch(authSessionProvider);
    _generation++;
    Future.microtask(load);
    return const MyPageLoading();
  }

  Future<void> load() async {
    if (!ref.mounted) return;

    final generation = ++_generation;
    state = const MyPageLoading();
    final result = await ref.read(getMyProfileUseCaseProvider)();
    if (!ref.mounted ||
        generation != _generation ||
        !ref.read(isLoggedInProvider))
      return;

    state = result.when(
      success: (profile) {
        if (profile.nickname.isNotEmpty) {
          ref
              .read(authTokenStoreProvider.notifier)
              .saveNickname(profile.nickname);
        }
        return MyPageSuccess(profile);
      },
      failure: MyPageFailure.new,
    );
  }
}

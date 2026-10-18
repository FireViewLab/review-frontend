import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:re_view_front/features/my_page/data/repositories/my_page_repository_impl.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_activity.dart';
import 'package:re_view_front/features/my_page/domain/repositories/my_page_repository.dart';
import 'package:re_view_front/features/my_page/domain/usecases/get_my_profile_use_case.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_view_model.dart';

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>((ref) {
  return MyPageRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  return MyPageRepositoryImpl(ref.watch(myPageRemoteDataSourceProvider));
});

final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCase>((ref) {
  return GetMyProfileUseCase(ref.watch(myPageRepositoryProvider));
});

final myPageViewModelProvider =
    NotifierProvider.autoDispose<MyPageViewModel, MyPageState>(
      MyPageViewModel.new,
    );

/// 마이페이지 최근 활동. 화면을 벗어나면 버리고 다시 들어오면 새로 불러온다.
final myActivitiesProvider = FutureProvider.autoDispose<List<UserActivity>>((
  ref,
) async {
  if (!ref.watch(authSessionProvider).isLoggedIn) return [];
  final result = await ref.read(myPageRepositoryProvider).getMyActivities();
  return result.when(
    success: (activities) => activities,
    failure: (failure) => throw failure,
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_user_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_user_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_user_repository.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_view_model.dart';

final adminUserRemoteDataSourceProvider = Provider<AdminUserRemoteDataSource>((
  ref,
) {
  return AdminUserRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  return AdminUserRepositoryImpl(ref.watch(adminUserRemoteDataSourceProvider));
});

final adminUserViewModelProvider =
    NotifierProvider.autoDispose<AdminUserViewModel, AdminUserState>(
  AdminUserViewModel.new,
);

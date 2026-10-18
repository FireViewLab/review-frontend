import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_dashboard_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_dashboard_repository.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_dashboard_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_dashboard_view_model.dart';

final adminDashboardRemoteDataSourceProvider =
    Provider<AdminDashboardRemoteDataSource>((ref) {
  return AdminDashboardRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepositoryImpl(
    ref.watch(adminDashboardRemoteDataSourceProvider),
  );
});

final adminDashboardViewModelProvider = NotifierProvider.autoDispose<
    AdminDashboardViewModel, AdminDashboardState>(
  AdminDashboardViewModel.new,
);

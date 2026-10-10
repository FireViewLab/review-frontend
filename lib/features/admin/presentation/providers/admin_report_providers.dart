import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_report_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_report_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_report_repository.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_view_model.dart';

final adminReportRemoteDataSourceProvider =
    Provider<AdminReportRemoteDataSource>((ref) {
  return AdminReportRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final adminReportRepositoryProvider = Provider<AdminReportRepository>((ref) {
  return AdminReportRepositoryImpl(
    ref.watch(adminReportRemoteDataSourceProvider),
  );
});

final adminReportViewModelProvider =
    NotifierProvider.autoDispose<AdminReportViewModel, AdminReportState>(
  AdminReportViewModel.new,
);

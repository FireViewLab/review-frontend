import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_suspicious_review_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_suspicious_review_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_suspicious_review_repository.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_view_model.dart';

final adminSuspiciousReviewRemoteDataSourceProvider =
    Provider<AdminSuspiciousReviewRemoteDataSource>((ref) {
  return AdminSuspiciousReviewRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final adminSuspiciousReviewRepositoryProvider =
    Provider<AdminSuspiciousReviewRepository>((ref) {
  return AdminSuspiciousReviewRepositoryImpl(
    ref.watch(adminSuspiciousReviewRemoteDataSourceProvider),
  );
});

final adminSuspiciousReviewViewModelProvider = NotifierProvider.autoDispose<
    AdminSuspiciousReviewViewModel, AdminSuspiciousReviewState>(
  AdminSuspiciousReviewViewModel.new,
);

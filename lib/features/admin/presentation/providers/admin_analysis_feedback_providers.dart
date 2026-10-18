import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_analysis_feedback_remote_data_source.dart';
import 'package:re_view_front/features/admin/data/repositories/admin_analysis_feedback_repository_impl.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_analysis_feedback_repository.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_view_model.dart';

final adminAnalysisFeedbackRemoteDataSourceProvider =
    Provider<AdminAnalysisFeedbackRemoteDataSource>((ref) {
  return AdminAnalysisFeedbackRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final adminAnalysisFeedbackRepositoryProvider =
    Provider<AdminAnalysisFeedbackRepository>((ref) {
  return AdminAnalysisFeedbackRepositoryImpl(
    ref.watch(adminAnalysisFeedbackRemoteDataSourceProvider),
  );
});

final adminAnalysisFeedbackViewModelProvider = NotifierProvider.autoDispose<
    AdminAnalysisFeedbackViewModel, AdminAnalysisFeedbackState>(
  AdminAnalysisFeedbackViewModel.new,
);

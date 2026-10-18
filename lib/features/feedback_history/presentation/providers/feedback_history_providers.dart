import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/feedback_history/data/datasources/feedback_history_remote_data_source.dart';
import 'package:re_view_front/features/feedback_history/data/repositories/feedback_history_repository_impl.dart';
import 'package:re_view_front/features/feedback_history/domain/repositories/feedback_history_repository.dart';
import 'package:re_view_front/features/feedback_history/domain/usecases/get_feedback_history_use_case.dart';
import 'package:re_view_front/features/feedback_history/presentation/view_models/feedback_history_state.dart';
import 'package:re_view_front/features/feedback_history/presentation/view_models/feedback_history_view_model.dart';

final feedbackHistoryRemoteDataSourceProvider =
    Provider<FeedbackHistoryRemoteDataSource>((ref) {
  return FeedbackHistoryRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final feedbackHistoryRepositoryProvider =
    Provider<FeedbackHistoryRepository>((ref) {
  return FeedbackHistoryRepositoryImpl(
    ref.watch(feedbackHistoryRemoteDataSourceProvider),
  );
});

final getFeedbackHistoryUseCaseProvider =
    Provider<GetFeedbackHistoryUseCase>((ref) {
  return GetFeedbackHistoryUseCase(
    ref.watch(feedbackHistoryRepositoryProvider),
  );
});

final feedbackHistoryViewModelProvider =
    NotifierProvider<FeedbackHistoryViewModel, FeedbackHistoryState>(
  FeedbackHistoryViewModel.new,
);

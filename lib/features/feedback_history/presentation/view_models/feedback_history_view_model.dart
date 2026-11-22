import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/feedback_history/domain/usecases/get_feedback_history_use_case.dart';
import 'package:re_view_front/features/feedback_history/presentation/providers/feedback_history_providers.dart';
import 'package:re_view_front/features/feedback_history/presentation/view_models/feedback_history_state.dart';

class FeedbackHistoryViewModel extends Notifier<FeedbackHistoryState> {
  late final GetFeedbackHistoryUseCase _getUseCase;

  @override
  FeedbackHistoryState build() {
    _getUseCase = ref.watch(getFeedbackHistoryUseCaseProvider);
    return const FeedbackHistoryInitial();
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    if (!ref.read(isLoggedInProvider)) {
      state = const FeedbackHistoryEmpty();
      return;
    }

    final isRefresh = switch (state) {
      FeedbackHistorySuccess() => true,
      FeedbackHistoryLoading(:final isRefresh) => isRefresh,
      _ => false,
    };
    state = FeedbackHistoryLoading(isRefresh: isRefresh);

    final result = await _getUseCase();

    if (!ref.mounted) return;
    state = result.when(
      success: (items) => items.isEmpty
          ? const FeedbackHistoryEmpty()
          : FeedbackHistorySuccess(items),
      failure: FeedbackHistoryFailure.new,
    );
  }
}

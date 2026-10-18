import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';

sealed class FeedbackHistoryState {
  const FeedbackHistoryState();
}

class FeedbackHistoryInitial extends FeedbackHistoryState {
  const FeedbackHistoryInitial();
}

class FeedbackHistoryLoading extends FeedbackHistoryState {
  const FeedbackHistoryLoading();
}

class FeedbackHistorySuccess extends FeedbackHistoryState {
  const FeedbackHistorySuccess(this.items);

  final List<FeedbackItem> items;
}

class FeedbackHistoryEmpty extends FeedbackHistoryState {
  const FeedbackHistoryEmpty();
}

class FeedbackHistoryFailure extends FeedbackHistoryState {
  const FeedbackHistoryFailure(this.failure);

  final Failure failure;
}

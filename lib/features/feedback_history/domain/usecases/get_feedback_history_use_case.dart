import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';
import 'package:re_view_front/features/feedback_history/domain/repositories/feedback_history_repository.dart';

class GetFeedbackHistoryUseCase {
  const GetFeedbackHistoryUseCase(this._repository);

  final FeedbackHistoryRepository _repository;

  Future<Result<List<FeedbackItem>>> call() => _repository.getFeedbackHistory();
}

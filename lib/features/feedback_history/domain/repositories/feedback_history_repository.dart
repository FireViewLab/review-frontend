import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';

abstract interface class FeedbackHistoryRepository {
  Future<Result<List<FeedbackItem>>> getFeedbackHistory();
}

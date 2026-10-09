import 'chat_recommendation.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';

/// 질문 전송 결과.
class ChatReply {
  const ChatReply({
    required this.sessionId,
    required this.answer,
    required this.blocked,
    this.blockReason,
    List<ChatRecommendation> recommendations = const [],
    this.quota,
  }) : _recommendations = recommendations;

  /// 다음 질문에 그대로 넣으면 대화가 이어진다.
  final int sessionId;
  final String answer;
  final bool blocked;
  final String? blockReason;

  /// 이 질문까지 반영한 오늘 사용량.
  final ChatQuota? quota;
  final List<ChatRecommendation> _recommendations;
  List<ChatRecommendation> get recommendations =>
      blocked ? const [] : _recommendations;
}

import 'dart:async';

import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/plan/domain/entities/plan_option.dart';
import 'package:re_view_front/features/plan/domain/repositories/plan_repository.dart';
import 'package:re_view_front/core/error/failure.dart';

ChatQuota quotaOf({
  String plan = 'FREE',
  int limit = 5,
  int used = 2,
  bool pro = false,
}) => ChatQuota(
  planCode: plan,
  dailyLimit: limit,
  usedToday: used,
  remaining: limit - used,
  proAvailable: pro,
  resetAt: DateTime.now().add(const Duration(hours: 3)),
);

class FakePlanRepository implements PlanRepository {
  Result<List<PlanOption>> plans = const FailureResult(
    Failure(message: 'Not Found', statusCode: 404),
  );
  Result<DateTime?> expiry = const Success(null);
  Result<void> change = const Success(null);
  Completer<Result<void>>? pendingChange;
  void Function(String code)? onChange;
  final List<String> changes = [];

  @override
  Future<Result<List<PlanOption>>> getPlans() async => plans;

  @override
  Future<Result<DateTime?>> getMyPlanExpiry() async => expiry;

  @override
  Future<Result<void>> changeMyPlan(String code) async {
    changes.add(code);
    final result = pendingChange == null ? change : await pendingChange!.future;
    if (result is Success<void>) onChange?.call(code);
    return result;
  }
}

/// 요금제 화면은 채팅 저장소에서 사용량만 읽는다.
class FakeQuotaRepository implements ChatRepository {
  Result<ChatQuota> quota = Success(quotaOf());
  int quotaRequests = 0;

  @override
  Future<Result<ChatQuota>> getQuota() async {
    quotaRequests++;
    return quota;
  }

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
    ChatMode mode = ChatMode.standard,
  }) => throw UnimplementedError();

  @override
  Future<Result<ChatSessionPage>> getSessions({
    required int page,
    required int size,
  }) => throw UnimplementedError();

  @override
  Future<Result<List<ChatMessage>>> getSessionMessages(int sessionId) =>
      throw UnimplementedError();
}

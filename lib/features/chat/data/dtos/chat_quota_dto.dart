import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';

class ChatQuotaDto {
  const ChatQuotaDto(this._json);

  final Map<String, dynamic> _json;

  /// 숫자가 빠진 응답은 0으로 채우지 않고 버린다. 0은 "한도 소진"으로 읽히기 때문이다.
  ChatQuota? toEntity() {
    final dailyLimit = _json['dailyLimit'];
    final usedToday = _json['usedToday'];
    final remaining = _json['remaining'];
    final plan = _json['plan']?.toString();
    if (dailyLimit is! num ||
        usedToday is! num ||
        remaining is! num ||
        plan == null ||
        plan.isEmpty) {
      return null;
    }
    return ChatQuota(
      planCode: plan,
      planName: _json['planName']?.toString(),
      dailyLimit: dailyLimit.toInt(),
      usedToday: usedToday.toInt(),
      remaining: remaining.toInt(),
      proAvailable: _json['proAvailable'] == true,
      resetAt: DateTime.tryParse(_json['resetAt']?.toString() ?? ''),
    );
  }
}

import 'package:re_view_front/features/chat/domain/entities/chat_recommendation.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_quota_dto.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';

class ChatReplyDto {
  const ChatReplyDto(this._json);

  final Map<String, dynamic> _json;

  ChatReply toEntity() {
    final quota = _json['quota'];
    return ChatReply(
      sessionId: (_json['sessionId'] as num?)?.toInt() ?? 0,
      answer: _json['answer']?.toString() ?? '',
      blocked: _json['blocked'] == true,
      recommendations: _json['blocked'] == true ? const [] : _recommendations(),
      blockReason: _json['blockReason']?.toString(),
      quota: quota is Map<String, dynamic>
          ? ChatQuotaDto(quota).toEntity()
          : null,
    );
  }

  List<ChatRecommendation> _recommendations() {
    final raw = _json['recommendations'];
    if (raw is! List) return const [];
    final result = <ChatRecommendation>[];
    final seen = <ExternalProductRef>{};
    for (final item in raw) {
      if (item is! Map<String, dynamic>) continue;
      final name = _string(item['name']);
      final ref = ExternalProductRef.resolve(
        dataPlatform: _string(item['platform']),
        dataProductId: _string(item['productId']),
        externalId: _string(item['externalId']),
      );
      if (name == null ||
          ref == null ||
          !RegExp(r'^[a-z0-9_]+$').hasMatch(ref.platform) ||
          RegExp(r'[\s\x00-\x1f]').hasMatch(ref.productId) ||
          !seen.add(ref)) {
        continue;
      }
      final image = _string(item['thumbnailUrl']);
      final uri = image == null ? null : Uri.tryParse(image);
      result.add(
        ChatRecommendation(
          observedAt: DateTime.now(),
          ref: ref,
          name: name,
          price: _integer(item['price']),
          reviewCount: _integer(item['reviewCount']),
          rating: _number(item['rating']),
          thumbnailUrl:
              uri != null &&
                  ['http', 'https'].contains(uri.scheme) &&
                  uri.host.isNotEmpty &&
                  uri.userInfo.isEmpty
              ? image
              : null,
        ),
      );
      if (result.length == 3) break;
    }
    return List.unmodifiable(result);
  }

  static String? _string(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
  static num? _numeric(Object? value) => value is num
      ? value
      : value is String
      ? num.tryParse(value.trim())
      : null;
  static double? _number(Object? value) {
    final v = _numeric(value);
    return v != null && v.isFinite && v >= 0 ? v.toDouble() : null;
  }

  static int? _integer(Object? value) {
    final v = _numeric(value);
    return v != null &&
            v.isFinite &&
            v >= 0 &&
            v <= 9007199254740991 &&
            v == v.truncateToDouble()
        ? v.toInt()
        : null;
  }
}

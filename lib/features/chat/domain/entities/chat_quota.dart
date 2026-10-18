/// 질문을 보내는 엔드포인트 등급. 프로는 프로 요금제만 쓸 수 있다.
enum ChatMode { standard, pro }

/// 서버가 알려 준 오늘의 챗봇 사용량. 한도 수치는 서버 설정이라 화면에서 지어내지 않는다.
class ChatQuota {
  const ChatQuota({
    required this.planCode,
    required this.dailyLimit,
    required this.usedToday,
    required this.remaining,
    required this.proAvailable,
    this.planName,
    this.resetAt,
  });

  /// 서버가 한도 없음을 뜻할 때 쓰는 값.
  static const unlimited = -1;

  /// 요금제 코드 (FREE / PLUS / PRO). 모르는 값도 그대로 둔다.
  final String planCode;
  final String? planName;
  final int dailyLimit;
  final int usedToday;
  final int remaining;
  final bool proAvailable;

  /// 한도가 초기화되는 시각.
  final DateTime? resetAt;

  bool get isUnlimited => dailyLimit == unlimited || remaining == unlimited;

  /// 오늘 더 보낼 수 없는지. 초기화 시각이 지났으면 서버에 다시 물어봐야 하므로 false.
  bool isExhaustedAt(DateTime now) {
    if (isUnlimited || remaining > 0) return false;
    final resetAt = this.resetAt;
    return resetAt == null || now.isBefore(resetAt);
  }
}

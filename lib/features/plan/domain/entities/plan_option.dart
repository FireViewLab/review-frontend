/// 고를 수 있는 요금제 하나.
class PlanOption {
  const PlanOption({required this.code, this.dailyLimit, this.proAvailable});

  /// 서버 요금제 코드 (FREE / PLUS / PRO).
  final String code;

  /// 하루 질문 수. 서버가 알려 주지 않으면 null이고, 화면에 숫자를 쓰지 않는다.
  /// -1이면 제한 없음.
  final int? dailyLimit;

  /// 프로 모드를 쓸 수 있는지. 서버가 알려 주지 않으면 null.
  final bool? proAvailable;

  /// 서버가 요금제 목록을 주지 않을 때 쓰는 기본 목록. 수치는 넣지 않는다.
  static const fallback = [
    PlanOption(code: 'FREE'),
    PlanOption(code: 'PLUS'),
    PlanOption(code: 'PRO'),
  ];
}

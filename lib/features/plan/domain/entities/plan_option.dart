/// 고를 수 있는 요금제 하나.
///
/// 요금제별 하루 한도는 서버 설정값이고 목록으로 내려 주지 않는다. 그래서 숫자는
/// 현재 요금제에 한해 사용량 응답에서 가져오고, 여기에는 넣지 않는다.
class PlanOption {
  const PlanOption({required this.code});

  /// 서버 요금제 코드 (FREE / PLUS / PRO).
  final String code;

  static const all = [
    PlanOption(code: 'FREE'),
    PlanOption(code: 'PLUS'),
    PlanOption(code: 'PRO'),
  ];
}

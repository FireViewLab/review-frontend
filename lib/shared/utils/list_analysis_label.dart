/// 목록의 최신 분석 상태와 표본 점수를 구분한다.
String listAnalysisLabel({num? score, String? status, bool sampled = false}) {
  final state = status?.toUpperCase();
  if (score != null &&
      score.isFinite &&
      score >= 0 &&
      score <= 100 &&
      (state == null || state == 'DONE')) {
    return '${sampled ? '표본 ' : ''}RTI ${score.round()}';
  }
  return switch (state) {
    'DONE' => '점수 없음',
    'QUEUED' => '분석 대기',
    'RUNNING' => '분석 중',
    'FAILED' => '분석 실패',
    'STALE' => '재분석 필요',
    'DISABLED' => '분석 비활성',
    'UNAVAILABLE' => '상태 확인 필요',
    _ => '분석 전',
  };
}

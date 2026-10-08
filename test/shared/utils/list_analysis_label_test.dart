import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/shared/utils/list_analysis_label.dart';
import 'package:re_view_front/features/home/data/dtos/dashboard_product_dto.dart';
import 'package:re_view_front/features/search/data/dtos/search_result_product_dto.dart';

void main() {
  test('완료 분석의 실제0점과 표본을 표시한다', () {
    expect(listAnalysisLabel(score: 0, status: 'DONE'), 'RTI 0');
    expect(
      listAnalysisLabel(score: 85.6, status: 'done', sampled: true),
      '표본 RTI 86',
    );
    expect(listAnalysisLabel(status: 'DONE'), '점수 없음');
  });

  test('진행 또는 실패 상태에서는 이전 점수를 보이지 않는다', () {
    for (final state in {
      'QUEUED': '분석 대기',
      'RUNNING': '분석 중',
      'FAILED': '분석 실패',
      'STALE': '재분석 필요',
      'DISABLED': '분석 비활성',
    }.entries) {
      expect(listAnalysisLabel(score: 80, status: state.key), state.value);
    }
    expect(listAnalysisLabel(score: -1), '분석 전');
  });

  test('홈과 검색 DTO가 목록 상태와 표본 건수를 보존한다', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': '상품',
      'avgRti': 0,
      'analysisStatus': 'DONE',
      'analysisSampled': true,
      'analysisReviewCount': 500,
      'analysisSourceReviewCount': 1318,
    };
    final home = DashboardProductDto.fromJson(json).toEntity();
    final search = SearchResultProductDto.fromJson(json).toEntity();
    expect(home.rtiScore, 0);
    expect(search.avgRti, 0);
    expect(home.analysisStatus, 'DONE');
    expect(search.analysisStatus, 'DONE');
    expect(home.analysisSampled, true);
    expect(search.analysisSampled, true);
    expect(home.analysisReviewCount, 500);
    expect(search.analysisSourceReviewCount, 1318);
  });
}

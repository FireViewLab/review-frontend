import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';

abstract interface class AdminAnalysisFeedbackRepository {
  /// 분석 피드백 검수 목록 조회. [status]가 null이면 전체.
  Future<Result<AdminPage<AdminAnalysisFeedback>>> getFeedbacks({
    AnalysisFeedbackStatus? status,
    required int page,
    required int size,
  });

  /// 특정 상태의 전체 건수 조회 (KPI용). [status]가 null이면 전체.
  Future<Result<int>> countByStatus(AnalysisFeedbackStatus? status);

  /// 분석 피드백 상태 변경 + 운영자 코멘트. 성공 시 true.
  Future<Result<bool>> updateStatus({
    required int feedbackId,
    required AnalysisFeedbackStatus status,
    String? adminComment,
  });
}

import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';

/// 분석 피드백 상태 → 배지 색조 매핑 (프레젠테이션 관심사).
extension AnalysisFeedbackStatusTone on AnalysisFeedbackStatus {
  AdminBadgeTone get tone => switch (this) {
        AnalysisFeedbackStatus.submitted => AdminBadgeTone.info,
        AnalysisFeedbackStatus.underReview => AdminBadgeTone.warning,
        AnalysisFeedbackStatus.resolved => AdminBadgeTone.success,
        AnalysisFeedbackStatus.rejected => AdminBadgeTone.danger,
      };
}

import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';

/// 신고 상태 → 배지 색조 매핑 (프레젠테이션 관심사).
extension ReportStatusTone on ReportStatus {
  AdminBadgeTone get tone => switch (this) {
        ReportStatus.pending => AdminBadgeTone.warning,
        ReportStatus.underReview => AdminBadgeTone.info,
        ReportStatus.accepted => AdminBadgeTone.success,
        ReportStatus.rejected => AdminBadgeTone.danger,
      };
}

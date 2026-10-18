import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';

/// 신뢰 등급 → 배지 색조 매핑 (프레젠테이션 관심사).
extension TrustGradeTone on TrustGrade {
  AdminBadgeTone get tone => switch (this) {
        TrustGrade.danger => AdminBadgeTone.danger,
        TrustGrade.warning => AdminBadgeTone.warning,
        TrustGrade.safe => AdminBadgeTone.success,
      };
}

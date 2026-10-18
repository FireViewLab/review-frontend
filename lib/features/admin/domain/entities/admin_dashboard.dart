/// 관리자 대시보드 상단 지표.
class AdminDashboardSummary {
  const AdminDashboardSummary({
    required this.totalReviews,
    required this.pendingReports,
    required this.pendingAnalysisFeedbacks,
    required this.totalUsers,
    required this.suspiciousReviewCount,
    required this.dangerReviewCount,
  });

  final int totalReviews;
  final int pendingReports;
  final int pendingAnalysisFeedbacks;
  final int totalUsers;
  final int suspiciousReviewCount;
  final int dangerReviewCount;
}

/// AI 모델 성능 지표. 비율 필드는 모두 0~100 사이의 퍼센트 값이다.
class AdminModelPerformance {
  const AdminModelPerformance({
    required this.totalAnalyzedReviews,
    required this.averageRtiScore,
    required this.rtiDistribution,
    required this.userAgreement,
    required this.feedbackStats,
    required this.dailyTrend,
  });

  final int totalAnalyzedReviews;
  final double averageRtiScore;
  final RtiDistribution rtiDistribution;
  final UserAgreementStats userAgreement;
  final AnalysisFeedbackStats feedbackStats;
  final List<DailyRtiTrend> dailyTrend;
}

class RtiDistribution {
  const RtiDistribution({
    required this.safeCount,
    required this.suspiciousCount,
    required this.dangerCount,
    required this.safePercent,
    required this.suspiciousPercent,
    required this.dangerPercent,
  });

  final int safeCount;
  final int suspiciousCount;
  final int dangerCount;
  final double safePercent;
  final double suspiciousPercent;
  final double dangerPercent;
}

class UserAgreementStats {
  const UserAgreementStats({
    required this.totalFeedbacks,
    required this.agreementCount,
    required this.disagreementCount,
    required this.agreementRate,
  });

  final int totalFeedbacks;
  final int agreementCount;
  final int disagreementCount;
  final double agreementRate;
}

class AnalysisFeedbackStats {
  const AnalysisFeedbackStats({
    required this.submitted,
    required this.underReview,
    required this.resolved,
    required this.rejected,
    required this.resolutionRate,
  });

  final int submitted;
  final int underReview;
  final int resolved;
  final int rejected;
  final double resolutionRate;
}

class DailyRtiTrend {
  const DailyRtiTrend({
    required this.date,
    required this.averageRti,
    required this.reviewCount,
  });

  final DateTime date;
  final double averageRti;
  final int reviewCount;
}

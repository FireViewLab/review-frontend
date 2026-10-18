import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';

int _int(Object? v) => (v as num?)?.toInt() ?? 0;
double _double(Object? v) => (v as num?)?.toDouble() ?? 0;
Map<String, dynamic> _map(Object? v) =>
    v is Map<String, dynamic> ? v : const <String, dynamic>{};

class AdminDashboardSummaryDto {
  const AdminDashboardSummaryDto(this._json);

  final Map<String, dynamic> _json;

  AdminDashboardSummary toEntity() {
    return AdminDashboardSummary(
      totalReviews: _int(_json['totalReviews']),
      pendingReports: _int(_json['pendingReports']),
      pendingAnalysisFeedbacks: _int(_json['pendingAnalysisFeedbacks']),
      totalUsers: _int(_json['totalUsers']),
      suspiciousReviewCount: _int(_json['suspiciousReviewCount']),
      dangerReviewCount: _int(_json['dangerReviewCount']),
    );
  }
}

class AdminModelPerformanceDto {
  const AdminModelPerformanceDto(this._json);

  final Map<String, dynamic> _json;

  AdminModelPerformance toEntity() {
    final distribution = _map(_json['rtiDistribution']);
    final agreement = _map(_json['userAgreement']);
    final feedback = _map(_json['analysisFeedbackStats']);
    final trend = _json['dailyRtiTrend'];
    return AdminModelPerformance(
      totalAnalyzedReviews: _int(_json['totalAnalyzedReviews']),
      averageRtiScore: _double(_json['averageRtiScore']),
      rtiDistribution: RtiDistribution(
        safeCount: _int(distribution['safeCount']),
        suspiciousCount: _int(distribution['suspiciousCount']),
        dangerCount: _int(distribution['dangerCount']),
        safePercent: _double(distribution['safePercent']),
        suspiciousPercent: _double(distribution['suspiciousPercent']),
        dangerPercent: _double(distribution['dangerPercent']),
      ),
      userAgreement: UserAgreementStats(
        totalFeedbacks: _int(agreement['totalFeedbacks']),
        agreementCount: _int(agreement['agreementCount']),
        disagreementCount: _int(agreement['disagreementCount']),
        agreementRate: _double(agreement['agreementRate']),
      ),
      feedbackStats: AnalysisFeedbackStats(
        submitted: _int(feedback['submitted']),
        underReview: _int(feedback['underReview']),
        resolved: _int(feedback['resolved']),
        rejected: _int(feedback['rejected']),
        resolutionRate: _double(feedback['resolutionRate']),
      ),
      dailyTrend: [
        if (trend is List)
          for (final item in trend.whereType<Map<String, dynamic>>())
            if (DateTime.tryParse(item['date']?.toString() ?? '')
                case final date?)
              DailyRtiTrend(
                date: date,
                averageRti: _double(item['averageRti']),
                reviewCount: _int(item['reviewCount']),
              ),
      ],
    );
  }
}

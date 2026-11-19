import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';

class ProductAnalysisResult {
  const ProductAnalysisResult({
    this.analysis,
    required this.averageRti,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
    required this.reviewDetails,
    this.trend = const [],
    this.realReviewRatio = 0.0,
    this.adSuspicionRatio = 0.0,
    this.repetitiveRatio = 0.0,
    this.trustSignals = const [],
  });

  final AnalysisDisplay? analysis;
  final double? averageRti;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Map<int, ReviewRtiDetail> reviewDetails;
  final List<AnalysisTrendPoint> trend;
  final double realReviewRatio;
  final double adSuspicionRatio;
  final double repetitiveRatio;
  final List<TrustSignal> trustSignals;
}

class AnalysisTrendPoint {
  const AnalysisTrendPoint({
    required this.date,
    required this.averageRti,
    required this.reviewCount,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final String date;
  final double averageRti;
  final int reviewCount;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
}

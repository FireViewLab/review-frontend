import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';

abstract interface class AdminSuspiciousReviewRepository {
  /// 의심 리뷰 목록 조회. [maxRti] 미만의 RTI 점수 리뷰만 반환.
  Future<Result<AdminPage<AdminSuspiciousReview>>> getReviews({
    required int maxRti,
    required int page,
    required int size,
  });
}

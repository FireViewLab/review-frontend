import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_suspicious_review_remote_data_source.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_suspicious_review_repository.dart';

class AdminSuspiciousReviewRepositoryImpl
    implements AdminSuspiciousReviewRepository {
  const AdminSuspiciousReviewRepositoryImpl(this._dataSource);

  final AdminSuspiciousReviewRemoteDataSource _dataSource;

  @override
  Future<Result<AdminPage<AdminSuspiciousReview>>> getReviews({
    required int maxRti,
    required int page,
    required int size,
  }) async {
    try {
      final result = await _dataSource.getReviews(
        maxRti: maxRti,
        page: page,
        size: size,
      );
      return Success(result);
    } catch (e) {
      if (e is DioException && e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        return FailureResult(Failure(
          message: data['message']?.toString() ?? e.toString(),
          code: data['errorCode']?.toString(),
          statusCode: e.response?.statusCode,
        ));
      }
      return FailureResult(Failure(message: e.toString()));
    }
  }
}

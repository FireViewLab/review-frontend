import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/review_report/data/datasources/review_report_remote_data_source.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/domain/repositories/review_report_repository.dart';

class ReviewReportRepositoryImpl implements ReviewReportRepository {
  const ReviewReportRepositoryImpl(this._dataSource);
  final ReviewReportRemoteDataSource _dataSource;

  @override
  Future<Result<ReviewReport>> submitReport({
    required int reviewId,
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) async {
    try {
      final dto = await _dataSource.submitReport(
        reviewId: reviewId,
        reason: reason,
        detail: detail,
        includeAiEvidence: includeAiEvidence,
        attachmentUrl: attachmentUrl,
      );
      return Success(dto.toEntity());
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

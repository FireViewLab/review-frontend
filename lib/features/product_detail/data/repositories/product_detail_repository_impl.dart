import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/product_detail/data/datasources/product_detail_remote_data_source.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/repositories/product_detail_repository.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  const ProductDetailRepositoryImpl(this._remoteDataSource);

  final ProductDetailRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ProductDetail>> getProductDetail(int productId) async {
    try {
      final dto = await _remoteDataSource.getProductDetail(productId);
      return Success(dto.toEntity());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '상품 정보를 불러오지 못했습니다.', cause: error),
      );
    }
  }

  @override
  Future<Result<List<ProductReview>>> getProductReviews(int productId) async {
    try {
      final dtos = await _remoteDataSource.getProductReviews(productId);
      return Success(dtos.map((d) => d.toEntity()).toList());
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: '리뷰를 불러오지 못했습니다.', cause: error));
    }
  }

  @override
  Future<Result<void>> submitReviewFeedback(
    int reviewId,
    String feedbackType,
  ) async {
    try {
      await _remoteDataSource.submitReviewFeedback(reviewId, feedbackType);
      return const Success(null);
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: '피드백 제출에 실패했습니다.', cause: error));
    }
  }

  @override
  Future<bool> checkAnalysisHealth() => _remoteDataSource.checkAnalysisHealth();

  @override
  Future<Result<ProductAnalysisResult>> triggerProductAnalysis(
    String productId,
  ) async {
    try {
      final dto = await _remoteDataSource.triggerProductAnalysis(productId);
      return Success(
        ProductAnalysisResult(
          analysis: dto.analysis,
          averageRti: dto.averageRti,
          safeCount: dto.safeCount,
          warnCount: dto.warnCount,
          dangerCount: dto.dangerCount,
          reviewDetails: dto.toReviewRtiDetailMap(),
          trend: dto.trend
              .map(
                (t) => AnalysisTrendPoint(
                  date: t.date,
                  averageRti: t.averageRti,
                  reviewCount: t.reviewCount,
                  safeCount: t.safeCount,
                  warnCount: t.warnCount,
                  dangerCount: t.dangerCount,
                ),
              )
              .toList(),
          realReviewRatio: dto.realReviewRatio,
          adSuspicionRatio: dto.adSuspicionRatio,
          repetitiveRatio: dto.repetitiveRatio,
          trustSignals: dto.trustSignals.map((s) => s.toEntity()).toList(),
        ),
      );
    } on ApiResponseException catch (error) {
      return FailureResult(failureFromApiResponseException(error));
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(Failure(message: 'AI 분석에 실패했습니다.', cause: error));
    }
  }
}

import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_insight.dart';
import 'package:re_view_front/features/product_detail/domain/usecases/get_product_detail_use_case.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';

class ProductDetailViewModel extends Notifier<ProductDetailState> {
  ProductDetailViewModel(this._productId);

  final int _productId;

  late final GetProductDetailUseCase _getDetail;
  late final GetProductReviewsUseCase _getReviews;
  late final SubmitReviewFeedbackUseCase _submitFeedback;
  late final CheckAnalysisHealthUseCase _checkHealth;
  late final TriggerProductAnalysisUseCase _triggerAnalysis;

  @override
  ProductDetailState build() {
    _getDetail = ref.watch(getProductDetailUseCaseProvider);
    _getReviews = ref.watch(getProductReviewsUseCaseProvider);
    _submitFeedback = ref.watch(submitReviewFeedbackUseCaseProvider);
    _checkHealth = ref.watch(checkAnalysisHealthUseCaseProvider);
    _triggerAnalysis = ref.watch(triggerProductAnalysisUseCaseProvider);
    Future.microtask(() => _load(_productId));
    return const ProductDetailLoading();
  }

  Future<void> _load(int productId) async {
    if (!ref.mounted) return;
    state = const ProductDetailLoading();

    // 서로 기다릴 필요가 없는 요청은 함께 보낸다. 분석 서버 확인도 미리 시작한다.
    final detailFuture = _getDetail(productId);
    final reviewsFuture = _getReviews(productId);
    final healthFuture = _checkHealth();

    final detailResult = await detailFuture;
    if (!ref.mounted) return;

    final detail = detailResult.when(success: (d) => d, failure: (_) => null);

    if (detail == null) {
      state = ProductDetailFailure(
        detailResult.when(
          success: (_) => const Failure(message: '알 수 없는 오류가 발생했습니다.'),
          failure: (f) => f,
        ),
      );
      return;
    }

    if (detail.externalRef != null) {
      state = ProductDetailSuccess(
        detail: detail,
        reviews: const [],
        reviewInsight: const ReviewInsight(
          keywords: [],
          satisfactionPoints: [],
          dissatisfactionPoints: [],
        ),
        similarProducts: const [],
      );
      return;
    }

    final reviewsResult = await reviewsFuture;
    if (!ref.mounted) return;

    final reviews = reviewsResult.when(
      success: (r) => r,
      failure: (_) => const <ProductReview>[],
    );

    state = ProductDetailSuccess(
      detail: detail,
      reviews: reviews,
      reviewInsight: const ReviewInsight(
        keywords: [],
        satisfactionPoints: [],
        dissatisfactionPoints: [],
      ),
      similarProducts: const [],
      isAnalyzing: detail.externalRef == null,
    );

    if (detail.externalRef == null) {
      _triggerAnalysisInBackground(productId.toString(), healthFuture);
    }
  }

  Future<void> _triggerAnalysisInBackground(
    String productId,
    Future<bool> healthFuture,
  ) async {
    final preferences = await ref
        .read(savedDisplayPreferencesProvider.future)
        .catchError((_) => null);
    if (!ref.mounted) return;
    final isHealthy =
        preferences?.allowDataAnalysis == true && await healthFuture;
    if (!ref.mounted) return;

    if (!isHealthy) {
      final current = state;
      if (current is ProductDetailSuccess) {
        state = current.copyWith(isAnalyzing: false);
      }
      return;
    }

    final analysisResult = await _triggerAnalysis(productId);
    if (!ref.mounted) return;

    final current = state;
    if (current is! ProductDetailSuccess) return;

    analysisResult.when(
      success: (analysis) {
        final enrichedReviews = current.reviews.map((review) {
          final detail = analysis.reviewDetails[review.id];
          if (detail == null) return review;
          return ProductReview(
            helpfulCount: review.helpfulCount,
            id: review.id,
            authorName: review.authorName,
            authorAvatarUrl: review.authorAvatarUrl,
            rating: review.rating,
            content: review.content,
            createdAt: review.createdAt,
            platform: review.platform,
            isVerifiedPurchase: review.isVerifiedPurchase,
            rtiScore: review.rtiScore,
            rtiColor: review.rtiColor,
            rtiLabel: review.rtiLabel,
            imageUrls: review.imageUrls,
            hashtags: review.hashtags,
            reasons: review.reasons,
            rtiDetail: detail,
          );
        }).toList();

        // Compute fallback ratios from reviews when API returns zeros
        var realRR = analysis.realReviewRatio;
        var adSR = analysis.adSuspicionRatio;
        var repR = analysis.repetitiveRatio;

        if (realRR == 0.0 && adSR == 0.0 && repR == 0.0) {
          final scored = enrichedReviews
              .where((r) => r.rtiScore != null)
              .toList();
          final total = scored.length;
          if (total > 0) {
            realRR =
                scored
                    .where((r) => r.rtiScore != null && r.rtiScore! >= 70)
                    .length /
                total *
                100;
            adSR =
                scored
                    .where(
                      (r) => r.reasons.any(
                        (s) =>
                            s.contains('광고') ||
                            s.contains('체험') ||
                            s.contains('협찬'),
                      ),
                    )
                    .length /
                total *
                100;
            repR =
                scored
                    .where(
                      (r) => r.reasons.any(
                        (s) => s.contains('반복') || s.contains('유사'),
                      ),
                    )
                    .length /
                total *
                100;
          }
        }

        if (ref.mounted) {
          state = current.copyWith(
            reviews: enrichedReviews,
            isAnalyzing: false,
            safeCount: analysis.safeCount,
            warnCount: analysis.warnCount,
            dangerCount: analysis.dangerCount,
            trend: analysis.trend,
            rtiSummary: current.detail.rtiSummary?.copyWith(
              hasReviewMetrics:
                  analysis.safeCount +
                          analysis.warnCount +
                          analysis.dangerCount >
                      0 ||
                  enrichedReviews.any((r) => r.rtiScore != null),
              realReviewRatio: realRR / 100,
              realReviewLabel: '${realRR.toStringAsFixed(1)}%',
              adSuspicionRatio: adSR / 100,
              adSuspicionLabel: '${adSR.toStringAsFixed(1)}%',
              repetitionRatio: repR / 100,
              repetitionLabel: '${repR.toStringAsFixed(1)}%',
            ),
            trustSignals: analysis.trustSignals,
          );
        }
      },
      failure: (_) {
        if (ref.mounted) {
          state = current.copyWith(isAnalyzing: false);
        }
      },
    );
  }

  Future<void> refresh() => _load(_productId);

  Future<bool> submitFeedback(int reviewId, String feedbackType) async {
    final result = await _submitFeedback(reviewId, feedbackType);
    return result.when(success: (_) => true, failure: (_) => false);
  }
}

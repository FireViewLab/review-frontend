import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/presentation/providers/product_detail_providers.dart';
import 'package:re_view_front/features/product_detail/presentation/view_models/product_detail_state.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_loading.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_error.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_content.dart';

class AnalysisReportPage extends ConsumerWidget {
  const AnalysisReportPage({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailViewModelProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1200,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xxxl,
              ),
              child: switch (state) {
                ProductDetailLoading() => const AnalysisReportSkeletonView(),
                ProductDetailFailure(:final failure) => AnalysisReportErrorView(
                  message: failure.message,
                  onRetry: () => ref
                      .read(productDetailViewModelProvider(productId).notifier)
                      .refresh(),
                ),
                ProductDetailSuccess(
                  :final detail,
                  :final reviews,
                  :final isAnalyzing,
                  :final safeCount,
                  :final warnCount,
                  :final dangerCount,
                  :final trend,
                ) =>
                  AnalysisReportContent(
                    productId: productId,
                    detail: detail,
                    reviews: reviews,
                    isAnalyzing: isAnalyzing,
                    safeCount: safeCount,
                    warnCount: warnCount,
                    dangerCount: dangerCount,
                    trend: trend,
                    onBackToProduct: () => context.goNamed(
                      RouteNames.productDetail,
                      pathParameters: {'id': productId.toString()},
                    ),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

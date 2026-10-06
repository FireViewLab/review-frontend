// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton Loading
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisReportSkeletonView extends StatelessWidget {
  const AnalysisReportSkeletonView();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    return Shimmer.fromColors(
      enabled: !MediaQuery.disableAnimationsOf(context),
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalysisReportShimmerBox(width: 160, height: 16, radius: 8),
          const SizedBox(height: AppSpacing.md),
          isNarrow
              ? Column(
                  children: [
                    AnalysisReportShimmerBox(height: 200, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    AnalysisReportShimmerBox(height: 240, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    AnalysisReportShimmerBox(height: 120, radius: AppRadius.md),
                    const SizedBox(height: AppSpacing.md),
                    AnalysisReportShimmerBox(height: 120, radius: AppRadius.md),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 58,
                      child: Column(
                        children: [
                          AnalysisReportShimmerBox(
                            height: 240,
                            radius: AppRadius.md,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AnalysisReportShimmerBox(
                            height: 280,
                            radius: AppRadius.md,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          AnalysisReportShimmerBox(
                            height: 280,
                            radius: AppRadius.md,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AnalysisReportShimmerBox(
                            height: 140,
                            radius: AppRadius.md,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AnalysisReportShimmerBox(
                            height: 140,
                            radius: AppRadius.md,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class AnalysisReportShimmerBox extends StatelessWidget {
  const AnalysisReportShimmerBox({
    this.width,
    required this.height,
    this.radius = 0,
  });
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

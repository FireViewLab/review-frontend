import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/trust_signal_card.dart';

class ProductDetailDesktopAnalysisSection extends StatelessWidget {
  const ProductDetailDesktopAnalysisSection({
    super.key,
    required this.detail,
    required this.loadedAnalysisCount,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final int loadedAnalysisCount;
  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAnalyzing) ProductDetailAnalyzingBanner(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RtiSummaryCard(
                rtiSummary: detail.rtiSummary,
                loadedAnalysisCount: loadedAnalysisCount,
                isAnalyzing: isAnalyzing,
                onDetailPressed: onDetailPressed,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 280,
              child: detail.rtiSummary == null
                  ? const SizedBox.shrink()
                  : TrustSignalCard(
                      signals: detail.trustSignals,
                      onDetailPressed: onDetailPressed,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductDetailMobileAnalysisSection extends StatelessWidget {
  const ProductDetailMobileAnalysisSection({
    super.key,
    required this.detail,
    required this.loadedAnalysisCount,
    required this.isAnalyzing,
    required this.onDetailPressed,
  });

  final int loadedAnalysisCount;
  final ProductDetail detail;
  final bool isAnalyzing;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAnalyzing) ...[
          ProductDetailAnalyzingBanner(),
          const SizedBox(height: AppSpacing.sm),
        ],
        RtiSummaryCard(
          rtiSummary: detail.rtiSummary,
          loadedAnalysisCount: loadedAnalysisCount,
          isAnalyzing: isAnalyzing,
          onDetailPressed: onDetailPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        if (detail.rtiSummary != null)
          TrustSignalCard(
            signals: detail.trustSignals,
            onDetailPressed: onDetailPressed,
          ),
      ],
    );
  }
}

class ProductDetailAnalyzingBanner extends StatefulWidget {
  const ProductDetailAnalyzingBanner({super.key});

  @override
  State<ProductDetailAnalyzingBanner> createState() => _AnalyzingBannerState();
}

class _AnalyzingBannerState extends State<ProductDetailAnalyzingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.09 + _pulse.value * 0.04),
                AppColors.primary.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: AppRadius.medium,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.1 + _pulse.value * 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: TickerMode(
                  enabled: !MediaQuery.disableAnimationsOf(context),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 리뷰 분석 진행 중',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Re:view AI가 리뷰를 실시간 분석하고 있습니다. 완료 후 신뢰도 점수가 자동으로 업데이트됩니다.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

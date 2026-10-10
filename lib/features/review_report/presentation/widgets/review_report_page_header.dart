import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class ReviewReportPageHeader extends StatelessWidget {
  const ReviewReportPageHeader({
    super.key,
    required this.onViewFeedback,
    this.onBreadcrumbHome,
    this.onBreadcrumbReport,
  });

  final VoidCallback onViewFeedback;
  final VoidCallback? onBreadcrumbHome;
  final VoidCallback? onBreadcrumbReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Breadcrumb(onHome: onBreadcrumbHome, onReport: onBreadcrumbReport),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '리뷰 신고 접수',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '의심 리뷰의 문제 유형과 근거를 남겨주세요. 제출된 신고는 운영 검수와 모델 개선 피드백에 함께 활용됩니다.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            OutlinedButton(
              onPressed: onViewFeedback,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderStrong),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '내 피드백 내역 보기',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({this.onHome, this.onReport});

  final VoidCallback? onHome;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.textTertiary,
      fontSize: 12,
    );
    final divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text('›', style: style),
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _BreadcrumbLink(label: '홈', onTap: onHome, style: style),
        divider,
        _BreadcrumbLink(label: '리포트', onTap: onReport, style: style),
        divider,
        Text(
          '리뷰 신고 접수',
          style: style?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BreadcrumbLink extends StatelessWidget {
  const _BreadcrumbLink({
    required this.label,
    required this.onTap,
    required this.style,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(label, style: style),
      ),
    );
  }
}

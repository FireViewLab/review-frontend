import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/notifications/presentation/widgets/notification_settings_summary.dart';
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageTrustSummaryPanel extends ConsumerWidget {
  const MyPageTrustSummaryPanel({
    required this.savedAverageRti,
    required this.riskyCount,
  });

  final double? savedAverageRti;
  final int? riskyCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = savedAverageRti?.clamp(0, 100).toDouble();
    final scoreText = score == null ? '-' : '${score.round()}점';

    return MyPagePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyPagePanelTitle(
            title: AppLocalizations.of(context).myPageReviewTrustSummary,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).myPageAvgRti,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                scoreText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: score == null ? 0 : score / 100,
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            score == null
                ? AppLocalizations.of(context).myPageRtiSaveHint
                : riskyCount == null
                ? '찜 상품의 분석 정보를 확인할 수 없어요.'
                : riskyCount == 0
                ? AppLocalizations.of(context).myPageRiskyNone
                : AppLocalizations.of(context).myPageRiskyCount(riskyCount!),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text('찜한 상품 중 분석된 RTI의 평균과 서버 주의 등급 기준입니다.'),
          const Divider(color: AppColors.border),
          const NotificationSettingsSummary(entryOnly: true),
        ],
      ),
    );
  }
}

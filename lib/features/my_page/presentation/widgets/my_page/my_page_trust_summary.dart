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
    this.savedAveragePolicyIndex,
    this.hasPolicyProducts = false,
    required this.riskyCount,
  });

  final double? savedAverageRti;
  final double? savedAveragePolicyIndex;
  final bool hasPolicyProducts;
  final int? riskyCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final policyOnly = hasPolicyProducts && savedAverageRti == null;
    final score = (policyOnly ? savedAveragePolicyIndex : savedAverageRti)
        ?.clamp(0, 100)
        .toDouble();
    final scoreText = score == null
        ? '-'
        : AppLocalizations.of(context).myPageTrustScorePoints(score.round());

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
                  policyOnly ? l.analysisPolicyAverage : l.myPageAvgRti,
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
          if (hasPolicyProducts && !policyOnly) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: Text(l.analysisPolicyAverage)),
                Text(
                  savedAveragePolicyIndex == null
                      ? l.analysisNotCalculable
                      : savedAveragePolicyIndex!.toStringAsFixed(1),
                ),
              ],
            ),
          ],
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
                ? (policyOnly ? l.analysisNotCalculable : l.myPageRtiSaveHint)
                : riskyCount == null
                ? AppLocalizations.of(context).myPageTrustUnavailable
                : riskyCount == 0
                ? AppLocalizations.of(context).myPageRiskyNone
                : AppLocalizations.of(context).myPageRiskyCount(riskyCount!),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            hasPolicyProducts
                ? l.analysisSeparateContracts
                : AppLocalizations.of(context).myPageTrustScope,
          ),
          const Divider(color: AppColors.border),
          const NotificationSettingsSummary(entryOnly: true),
        ],
      ),
    );
  }
}

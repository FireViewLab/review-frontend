import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

/// KPI 카드의 증감 추세. 델타 배지의 화살표/색상을 결정한다.
enum AdminKpiTrend { up, down, neutral }

class AdminKpiCard extends StatelessWidget {
  const AdminKpiCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.helper,
    this.deltaLabel,
    this.trend = AdminKpiTrend.neutral,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? helper;

  /// 증감 수치 텍스트 (예: '12.4%'). null이면 델타 배지를 그리지 않는다.
  final String? deltaLabel;
  final AdminKpiTrend trend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          if (deltaLabel != null || helper != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                if (deltaLabel != null) ...[
                  Icon(_trendIcon, size: 14, color: _trendColor),
                  const SizedBox(width: 2),
                  Text(
                    deltaLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _trendColor,
                    ),
                  ),
                  if (helper != null) const SizedBox(width: AppSpacing.xs),
                ],
                if (helper != null)
                  Flexible(
                    child: Text(
                      helper!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData get _trendIcon => switch (trend) {
        AdminKpiTrend.up => Icons.arrow_drop_up_rounded,
        AdminKpiTrend.down => Icons.arrow_drop_down_rounded,
        AdminKpiTrend.neutral => Icons.remove_rounded,
      };

  Color get _trendColor => switch (trend) {
        AdminKpiTrend.up => AppColors.success,
        AdminKpiTrend.down => AppColors.error,
        AdminKpiTrend.neutral => AppColors.textTertiary,
      };
}

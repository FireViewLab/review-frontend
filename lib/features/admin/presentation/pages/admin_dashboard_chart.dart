import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'admin_dashboard_card.dart';

class AdminDashboardTrendCard extends StatelessWidget {
  const AdminDashboardTrendCard({
    super.key,
    required this.trend,
    required this.days,
  });

  final List<DailyRtiTrend> trend;
  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminDashboardCard(
      title: l10n.adminDailyTrendTitle(days),
      child: trend.isEmpty
          ? SizedBox(
              height: 160,
              child: Center(
                child: Text(
                  l10n.adminTrendEmpty,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          : AdminDashboardTrendChart(trend: trend),
    );
  }
}

/// 막대 높이는 평균 RTI(0~100), 막대 위 숫자는 분석 건수다.
class AdminDashboardTrendChart extends StatelessWidget {
  const AdminDashboardTrendChart({super.key, required this.trend});

  final List<DailyRtiTrend> trend;

  static const double _chartHeight = 160;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 막대가 많으면 날짜 라벨을 건너뛰어 겹치지 않게 한다.
    final labelEvery = (trend.length / 10).ceil().clamp(1, 30);
    return SizedBox(
      height: _chartHeight + 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (index, point) in trend.indexed)
            Expanded(
              child: Tooltip(
                message: l10n.adminTrendTooltip(
                  formatAdminDate(point.date),
                  point.averageRti.toStringAsFixed(1),
                  formatAdminCount(point.reviewCount),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height:
                            (point.averageRti / 100).clamp(0.02, 1.0) *
                            _chartHeight,
                        decoration: BoxDecoration(
                          color: _barColor(point.averageRti),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.xs),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      SizedBox(
                        height: 16,
                        child: index % labelEvery == 0
                            ? FittedBox(
                                child: Text(
                                  '${point.date.month}/${point.date.day}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// RTI 등급 색 (안전 70 이상, 의심 40 이상, 그 아래 위험).
  Color _barColor(double rti) {
    if (rti >= 70) return AppColors.success;
    if (rti >= 40) return AppColors.warning;
    return AppColors.error;
  }
}

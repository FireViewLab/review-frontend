import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';

/// 서버가 내려주는 상품 기본 정보. 값이 없는 항목은 표시하지 않는다.
class ProductDetailInfoTable extends StatelessWidget {
  const ProductDetailInfoTable({super.key, required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final category = detail.breadcrumbs.isNotEmpty
        ? detail.breadcrumbs.join(' > ')
        : detail.categoryDisplayName;
    final rows = <(String, String)>[
      (AppLocalizations.of(context).adminProductName, detail.name),
      if (detail.brand.isNotEmpty)
        (AppLocalizations.of(context).detailBrand, detail.brand),
      if (category.isNotEmpty)
        (AppLocalizations.of(context).wishlistFilterCategory, category),
      if (detail.price > 0)
        (
          AppLocalizations.of(context).detailLowestPrice,
          AppLocalizations.of(
            context,
          ).extProductPrice(_formatWon(detail.price)),
        ),
      if (detail.totalSellerCount > 0)
        (
          AppLocalizations.of(context).searchFilterSeller,
          AppLocalizations.of(
            context,
          ).detailSellerCount(detail.totalSellerCount),
        ),
      if (detail.avgRating != null)
        if ((detail.reviewCount ?? 0) > 0)
          (
            AppLocalizations.of(context).detailAverageRating,
            AppLocalizations.of(context).detailRatingReviewCount(
              detail.avgRating!.toStringAsFixed(1),
              _formatWon(detail.reviewCount ?? 0),
            ),
          ),
      if (detail.analysisDisplay.isV2)
        (
          detail.analysisDisplay.scoreName(context),
          detail.analysisDisplay.badgeText(context),
        )
      else if (detail.analysisDisplay.score != null)
        (
          'RTI',
          (detail.rtiGrade?.isEmpty ?? true)
              ? detail.analysisDisplay.score!.toStringAsFixed(1)
              : '${detail.analysisDisplay.score!.toStringAsFixed(1)} · '
                    '${_gradeLabel(context, detail.rtiGrade!)}',
        ),
      if (detail.deliveryInfo?.isNotEmpty ?? false)
        (AppLocalizations.of(context).detailShipping, detail.deliveryInfo!),
    ];
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final (index, (label, value)) in rows.indexed) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _gradeLabel(BuildContext context, String grade) =>
      switch (grade) {
        'SAFE' => AppLocalizations.of(context).adminSafe,
        'SUSPICIOUS' => AppLocalizations.of(context).adminSuspicious,
        'DANGER' => AppLocalizations.of(context).adminDanger,
        _ => grade,
      };

  static String _formatWon(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

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
      ('상품명', detail.name),
      if (detail.brand.isNotEmpty) ('브랜드', detail.brand),
      if (category.isNotEmpty) ('카테고리', category),
      if (detail.price > 0) ('최저가', '${_formatWon(detail.price)}원'),
      if (detail.totalSellerCount > 0) ('판매처', '${detail.totalSellerCount}곳'),
      if (detail.avgRating != null)
        (
          '평균 별점',
          '${detail.avgRating!.toStringAsFixed(1)} '
              '(리뷰 ${_formatWon(detail.reviewCount ?? 0)}개)',
        ),
      if (detail.avgRti != null)
        (
          'RTI',
          (detail.rtiGrade?.isEmpty ?? true)
              ? detail.avgRti!.toStringAsFixed(1)
              : '${detail.avgRti!.toStringAsFixed(1)} · '
                    '${_gradeLabel(detail.rtiGrade!)}',
        ),
      if (detail.deliveryInfo?.isNotEmpty ?? false)
        ('배송', detail.deliveryInfo!),
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

  static String _gradeLabel(String grade) => switch (grade) {
    'SAFE' => '안전',
    'SUSPICIOUS' => '의심',
    'DANGER' => '위험',
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

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final rtiColor = colorFromHex(detail.rtiColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (detail.sellerName != null && detail.sellerName!.isNotEmpty)
              Text(
                detail.sellerName!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (detail.isOfficialSeller) ...[
              const SizedBox(width: AppSpacing.xs),
              _OfficialBadge(),
            ],
            const Spacer(),
            detail.avgRti == null
                ? const Text('분석 전')
                : _RtiBadgeLarge(
                    score: detail.avgRti!.round(),
                    color: rtiColor,
                  ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          detail.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _RatingRow(detail: detail),
        const SizedBox(height: AppSpacing.md),
        _PriceRow(detail: detail),
      ],
    );
  }
}

class _OfficialBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        child: Text(
          '공식 판매처',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _RtiBadgeLarge extends StatelessWidget {
  const _RtiBadgeLarge({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = _rtiLabel(score);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            'RTI $score',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Container(width: 1, height: 11, color: color.withValues(alpha: 0.3)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (detail.avgRating != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 5; i++)
                Icon(
                  i < detail.avgRating!.floor()
                      ? Icons.star
                      : (i < detail.avgRating!
                            ? Icons.star_half
                            : Icons.star_border),
                  color: const Color(0xFFF59E0B),
                  size: 16,
                ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                detail.avgRating!.toStringAsFixed(1),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        if (detail.reviewCount != null)
          Text(
            '리뷰 ${formatSearchCount(detail.reviewCount)}개',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatSearchPrice(detail.price),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        if (detail.deliveryInfo != null && detail.deliveryInfo!.isNotEmpty)
          Text(
            detail.deliveryInfo!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class ProductSpecChips extends StatelessWidget {
  const ProductSpecChips({super.key, required this.chips});

  final List<ProductSpecChip> chips;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: chips.map((chip) => _SpecChipItem(chip: chip)).toList(),
    );
  }
}

class ProductSpecChipsStrip extends StatelessWidget {
  const ProductSpecChipsStrip({super.key, required this.chips});

  final List<ProductSpecChip> chips;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < chips.length; i++) ...[
              if (i > 0) Container(width: 1, color: AppColors.border),
              Expanded(child: _SpecChipStripItem(chip: chips[i])),
            ],
          ],
        ),
      ),
    );
  }
}

String _rtiLabel(int score) {
  if (score >= 80) return '리뷰 신뢰도 높음';
  if (score >= 60) return '리뷰 신뢰도 보통';
  return '리뷰 신뢰도 낮음';
}

IconData _iconDataFor(String tag) => switch (tag) {
  'noise' => Icons.hearing_disabled_outlined,
  'bluetooth' => Icons.bluetooth,
  'water' => Icons.water_drop_outlined,
  'call' => Icons.call_outlined,
  'battery' => Icons.battery_charging_full_outlined,
  'earphone' => Icons.headset_outlined,
  'weight' => Icons.scale_outlined,
  _ => Icons.check_circle_outline,
};

class _SpecChipItem extends StatelessWidget {
  const _SpecChipItem({required this.chip});

  final ProductSpecChip chip;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconDataFor(chip.iconData),
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chip.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                if (chip.subtitle.isNotEmpty)
                  Text(
                    chip.subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecChipStripItem extends StatelessWidget {
  const _SpecChipStripItem({required this.chip});

  final ProductSpecChip chip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _iconDataFor(chip.iconData),
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chip.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                if (chip.subtitle.isNotEmpty)
                  Text(
                    chip.subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

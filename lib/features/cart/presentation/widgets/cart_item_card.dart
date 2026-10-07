import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_item.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/features/search/presentation/widgets/search_product_card.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isUpdating,
    required this.onToggleSelect,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onMoveToWishlist,
    required this.onSaveForLater,
  });

  final CartItem item;
  final bool isSelected;
  final bool isUpdating;
  final VoidCallback onToggleSelect;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onMoveToWishlist;
  final VoidCallback onSaveForLater;

  @override
  Widget build(BuildContext context) {
    final rtiColor = item.rtiColor == null
        ? AppColors.textTertiary
        : colorFromHex(item.rtiColor!);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryLight.withValues(alpha: 0.4)
            : AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Checkbox(isSelected: isSelected, onTap: onToggleSelect),
            const SizedBox(width: AppSpacing.sm),
            _ProductImage(item: item),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: isMobile
                  ? _MobileContent(
                      item: item,
                      rtiColor: rtiColor,
                      isUpdating: isUpdating,
                      onQuantityChanged: onQuantityChanged,
                      onRemove: onRemove,
                      onMoveToWishlist: onMoveToWishlist,
                      onSaveForLater: onSaveForLater,
                    )
                  : _DesktopContent(
                      item: item,
                      rtiColor: rtiColor,
                      isUpdating: isUpdating,
                      onQuantityChanged: onQuantityChanged,
                      onRemove: onRemove,
                      onMoveToWishlist: onMoveToWishlist,
                      onSaveForLater: onSaveForLater,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 24,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderStrong,
              width: 1.5,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, color: AppColors.onPrimary, size: 16)
              : null,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(url: item.imageUrl),
            ),
          ),
          if (item.badge != null)
            Positioned(
              top: AppSpacing.xxs,
              left: AppSpacing.xxs,
              child: _BadgeChip(label: item.badge!),
            ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isReview = label.contains('Re:view') || label.contains('추천');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isReview ? AppColors.primary : const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.item, required this.rtiColor});

  final CartItem item;
  final Color rtiColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.platform != null)
          Text(
            item.platform!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        const SizedBox(height: 2),
        InkWell(
          onTap: () => context.go(item.detailPath, extra: item.routeContext),
          child: Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ),
        if (item.variant != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          _VariantChip(label: item.variant!),
        ],
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            if (item.avgRti == null)
              Text(AppLocalizations.of(context).externalUnanalyzed)
            else
              RtiBadge(value: item.avgRti!.round(), color: rtiColor),
            const SizedBox(width: AppSpacing.xs),
            if (item.avgRti != null &&
                item.rtiGrade != null &&
                item.rtiColor != null)
              Text(
                '신뢰도 ${item.trustLevel}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          item.price == null ? '가격 정보 없음' : formatSearchPrice(item.price!),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        if (item.priceDropAmount != null && item.priceDropAmount! > 0) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_downward,
                color: AppColors.error,
                size: 12,
              ),
              Text(
                '${formatSearchPrice(item.priceDropAmount!)} 인하',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.maxQuantity,
    required this.isUpdating,
    required this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final bool isUpdating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (isUpdating) {
      return const SizedBox(
        width: 88,
        height: 32,
        child: Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            width: 36,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.borderStrong),
              ),
            ),
            child: Text(
              '$quantity',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          _QtyButton(
            icon: Icons.add,
            onPressed: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        color: onPressed == null
            ? AppColors.textTertiary
            : AppColors.textPrimary,
      ),
    );
  }
}

class _ShippingInfo extends StatelessWidget {
  const _ShippingInfo({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(
                  item.isFreeShipping
                      ? '무료배송'
                      : '${formatSearchPrice(item.shippingFee)} 배송',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (item.estimatedDelivery != null) ...[
          const SizedBox(height: 2),
          Text(
            '${item.estimatedDelivery} 도착 예정',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
        if (item.isLowStock) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                '재고 ${item.stockCount}개 남음',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ItemActions extends StatelessWidget {
  const _ItemActions({
    required this.onSaveForLater,
    required this.onMoveToWishlist,
    required this.onRemove,
  });

  final VoidCallback onSaveForLater;
  final VoidCallback onMoveToWishlist;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: Icons.bookmark_border,
          label: '나중에 담기',
          onTap: onSaveForLater,
        ),
        _ActionButton(
          icon: Icons.favorite_border,
          label: '찜하기',
          onTap: onMoveToWishlist,
        ),
        _ActionButton(icon: Icons.delete_outline, label: '삭제', onTap: onRemove),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent({
    required this.item,
    required this.rtiColor,
    required this.isUpdating,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onMoveToWishlist,
    required this.onSaveForLater,
  });

  final CartItem item;
  final Color rtiColor;
  final bool isUpdating;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onMoveToWishlist;
  final VoidCallback onSaveForLater;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _ProductInfo(item: item, rtiColor: rtiColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _PriceSection(item: item),
            const SizedBox(height: AppSpacing.xs),
            _QuantitySelector(
              quantity: item.quantity,
              maxQuantity: item.maxQuantity,
              isUpdating: isUpdating,
              onChanged: onQuantityChanged,
            ),
            const SizedBox(height: AppSpacing.xs),
            _ShippingInfo(item: item),
            const SizedBox(height: AppSpacing.xs),
            _ItemActions(
              onSaveForLater: onSaveForLater,
              onMoveToWishlist: onMoveToWishlist,
              onRemove: onRemove,
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent({
    required this.item,
    required this.rtiColor,
    required this.isUpdating,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onMoveToWishlist,
    required this.onSaveForLater,
  });

  final CartItem item;
  final Color rtiColor;
  final bool isUpdating;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onMoveToWishlist;
  final VoidCallback onSaveForLater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductInfo(item: item, rtiColor: rtiColor),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _PriceSection(item: item),
            const Spacer(),
            _QuantitySelector(
              quantity: item.quantity,
              maxQuantity: item.maxQuantity,
              isUpdating: isUpdating,
              onChanged: onQuantityChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _ShippingInfo(item: item),
        const SizedBox(height: AppSpacing.xs),
        _ItemActions(
          onSaveForLater: onSaveForLater,
          onMoveToWishlist: onMoveToWishlist,
          onRemove: onRemove,
        ),
      ],
    );
  }
}

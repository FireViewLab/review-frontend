import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';

class CartOrderSummary extends StatelessWidget {
  const CartOrderSummary({
    super.key,
    required this.summary,
    required this.selectedCount,
    required this.onCheckout,
    required this.onContinueShopping,
    this.hasUnknownPrice = false,
    this.isUpdating = false,
  });
  final CartSummary summary;
  final int selectedCount;
  final Future<void> Function() onCheckout;
  final VoidCallback onContinueShopping;
  final bool hasUnknownPrice;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('선택 상품 요약', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$selectedCount개 · ${formatSearchPrice(summary.totalProductPrice)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (hasUnknownPrice) const Text('가격 정보가 없는 상품은 합계에서 제외했어요.'),
          const SizedBox(height: AppSpacing.sm),
          const Text('표시 가격은 참고용입니다. 구매와 배송비·쿠폰 확인은 각 쇼핑몰에서 진행해 주세요.'),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: selectedCount > 0 && !isUpdating ? onCheckout : null,
            icon: const Icon(Icons.open_in_new),
            label: const Text('선택 상품 구매처 확인'),
          ),
          TextButton(
            onPressed: onContinueShopping,
            child: const Text('쇼핑 계속하기'),
          ),
        ],
      ),
    ),
  );
}

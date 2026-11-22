import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/cart/domain/entities/cart_summary.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';

class CartOrderSummary extends StatelessWidget {
  const CartOrderSummary({
    super.key,
    required this.summary,
    required this.selectedCount,
    required this.onCheckout,
    required this.onContinueShopping,
    required this.onTestCheckout,
    this.hasUnknownPrice = false,
    this.isUpdating = false,
  });
  final CartSummary summary;
  final int selectedCount;
  final Future<void> Function() onCheckout;
  final VoidCallback onContinueShopping;
  final VoidCallback onTestCheckout;
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
          Text(
            AppLocalizations.of(context).cartSelectionSummary,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context).paymentCheckoutQuantity(
              selectedCount,
              formatSearchPrice(summary.totalProductPrice),
            ),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (hasUnknownPrice)
            Text(AppLocalizations.of(context).cartUnknownPriceExcluded),
          const SizedBox(height: AppSpacing.sm),
          Text(AppLocalizations.of(context).cartReferencePriceNotice),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: selectedCount > 0 && !isUpdating ? onCheckout : null,
            icon: const Icon(Icons.open_in_new),
            label: Text(AppLocalizations.of(context).cartViewSelectedSellers),
          ),
          OutlinedButton(
            onPressed: selectedCount > 0 && !isUpdating ? onTestCheckout : null,
            child: Text(AppLocalizations.of(context).paymentCheckoutTitle),
          ),
          TextButton(
            onPressed: onContinueShopping,
            child: Text(AppLocalizations.of(context).cartContinueShopping),
          ),
        ],
      ),
    ),
  );
}

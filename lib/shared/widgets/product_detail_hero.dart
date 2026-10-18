import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

/// Presentation only: keeps gallery and commerce callbacks owned by each feature.
class ProductDetailHero extends StatelessWidget {
  const ProductDetailHero({
    super.key,
    required this.gallery,
    required this.information,
  });
  final Widget gallery;
  final Widget information;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          constraints.maxWidth < 760 ||
          MediaQuery.textScalerOf(context).scale(16) > 24;
      final info = Padding(
        padding: EdgeInsets.symmetric(vertical: stacked ? 0 : AppSpacing.sm),
        child: information,
      );
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: gallery,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            info,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: gallery),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(flex: 5, child: info),
        ],
      );
    },
  );
}

/// Subtle commerce boundary, separate from the RTI report presentation.
class ProductPurchaseArea extends StatelessWidget {
  const ProductPurchaseArea({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: AppSpacing.lg),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: child,
  );
}

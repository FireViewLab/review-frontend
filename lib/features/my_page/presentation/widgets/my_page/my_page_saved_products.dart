// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';

class MyPageSavedProductsSection extends StatelessWidget {
  const MyPageSavedProductsSection({
    required this.items,
    required this.isLoading,
    required this.onProductTap,
  });

  final List<WishlistItem> items;
  final bool isLoading;
  final ValueChanged<WishlistItem> onProductTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 180,
        child: AppLoadingView(
          message: AppLocalizations.of(context).myPageWishlistLoading,
        ),
      );
    }

    if (items.isEmpty) {
      return MyPageEmptyPanel(
        icon: Icons.favorite_border,
        message: AppLocalizations.of(context).myPageWishlistEmpty,
      );
    }

    final displayItems = items.take(4).toList(growable: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 600
            ? 1
            : constraints.maxWidth < 1000
            ? 2
            : 4;
        final width =
            (constraints.maxWidth - (columns - 1) * AppSpacing.md) / columns;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final item in displayItems)
              SizedBox(width: width, child: _card(context, item)),
          ],
        );
      },
    );
  }

  Widget _card(BuildContext context, WishlistItem item) {
    return MyPageCompactProductCard(
      title: item.name,
      subtitle:
          item.platform ??
          item.categoryDisplayName ??
          AppLocalizations.of(context).externalUnanalyzed,
      imageUrl: item.imageUrl,
      price: item.price,
      rating: item.avgRating,
      reviewCount: item.reviewCount,
      rtiLabel: item.avgRti == null
          ? AppLocalizations.of(context).externalUnanalyzed
          : 'RTI ${item.avgRti!.round()}',
      onTap: () => onProductTap(item),
    );
  }
}

class MyPageCompactProductCard extends StatelessWidget {
  const MyPageCompactProductCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.rtiLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final int? price;
  final double? rating;
  final int? reviewCount;
  final String rtiLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MyPagePanel(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
              dimension: 96,
              child: AppNetworkImage(url: imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  price == null ? '가격 정보 없음' : myPageFormatPrice(price!),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (rating != null)
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 14,
                      ),
                    if (rating != null || reviewCount != null)
                      Text(
                        '${rating?.toStringAsFixed(1) ?? ""}${reviewCount == null ? "" : " ($reviewCount)"}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (rtiLabel.isNotEmpty)
                      Text(
                        rtiLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/features/home/presentation/widgets/home_header/home_header_category_assets.dart';

class HomeHeaderPopularCategoryAndPickPreview extends StatelessWidget {
  const HomeHeaderPopularCategoryAndPickPreview({
    required this.products,
    required this.onCategorySelected,
  });

  final List<HomeProductData> products;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = productCategoryTree.take(5).toList(growable: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지금 인기 카테고리',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (final category in categories)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onCategorySelected(category.label),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: HomeHeaderCategoryAssetImage(
                          assetPath: homeHeaderCategoryAssetPath(category.id),
                          width: 46,
                          height: 46,
                          scale: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        category.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Text(
              '카테고리 추천 PICK',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in _pickItems.take(4)) ...[
                Expanded(
                  child: HomeHeaderCategoryPickCard(
                    item: item,
                    onTap: () => onCategorySelected(item.searchLabel),
                  ),
                ),
                if (item != _pickItems.take(4).last)
                  const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<HomeHeaderCategoryPickItem> get _pickItems {
    if (products.isNotEmpty) {
      return [
        for (final product in products.take(4))
          HomeHeaderCategoryPickItem.product(product),
      ];
    }

    return const [
      HomeHeaderCategoryPickItem.fallback(
        title: '애플 에어팟 프로 2세대',
        categoryLabel: '디지털/가전',
        assetPath:
            'assets/images/categories/category_images/68_digital_video_audio_earphones.webp',
        priceLabel: '359,000원',
        ratingLabel: '4.8',
        rtiLabel: 'RTI 91',
      ),
      HomeHeaderCategoryPickItem.fallback(
        title: '딥티 미스트 토너',
        categoryLabel: '뷰티',
        assetPath:
            'assets/images/categories/category_images/54_beauty_makeup_lipstick_blush.webp',
        priceLabel: '28,000원',
        ratingLabel: '4.9',
        rtiLabel: 'RTI 89',
      ),
      HomeHeaderCategoryPickItem.fallback(
        title: '동원참치 150g 10캔',
        categoryLabel: '식품',
        assetPath:
            'assets/images/categories/category_images/69_food_processed_ramen.webp',
        priceLabel: '28,000원',
        ratingLabel: '4.7',
        rtiLabel: 'RTI 90',
      ),
      HomeHeaderCategoryPickItem.fallback(
        title: '다이슨 V15 청소기',
        categoryLabel: '생활/주방',
        assetPath:
            'assets/images/categories/category_images/44_digital_life_appliance_air_purifier.webp',
        priceLabel: '159,000원',
        ratingLabel: '4.6',
        rtiLabel: 'RTI 92',
      ),
    ];
  }
}

class HomeHeaderCategoryPickCard extends StatelessWidget {
  const HomeHeaderCategoryPickCard({required this.item, required this.onTap});

  final HomeHeaderCategoryPickItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.categoryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: item.usesNetworkImage
                        ? AppNetworkImage(
                            url: item.imageUrl,
                            fit: BoxFit.contain,
                            placeholderIcon: Icons.inventory_2_outlined,
                            iconSize: 26,
                          )
                        : HomeHeaderCategoryAssetImage(
                            assetPath: item.imageUrl,
                            scale: 1.25,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      item.ratingLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    item.rtiLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeaderCategoryPickItem {
  const HomeHeaderCategoryPickItem({
    required this.title,
    required this.categoryLabel,
    required this.imageUrl,
    required this.priceLabel,
    required this.ratingLabel,
    required this.rtiLabel,
    required this.searchLabel,
  });

  factory HomeHeaderCategoryPickItem.product(HomeProductData product) {
    return HomeHeaderCategoryPickItem(
      title: product.name,
      categoryLabel: product.label.isEmpty ? '추천' : product.label,
      imageUrl: product.imageUrl.isEmpty
          ? _fallbackAssetPathForProduct(product)
          : product.imageUrl,
      priceLabel: product.priceLabel,
      ratingLabel: product.ratingLabel,
      rtiLabel: product.rtiLabel,
      searchLabel: product.name,
    );
  }

  const factory HomeHeaderCategoryPickItem.fallback({
    required String title,
    required String categoryLabel,
    required String assetPath,
    required String priceLabel,
    required String ratingLabel,
    required String rtiLabel,
  }) = HomeHeaderFallbackCategoryPickItem;

  final String title;
  final String categoryLabel;
  final String imageUrl;
  final String priceLabel;
  final String ratingLabel;
  final String rtiLabel;
  final String searchLabel;

  bool get usesNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
}

class HomeHeaderFallbackCategoryPickItem extends HomeHeaderCategoryPickItem {
  const HomeHeaderFallbackCategoryPickItem({
    required super.title,
    required super.categoryLabel,
    required String assetPath,
    required super.priceLabel,
    required super.ratingLabel,
    required super.rtiLabel,
  }) : super(imageUrl: assetPath, searchLabel: title);
}

String _fallbackAssetPathForProduct(HomeProductData product) {
  final resolved = resolveProductCategory(
    product.label,
    displayName: product.label,
    productName: product.name,
  );
  return homeHeaderCategoryAssetPath(resolved?.id ?? '') ??
      'assets/images/categories/category_images/58_digital_mobile_tablet_camera.webp';
}

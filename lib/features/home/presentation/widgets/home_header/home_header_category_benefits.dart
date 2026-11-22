import 'package:re_view_front/l10n/generated/app_localizations.dart';
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';

List<String> _defaultBenefitLabels(AppLocalizations l10n) => [
  l10n.homeCategoryBenefitReviewBased,
  l10n.homeCategoryBenefitRtiRanking,
  l10n.homeCategoryBenefitFastShippingProducts,
  l10n.homeCategoryBenefitAllOffers,
];

Map<String, List<String>> _categoryBenefitLabels(AppLocalizations l10n) => {
  'digital-appliance': [
    l10n.homeCategoryBenefitReviewBased,
    l10n.homeCategoryBenefitRtiRanking,
    l10n.homeCategoryBenefitFastShippingProducts,
    l10n.homeCategoryBenefitAllOffers,
  ],
  'fashion-clothing': [
    l10n.homeCategoryBenefitSize,
    l10n.homeCategoryBenefitStyle,
    l10n.homeCategoryBenefitGenderDeals,
    l10n.homeCategoryBenefitGifts,
  ],
  'fashion-accessory': [
    l10n.homeCategoryBenefitAuthenticityCheck,
    l10n.homeCategoryBenefitBrandEvents,
    l10n.homeCategoryBenefitGiftWrapping,
    l10n.homeCategoryBenefitFreeReturns,
  ],
  'beauty': [
    l10n.homeCategoryBenefitIngredients,
    l10n.homeCategoryBenefitSkinType,
    l10n.homeCategoryBenefitReviewRanking,
    l10n.homeCategoryBenefitSamples,
  ],
  'food': [
    l10n.homeCategoryBenefitDawnDelivery,
    l10n.homeCategoryBenefitBulkDiscount,
    l10n.homeCategoryBenefitReviewFavorites,
    l10n.homeCategoryBenefitSubscriptions,
  ],
  'living-kitchen': [
    l10n.homeCategoryBenefitTodayDeals,
    l10n.homeCategoryBenefitHousewarming,
    l10n.homeCategoryBenefitReviewRanking,
    l10n.homeCategoryBenefitFastShipping,
  ],
  'furniture-interior': [
    l10n.homeCategoryBenefitByRoom,
    l10n.homeCategoryBenefitPopularInteriors,
    l10n.homeCategoryBenefitInstallation,
    l10n.homeCategoryBenefitSeasonalDecor,
  ],
  'sports-leisure': [
    l10n.homeCategoryBenefitBeginners,
    l10n.homeCategoryBenefitTopGear,
    l10n.homeCategoryBenefitSeasonalOutdoors,
    l10n.homeCategoryBenefitQuickCompare,
  ],
  'car-tools': [
    l10n.homeCategoryBenefitCarCare,
    l10n.homeCategoryBenefitMaintenance,
    l10n.homeCategoryBenefitBrandDeals,
    l10n.homeCategoryBenefitSafetyGear,
  ],
  'baby-kids': [
    l10n.homeCategoryBenefitParenting,
    l10n.homeCategoryBenefitByAge,
    l10n.homeCategoryBenefitSafetyCertification,
    l10n.homeCategoryBenefitSpecialOffers,
  ],
  'pet': [
    l10n.homeCategoryBenefitPopularTreats,
    l10n.homeCategoryBenefitSubscriptions,
    l10n.homeCategoryBenefitVetPicks,
    l10n.homeCategoryBenefitPetPersonalized,
  ],
  'book-stationery-hobby': [
    l10n.homeCategoryBenefitMerchandiserPicks,
    l10n.homeCategoryBenefitPreorders,
    l10n.homeCategoryBenefitLimitedMerch,
    l10n.homeCategoryBenefitBestsellers,
  ],
  'travel-service': [
    l10n.homeCategoryBenefitTravelChecklist,
    l10n.homeCategoryBenefitPopularStays,
    l10n.homeCategoryBenefitDiscountTickets,
    l10n.homeCategoryBenefitSubscriptionOffers,
  ],
  'luxury-brand': [
    l10n.homeCategoryBenefitAuthenticityGuarantee,
    l10n.homeCategoryBenefitBrandWeek,
    l10n.homeCategoryBenefitPremiumOffers,
    l10n.homeCategoryBenefitExclusiveOffers,
  ],
};

class HomeHeaderCategoryBenefitStrip extends StatelessWidget {
  const HomeHeaderCategoryBenefitStrip({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items =
        _categoryBenefitLabels(l10n)[category.id] ??
        _defaultBenefitLabels(l10n);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC7D7FE)),
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

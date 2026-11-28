import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';

/// 카탈로그가 직접 조회할 수 있는 카테고리 코드.
const _catalogCodes = {
  'digital-appliance': 'DIGITAL',
  'mobile-tablet': 'DIGITAL_MOBILE',
  'pc-peripheral': 'DIGITAL_PC',
  'video-audio': 'DIGITAL_AV',
  'living-appliance': 'DIGITAL_HOME_APPLIANCE',
  'kitchen-appliance': 'DIGITAL_KITCHEN',
  'fashion-clothing': 'FASHION_CLOTHES',
  'women-clothing': 'FASHION_WOMEN',
  'men-clothing': 'FASHION_MEN',
  'underwear-homewear': 'FASHION_UNDERWEAR',
  'sports-clothing': 'FASHION_SPORTS',
  'fashion-accessory': 'FASHION_ACCESSORIES',
  'shoes': 'ACC_SHOES',
  'bags': 'ACC_BAG',
  'wallet-belt': 'ACC_WALLET',
  'accessory': 'ACC_ACCESSORY',
  'beauty': 'BEAUTY',
  'skincare': 'BEAUTY_SKINCARE',
  'makeup': 'BEAUTY_MAKEUP',
  'cleansing': 'BEAUTY_CLEANSING',
  'haircare': 'BEAUTY_HAIR',
  'bodycare': 'BEAUTY_BODY',
  'food': 'FOOD',
  'fresh-food': 'FOOD_FRESH',
  'processed-food': 'FOOD_PROCESSED',
  'snack-dessert': 'FOOD_SNACK',
  'beverage': 'FOOD_BEVERAGE',
  'health-food': 'FOOD_HEALTH',
  'living-kitchen': 'LIVING',
  'daily-supplies': 'LIVING_DAILY',
  'kitchenware': 'LIVING_KITCHEN',
  'storage-organization': 'LIVING_STORAGE',
  'safety-tools': 'LIVING_SAFETY',
  'furniture-interior': 'FURNITURE',
  'furniture': 'FURNITURE_MAIN',
  'bedding': 'FURNITURE_BEDDING',
  'home-deco': 'FURNITURE_DECO',
  'diy-construction': 'FURNITURE_DIY',
  'sports-leisure': 'SPORTS',
  'health-yoga': 'SPORTS_FITNESS',
  'hiking-camping': 'SPORTS_OUTDOOR',
  'bicycle-board': 'SPORTS_BIKE',
  'golf': 'SPORTS_GOLF',
  'car-tools': 'AUTO',
  'car-supplies': 'AUTO_CAR',
  'industrial-tools': 'AUTO_TOOL',
  'baby-kids': 'BABY',
  'birth-childcare': 'BABY_NEWBORN',
  'toys-education': 'BABY_TOY',
  'pet': 'PET',
  'dog-supplies': 'PET_DOG',
  'cat-supplies': 'PET_CAT',
  'book-stationery-hobby': 'BOOKS',
  'book': 'BOOKS_BOOK',
  'stationery-office': 'BOOKS_STATIONERY',
  'hobby': 'BOOKS_HOBBY',
  'ticket-goods': 'BOOKS_TICKET',
  'travel-service': 'TRAVEL',
  'travel-supplies': 'TRAVEL_GOODS',
  'rental-subscription': 'TRAVEL_RENTAL',
  'luxury-brand': 'LUXURY',
  'brand-fashion': 'LUXURY_FASHION',
  'premium-beauty': 'LUXURY_BEAUTY',
};

final _idsByCatalogCode = {
  for (final entry in _catalogCodes.entries) entry.value: entry.key,
};

ResolvedProductCategory? resolveCatalogCategory(
  String? value, {
  String? displayName,
}) => resolveProductCategory(
  _idsByCatalogCode[value?.trim().toUpperCase()] ?? value,
  displayName: displayName,
);

class ProductCatalogCategory {
  const ProductCatalogCategory._({required this.code, this.localFilterId});

  factory ProductCatalogCategory.forCategory(ResolvedProductCategory category) {
    final directCode = _catalogCodes[category.id];
    if (directCode != null) return ProductCatalogCategory._(code: directCode);

    return ProductCatalogCategory._(
      code: _catalogCodes[category.path.first.id]!,
      localFilterId: category.id,
    );
  }

  final String code;
  final String? localFilterId;

  bool includes({
    required String category,
    required String categoryDisplayName,
    String? subCategory,
  }) {
    final filterId = localFilterId;
    if (filterId == null) return true;

    final catalogId = _idsByCatalogCode[category];
    for (final candidate in [
      ?catalogId,
      category,
      categoryDisplayName,
      if (subCategory != null) ...subCategory.split('>').reversed,
    ]) {
      if (isProductInCategory(
        filterId,
        productCategory: candidate,
        productCategoryDisplayName: '',
      )) {
        return true;
      }
    }
    return false;
  }
}

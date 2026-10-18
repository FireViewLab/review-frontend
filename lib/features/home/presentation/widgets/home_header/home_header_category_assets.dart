// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

const _categoryImageBasePath = 'assets/images/categories/category_images';

const _categoryImageAssets = {
  'digital-appliance':
      '$_categoryImageBasePath/58_digital_mobile_tablet_camera.webp',
  'fashion-clothing':
      '$_categoryImageBasePath/59_fashion_womens_clothing_jacket.webp',
  'fashion-accessory': '$_categoryImageBasePath/60_fashion_bag_handbag.webp',
  'beauty': '$_categoryImageBasePath/61_beauty_skincare_cosmetics.webp',
  'food': '$_categoryImageBasePath/62_food_fresh_fruits.webp',
  'living-kitchen':
      '$_categoryImageBasePath/63_living_kitchen_supplies_cookware.webp',
  'furniture-interior': '$_categoryImageBasePath/64_home_furniture_chair.webp',
  'sports-leisure':
      '$_categoryImageBasePath/65_sports_camping_hiking_character.webp',
  'car-tools': '$_categoryImageBasePath/35_car_accessories_cleaning_tools.webp',
  'baby-kids': '$_categoryImageBasePath/66_baby_clothing_baby.webp',
  'pet': '$_categoryImageBasePath/67_pet_dog_supplies_retriever.webp',
  'book-stationery-hobby':
      '$_categoryImageBasePath/08_books_stack_open_book.webp',
  'travel-service':
      '$_categoryImageBasePath/11_travel_luggage_packing_cubes_neck_pillow.webp',
  'luxury-brand': '$_categoryImageBasePath/15_luxury_bag_wallet_watch_set.webp',
  'mobile-tablet':
      '$_categoryImageBasePath/41_digital_mobile_tablet_smartphone.webp',
  'pc-peripheral':
      '$_categoryImageBasePath/42_digital_pc_laptop_keyboard_mouse.webp',
  'video-audio': '$_categoryImageBasePath/43_digital_video_audio_tv.webp',
  'living-appliance':
      '$_categoryImageBasePath/44_digital_life_appliance_air_purifier.webp',
  'kitchen-appliance':
      '$_categoryImageBasePath/45_digital_kitchen_appliance_air_fryer.webp',
  'women-clothing':
      '$_categoryImageBasePath/46_fashion_womens_clothing_jacket.webp',
  'men-clothing':
      '$_categoryImageBasePath/47_fashion_mens_clothing_jacket.webp',
  'underwear-homewear':
      '$_categoryImageBasePath/48_fashion_underwear_loungewear_camisole.webp',
  'sports-clothing':
      '$_categoryImageBasePath/49_fashion_sportswear_training_jacket.webp',
  'shoes': '$_categoryImageBasePath/50_fashion_sneakers_shoes_white.webp',
  'bags': '$_categoryImageBasePath/51_fashion_bag_shoulder.webp',
  'wallet-belt': '$_categoryImageBasePath/52_fashion_wallet_belt_black.webp',
  'accessory': '$_categoryImageBasePath/53_fashion_watch_accessory_silver.webp',
  'skincare': '$_categoryImageBasePath/39_beauty_skincare_set.webp',
  'makeup': '$_categoryImageBasePath/54_beauty_makeup_lipstick_blush.webp',
  'cleansing': '$_categoryImageBasePath/55_beauty_cleansing_oil_water.webp',
  'haircare':
      '$_categoryImageBasePath/56_beauty_haircare_shampoo_treatment.webp',
  'bodycare': '$_categoryImageBasePath/57_beauty_bodycare_wash_lotion.webp',
  'fresh-food':
      '$_categoryImageBasePath/18_fresh_food_meat_fish_eggs_milk.webp',
  'processed-food': '$_categoryImageBasePath/69_food_processed_ramen.webp',
  'snack-dessert':
      '$_categoryImageBasePath/19_processed_food_snacks_dessert.webp',
  'beverage': '$_categoryImageBasePath/20_beverages_health_products.webp',
  'health-food': '$_categoryImageBasePath/20_beverages_health_products.webp',
  'daily-supplies': '$_categoryImageBasePath/70_living_daily_supplies_mop.webp',
  'kitchenware': '$_categoryImageBasePath/22_kitchen_essentials_set.webp',
  'storage-organization':
      '$_categoryImageBasePath/23_storage_organization_items.webp',
  'safety-tools': '$_categoryImageBasePath/24_safety_tools_items.webp',
  'furniture': '$_categoryImageBasePath/25_modern_furniture_set.webp',
  'bedding': '$_categoryImageBasePath/26_bedding_linen_collection.webp',
  'home-deco': '$_categoryImageBasePath/27_home_decor_items.webp',
  'diy-construction':
      '$_categoryImageBasePath/28_diy_home_improvement_items.webp',
  'health-yoga': '$_categoryImageBasePath/29_fitness_yoga_items.webp',
  'hiking-camping': '$_categoryImageBasePath/30_camping_hiking_gear.webp',
  'bicycle-board':
      '$_categoryImageBasePath/37_bicycle_scooter_safety_gear.webp',
  'golf': '$_categoryImageBasePath/36_golf_sports_equipment.webp',
  'car-supplies':
      '$_categoryImageBasePath/35_car_accessories_cleaning_tools.webp',
  'motorcycle-supplies':
      '$_categoryImageBasePath/34_motorcycle_riding_gear_accessories.webp',
  'industrial-tools':
      '$_categoryImageBasePath/33_work_tools_uniform_equipment.webp',
  'birth-childcare':
      '$_categoryImageBasePath/01_baby_outing_stroller_diapers.webp',
  'baby-supplies':
      '$_categoryImageBasePath/02_baby_feeding_bowl_lotion_duck_towel.webp',
  'kids-clothing':
      '$_categoryImageBasePath/03_baby_clothing_cardigan_denim_jacket.webp',
  'toys-education':
      '$_categoryImageBasePath/04_kids_toys_teddy_blocks_puzzle.webp',
  'dog-supplies':
      '$_categoryImageBasePath/05_dog_supplies_puppy_food_bowl.webp',
  'cat-supplies':
      '$_categoryImageBasePath/06_cat_supplies_cat_litter_tree.webp',
  'small-pet-aquarium':
      '$_categoryImageBasePath/07_small_pet_bird_aquarium_set.webp',
  'book': '$_categoryImageBasePath/08_books_stack_open_book.webp',
  'stationery-office':
      '$_categoryImageBasePath/09_stationery_pens_notebook_calculator.webp',
  'hobby': '$_categoryImageBasePath/10_hobby_guitar_paintbrush_robot.webp',
  'ticket-goods':
      '$_categoryImageBasePath/14_ticket_goods_concert_mug_keyring.webp',
  'travel-supplies':
      '$_categoryImageBasePath/11_travel_luggage_packing_cubes_neck_pillow.webp',
  'accommodation-ticket':
      '$_categoryImageBasePath/12_hotel_resort_photo_and_travel_cards.webp',
  'rental-subscription':
      '$_categoryImageBasePath/13_rental_subscription_box_appliance.webp',
  'luxury-accessory':
      '$_categoryImageBasePath/15_luxury_bag_wallet_watch_set.webp',
  'brand-fashion':
      '$_categoryImageBasePath/16_brand_fashion_trench_sneakers_sunglasses.webp',
  'premium-beauty':
      '$_categoryImageBasePath/17_premium_beauty_bottle_perfume_device.webp',
};

String? homeHeaderCategoryAssetPath(String categoryId) =>
    _categoryImageAssets[categoryId];

class HomeHeaderCategoryAssetImage extends StatelessWidget {
  const HomeHeaderCategoryAssetImage({
    required this.assetPath,
    this.width,
    this.height,
    this.scale = 1,
  });

  final String? assetPath;
  final double? width;
  final double? height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null) {
      return Icon(
        Icons.category_outlined,
        color: AppColors.textTertiary,
        size: (height ?? 48) * 0.48,
      );
    }

    return Transform.scale(
      scale: scale,
      child: Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => Icon(
          Icons.category_outlined,
          color: AppColors.textTertiary,
          size: (height ?? 48) * 0.48,
        ),
      ),
    );
  }
}

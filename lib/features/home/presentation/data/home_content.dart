import 'package:flutter/material.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';

// 서버 데이터로 채울 수 있는 메뉴만 둔다. 정렬 메뉴는 home_navigation.dart 참고.
const homeNavItems = ['홈', '베스트', '신상품', '리뷰랭킹', '반려동물'];

const banners = [
  HomeBannerData(
    title: '리뷰가 증명하는 여름 준비',
    emphasis: '쿨썸머 인기템 모음',
    description: '실사용 리뷰로 고른 믿을 수 있는 선택',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_1.webp',
    color: Color(0xFFEAF4FF),
    accentColor: Color(0xFF2563EB),
    icon: Icons.air,
  ),
  HomeBannerData(
    title: '신선함이 다르다',
    emphasis: '산지 직송 특가',
    description: '리뷰 흐름이 안정적인 신선 식품을 먼저 확인하세요',
    ctaLabel: '자세히 보기',
    badgeLabel: 'RTI 안정',
    assetPath: 'assets/images/home/banners/banner_2.webp',
    color: Color(0xFFEAF6E6),
    accentColor: Color(0xFF2E7D32),
    icon: Icons.eco_outlined,
  ),
  HomeBannerData(
    title: '리뷰 신뢰도 높은 뷰티템',
    emphasis: '광고성 리뷰 걱정 없이',
    description: '반복 패턴과 광고 신호를 낮춘 뷰티 상품 흐름',
    ctaLabel: '둘러보기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_3.webp',
    color: Color(0xFFFFF1F7),
    accentColor: Color(0xFFE65100),
    icon: Icons.spa_outlined,
  ),
  HomeBannerData(
    title: '반려생활 필수템 모음',
    emphasis: '리뷰로 고른 생활템',
    description: '검증된 리뷰 흐름을 기준으로 탐색하세요',
    ctaLabel: '더 알아보기',
    badgeLabel: 'RTI 추천',
    assetPath: 'assets/images/home/banners/banner_4.webp',
    color: Color(0xFFF8FAFC),
    accentColor: Color(0xFF0F172A),
    icon: Icons.pets_outlined,
  ),
  HomeBannerData(
    title: '더 맛있는 밥을 위한',
    emphasis: '스마트 전기밥솥 추천',
    description: '실사용 리뷰로 검증된 인기 전기밥솥 모음',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 94%',
    assetPath: 'assets/images/home/banners/banner_5.webp',
    color: Color(0xFFF5F0E8),
    accentColor: Color(0xFF8B5E3C),
    icon: Icons.kitchen_outlined,
  ),
  HomeBannerData(
    title: '향기로운 하루의 시작',
    emphasis: '홈카페 인기 아이템',
    description: '실사용 리뷰로 검증된 커피 용품 모음',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 93%',
    assetPath: 'assets/images/home/banners/banner_6.webp',
    color: Color(0xFFFAF6F0),
    accentColor: Color(0xFF6B4226),
    icon: Icons.local_cafe_outlined,
  ),
  HomeBannerData(
    title: '건조한 일상에',
    emphasis: '촉촉함을 더하는 가습기',
    description: '실사용 리뷰로 검증된 인기 가습기 모음',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 90%',
    assetPath: 'assets/images/home/banners/banner_7.webp',
    color: Color(0xFFF0F7F4),
    accentColor: Color(0xFF2D7A5A),
    icon: Icons.air_outlined,
  ),
  HomeBannerData(
    title: '리뷰가 선택한',
    emphasis: '무선 청소기 추천',
    description: '실사용 리뷰로 검증된 인기 청소기 모음',
    ctaLabel: '지금 확인하기',
    badgeLabel: 'RTI 91%',
    assetPath: 'assets/images/home/banners/banner_8.webp',
    color: Color(0xFFF2F6F2),
    accentColor: Color(0xFF3D6B45),
    icon: Icons.cleaning_services_outlined,
  ),
];

const quickCategories = [
  QuickCategoryData(
    label: '리뷰랭킹',
    iconAssetPath:
        'assets/images/home/icons/icon-review-ranking-transparent.png',
    useIconBacking: false,
  ),
  QuickCategoryData(
    label: '뷰티',
    iconAssetPath: 'assets/images/home/icons/icon-beauty-transparent.png',
    useIconBacking: false,
  ),
  QuickCategoryData(
    label: '가전',
    iconAssetPath: 'assets/images/home/icons/icon-appliance-transparent.png',
    useIconBacking: false,
  ),
  QuickCategoryData(
    label: '인테리어',
    iconAssetPath: 'assets/images/home/icons/icon-interior-transparent.png',
    useIconBacking: false,
  ),
  QuickCategoryData(
    label: '푸드',
    iconAssetPath: 'assets/images/home/icons/icon-food.webp',
  ),
  QuickCategoryData(
    label: '스포츠',
    iconAssetPath: 'assets/images/home/icons/icon-sports.webp',
  ),
  QuickCategoryData(
    label: '전체보기',
    iconAssetPath: 'assets/images/home/icons/icon-all-categories.webp',
  ),
];

const trendingKeywords = <String>[];

const recommendedProducts = <HomeProductData>[];

final popularCategories = [
  for (final category in productCategoryTree)
    PopularCategoryData(
      label: category.label,
      icon: _popularCategoryIcons[category.id] ?? Icons.category_outlined,
    ),
];

const _popularCategoryIcons = {
  'digital-appliance': Icons.devices_other_outlined,
  'fashion-clothing': Icons.checkroom_outlined,
  'fashion-accessory': Icons.shopping_bag_outlined,
  'beauty': Icons.spa_outlined,
  'food': Icons.restaurant_outlined,
  'living-kitchen': Icons.kitchen_outlined,
  'furniture-interior': Icons.chair_outlined,
  'sports-leisure': Icons.sports_soccer_outlined,
  'car-tools': Icons.directions_car_outlined,
  'baby-kids': Icons.child_care_outlined,
  'pet': Icons.pets_outlined,
  'book-stationery-hobby': Icons.menu_book_outlined,
  'travel-service': Icons.luggage_outlined,
  'luxury-brand': Icons.diamond_outlined,
};

const benefitItems = [
  BenefitData(title: '10%', description: '웰컴 쿠폰'),
  BenefitData(title: '무료', description: '배송 쿠폰'),
  BenefitData(title: '3,000P', description: '적립금'),
];

class HomeBannerData {
  const HomeBannerData({
    required this.title,
    required this.emphasis,
    required this.description,
    required this.ctaLabel,
    required this.badgeLabel,
    this.assetPath,
    this.imageUrl,
    this.mobileImageUrl,
    this.targetUrl,
    required this.color,
    required this.accentColor,
    required this.icon,
  });

  final String title;
  final String emphasis;
  final String description;
  final String ctaLabel;
  final String badgeLabel;
  final String? assetPath;
  final String? imageUrl;
  final String? mobileImageUrl;
  final String? targetUrl;
  final Color color;
  final Color accentColor;
  final IconData icon;
}

class QuickCategoryData {
  const QuickCategoryData({
    required this.label,
    required this.iconAssetPath,
    this.useIconBacking = true,
  });

  final String label;
  final String iconAssetPath;
  final bool useIconBacking;
}

class HomeProductData {
  const HomeProductData({
    this.detailPath,
    this.chatProductId,
    required this.productId,
    required this.name,
    required this.storeName,
    required this.priceLabel,
    required this.ratingLabel,
    required this.reviewCountLabel,
    required this.rtiLabel,
    required this.imageUrl,
    required this.label,
  });

  final String? detailPath;
  final String? chatProductId;
  final String productId;
  final String name;
  final String storeName;
  final String priceLabel;
  final String ratingLabel;
  final String reviewCountLabel;
  final String rtiLabel;
  final String imageUrl;
  final String label;
}

class PopularCategoryData {
  const PopularCategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class BenefitData {
  const BenefitData({required this.title, required this.description});

  final String title;
  final String description;
}

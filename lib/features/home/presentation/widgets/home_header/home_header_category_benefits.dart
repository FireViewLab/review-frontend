// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';

const _defaultBenefitLabels = [
  '리뷰 데이터 기반 추천',
  'RTI 랭킹 확인',
  '빠른 배송 상품',
  '혜택 모아보기',
];

const _categoryBenefitLabels = {
  'digital-appliance': ['리뷰 데이터 기반 추천', 'RTI 랭킹 확인', '빠른 배송 상품', '혜택 모아보기'],
  'fashion-clothing': ['사이즈 추천', '스타일 추천', '성별 핫딜', '베스트 선물'],
  'fashion-accessory': ['정품 인증', '브랜드 기획전', '선물 포장 서비스', '무료 반품'],
  'beauty': ['성분으로 찾기', '피부 타입 추천', '리뷰 랭킹', '샘플 체험'],
  'food': ['새벽배송', '대용량 할인', '리뷰 인기상품', '정기배송'],
  'living-kitchen': ['오늘의 특가', '집들이 추천', '리뷰 랭킹', '빠른배송'],
  'furniture-interior': ['공간별 추천', '인기 인테리어', '설치 서비스', '시즌 데코'],
  'sports-leisure': ['입문자 추천', '베스트 장비', '시즌 아웃도어', '빠른 비교'],
  'car-tools': ['차량관리 필수템', '정비용품 추천', '브랜드 특가', '안전장비 모음'],
  'baby-kids': ['육아 필수템', '연령별 추천', '안전인증', '기획전'],
  'pet': ['인기 간식', '정기배송', '수의사 추천', '우리 아이 맞춤'],
  'book-stationery-hobby': ['MD 추천', '예약판매', '한정판 굿즈', '베스트셀러'],
  'travel-service': ['여행 준비 체크리스트', '인기 숙소', '할인 티켓', '구독 혜택'],
  'luxury-brand': ['정품 보증', '브랜드 위크', '프리미엄 혜택', '단독 오퍼'],
};

class HomeHeaderCategoryBenefitStrip extends StatelessWidget {
  const HomeHeaderCategoryBenefitStrip({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final items = _categoryBenefitLabels[category.id] ?? _defaultBenefitLabels;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
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

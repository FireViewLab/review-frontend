import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';

class ResolvedProductCategory {
  const ResolvedProductCategory({
    required this.id,
    required this.label,
    required this.path,
  });

  final String id;
  final String label;
  final List<ProductCategory> path;
}

ResolvedProductCategory? resolveProductCategory(
  String? value, {
  String? displayName,
  String? productName,
}) {
  final inferredProductCategory = _inferCategoryIdFromProductName(productName);
  final candidates =
      (value?.contains('_') == true
              ? [value, displayName, inferredProductCategory]
              : [inferredProductCategory, value, displayName])
          .whereType<String>()
          .where((v) => v.trim().isNotEmpty);

  for (final candidate in candidates) {
    final category = _findCategory(candidate);
    if (category != null) return category;
  }

  return null;
}

String normalizedCategoryLabel({
  required String category,
  required String categoryDisplayName,
  String productName = '',
}) {
  final resolved = resolveProductCategory(
    category,
    displayName: categoryDisplayName,
    productName: productName,
  );
  if (resolved != null) return resolved.label;
  return categoryDisplayName.isNotEmpty ? categoryDisplayName : category;
}

ResolvedProductCategory? _findCategory(String rawValue) {
  final value = rawValue.trim();
  final normalized = _normalize(value);
  final aliasedId = _categoryAliases[normalized];

  for (final category in productCategoryTree) {
    final match = _findInTree(
      category,
      normalized: normalized,
      aliasedId: aliasedId,
      path: const [],
    );
    if (match != null) return match;
  }

  return null;
}

ResolvedProductCategory? _findInTree(
  ProductCategory category, {
  required String normalized,
  required String? aliasedId,
  required List<ProductCategory> path,
}) {
  final nextPath = [...path, category];
  if (category.id == aliasedId ||
      _normalize(category.id) == normalized ||
      _normalize(category.label) == normalized) {
    return ResolvedProductCategory(
      id: category.id,
      label: category.label,
      path: nextPath,
    );
  }

  for (final child in category.children) {
    final match = _findInTree(
      child,
      normalized: normalized,
      aliasedId: aliasedId,
      path: nextPath,
    );
    if (match != null) return match;
  }

  return null;
}

bool isProductInCategory(
  String categoryId, {
  required String productCategory,
  required String productCategoryDisplayName,
  String productName = '',
}) {
  final target = resolveProductCategory(categoryId);
  if (target == null) return false;

  final product = resolveProductCategory(
    productCategory,
    displayName: productCategoryDisplayName,
    productName: productName,
  );
  if (product == null) return false;

  return product.path.any((category) => category.id == target.id) ||
      target.path.any((category) => category.id == product.id);
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[\s/_\-·>]+'), '')
      .replaceAll('카테고리', '')
      .trim();
}

const _categoryAliases = {
  'beautyskincare': 'skincare',
  '전자기기': 'digital-appliance',
  '전자제품': 'digital-appliance',
  '디지털가전': 'digital-appliance',
  '가전디지털': 'digital-appliance',
  '가전': 'digital-appliance',
  // 홈 빠른 카테고리 라벨
  '인테리어': 'furniture-interior',
  '푸드': 'food',
  '스포츠': 'sports-leisure',
  'pc주변기기': 'pc-peripheral',
  '컴퓨터': 'pc-peripheral',
  '노트북': 'pc-peripheral',
  '모바일태블릿': 'mobile-tablet',
  '휴대폰': 'mobile-tablet',
  '영상음향': 'video-audio',
  '오디오': 'video-audio',
  '헤드폰': 'video-audio',
  '이어폰': 'video-audio',
  '책': 'book',
  '도서': 'book',
  '문구사무': 'stationery-office',
  '문구': 'stationery-office',
  '식품': 'food',
  '신선식품': 'fresh-food',
  '가공식품': 'processed-food',
  '생활용품': 'daily-supplies',
  '생활주방': 'living-kitchen',
  '주방용품': 'kitchenware',
  '가구인테리어': 'furniture-interior',
  '가구': 'furniture',
  '침구': 'bedding',
  '스포츠레저': 'sports-leisure',
  '자동차공구': 'car-tools',
  '출산유아동': 'baby-kids',
  '반려동물': 'pet',
  '여행서비스': 'travel-service',
  '명품브랜드': 'luxury-brand',
};

String? _inferCategoryIdFromProductName(String? productName) {
  final normalized = _normalize(productName ?? '');
  if (normalized.isEmpty) return null;

  for (final entry in _productNameKeywordAliases.entries) {
    if (entry.value.any(
      (keyword) => normalized.contains(_normalize(keyword)),
    )) {
      return entry.key;
    }
  }

  return null;
}

const _productNameKeywordAliases = {
  'book': ['책', '도서', '북', '클린코드', 'clean code', 'clean architecture'],
  'video-audio': [
    '이어폰',
    '헤드폰',
    '헤드셋',
    '스피커',
    'tv',
    '텔레비전',
    'wh1000',
    '에어팟',
    '버즈',
  ],
  'mobile-tablet': ['스마트폰', '휴대폰', '아이폰', '갤럭시', '태블릿', '아이패드'],
  'pc-peripheral': ['노트북', '맥북', '그램', '키보드', '마우스', '모니터'],
  'kitchen-appliance': ['에어프라이어', '전자레인지', '밥솥', '믹서기', '커피머신'],
  'living-appliance': ['청소기', '공기청정기', '선풍기', '제습기', '가습기'],
  'processed-food': ['라면', '참치', '즉석', '캔', '스팸'],
  'fresh-food': ['과일', '채소', '고기', '계란', '우유', '오렌지'],
  'dog-supplies': ['강아지', '사료', '하네스', '로얄캐닌'],
  'cat-supplies': ['고양이', '캣', '모래', '캣타워'],
  'baby-supplies': ['기저귀', '분유', '젖병', '유아', '아기'],
  'luxury-bag': [
    '명품가방',
    '명품백',
    '구찌',
    '루이비통',
    '샤넬',
    '프라다',
    '디올',
    '셀린',
    '버버리',
    '생로랑',
    '입생로랑',
    '보테가',
    '고야드',
    '펜디',
    '발렌시아가',
    '미우미우',
  ],
  'luxury-wallet': ['명품지갑'],
  'luxury-watch': ['명품시계'],
  'wallet-belt': ['지갑/벨트', '지갑벨트', '벨트', '허리띠'],
  'long-wallet': ['장지갑'],
  'card-wallet': ['카드지갑'],
  'bi-fold-wallet': ['반지갑', '머니클립', '지갑', 'wallet'],
  'women-clothing': ['원피스', '여성', '블라우스'],
  'men-clothing': ['남성', '셔츠', '수트'],
  'bags': ['가방', '백팩', '토트백', '숄더백'],
  'shoes': ['신발', '스니커즈', '운동화'],
  'skincare': ['스킨', '로션', '크림', '세럼'],
  'makeup': ['립스틱', '블러셔', '파운데이션'],
  'daily-supplies': ['세제', '휴지', '청소포', '물티슈'],
  'kitchenware': ['냄비', '프라이팬', '칼', '도마'],
  'furniture': ['침대', '소파', '책상', '의자'],
  'hiking-camping': ['텐트', '캠핑', '침낭'],
  'golf': ['골프', '골프공', '골프클럽'],
  'car-supplies': ['차량', '자동차', '거치대', '방향제'],
};

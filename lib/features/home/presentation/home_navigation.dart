import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';

/// 헤더 상단 메뉴 중 전체 상품을 정렬해서 보여 주는 항목.
const homeNavSortTabs = {
  '베스트': SearchSortOption.reviewCount,
  '신상품': SearchSortOption.newest,
  '리뷰랭킹': SearchSortOption.rti,
};

/// 헤더 상단 메뉴와 카테고리 메뉴를 눌렀을 때의 이동을 모든 화면에서 같게 맞춘다.
void openHomeNavItem(BuildContext context, String item) {
  if (item == '홈') {
    context.go(RoutePaths.home);
    return;
  }

  final sort = homeNavSortTabs[item];
  if (sort != null) {
    context.goNamed(RouteNames.search, queryParameters: {'sort': sort.name});
    return;
  }

  final category = resolveProductCategory(item);
  context.goNamed(
    RouteNames.search,
    queryParameters: category == null
        ? {'q': item}
        : {'categoryId': category.id, 'category': category.label},
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_results_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key, required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: AppEmptyView(
        title: '검색 결과가 없어요',
        message: state.query.isEmpty
            ? '상품명이나 카테고리를 입력하면 리뷰 기반 추천 상품을 보여드려요.'
            : '다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.',
      ),
    );
  }
}

class SearchSummary extends StatelessWidget {
  const SearchSummary({super.key, required this.state});

  final SearchResultsState state;

  @override
  Widget build(BuildContext context) {
    final categoryPath = state.categoryPath;
    final isCategoryBrowse = categoryPath.isNotEmpty;
    final title = isCategoryBrowse
        ? categoryPath.last.label
        : state.query.isEmpty
        ? '전체 상품'
        : state.query;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCategoryBrowse) ...[
          _CategoryBreadcrumb(path: categoryPath),
          const SizedBox(height: AppSpacing.xs),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.isMobile ? 28 : 34,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                isCategoryBrowse ? '카테고리 상품' : '검색 결과',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${formatSearchCount(state.displayTotalCount)}개 상품',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Re:view Trust Index(RTI)란?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              '실제 구매자 리뷰의 신뢰도를 종합해 산출한 지표입니다.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QuickFilterRow extends StatelessWidget {
  const QuickFilterRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<SearchFilterChipData> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: QuickFilterPill(
                label: filter.label == '전체'
                    ? '전체 ${filter.count}'
                    : filter.label,
                selected: filter.label == selectedFilter,
                onPressed: () => onSelected(filter.label),
              ),
            ),
        ],
      ),
    );
  }
}

class QuickFilterPill extends StatelessWidget {
  const QuickFilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF061332);
    final foreground = selected ? AppColors.onPrimary : AppColors.textPrimary;

    return Material(
      color: selected ? selectedColor : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(minWidth: 84, minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? selectedColor : AppColors.borderStrong,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 14, color: foreground),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Text(
                label,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBreadcrumb extends StatelessWidget {
  const _CategoryBreadcrumb({required this.path});

  final List<SearchCategoryCrumb> path;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w700,
    );
    final separator = Icon(
      Icons.chevron_right,
      size: 16,
      color: AppColors.textSecondary,
    );

    Widget link(String label, VoidCallback onTap) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(label, style: style),
      ),
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: [
        // 홈 카테고리 시트의 전체보기와 같은 목록으로 간다.
        link(
          '전체',
          () => context.goNamed(
            RouteNames.search,
            queryParameters: {'sort': SearchSortOption.accuracy.name},
          ),
        ),
        for (var i = 0; i < path.length; i++) ...[
          separator,
          if (i == path.length - 1)
            Text(
              path[i].label,
              style: style?.copyWith(color: AppColors.textPrimary),
            )
          else
            link(
              path[i].label,
              () => context.goNamed(
                RouteNames.search,
                queryParameters: {
                  'categoryId': path[i].id,
                  'category': path[i].label,
                },
              ),
            ),
        ],
      ],
    );
  }
}

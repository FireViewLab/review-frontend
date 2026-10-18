import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_resolver.dart';

class ProductDetailBreadcrumb extends StatelessWidget {
  const ProductDetailBreadcrumb({super.key, required this.breadcrumbs});

  final List<String> breadcrumbs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < breadcrumbs.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Icon(
                Icons.chevron_right,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ),
          GestureDetector(
            onTap: i == breadcrumbs.length - 1
                ? null
                : () {
                    final category = resolveProductCategory(breadcrumbs[i]);
                    context.goNamed(
                      RouteNames.search,
                      queryParameters: {
                        if (category != null) 'categoryId': category.id,
                        'category': breadcrumbs[i],
                      },
                    );
                  },
            child: Text(
              breadcrumbs[i],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: i == breadcrumbs.length - 1
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: i == breadcrumbs.length - 1
                    ? FontWeight.w700
                    : FontWeight.w500,
                decoration: i < breadcrumbs.length - 1
                    ? TextDecoration.underline
                    : null,
                decorationColor: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

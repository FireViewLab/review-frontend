import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/category/domain/entities/product_category.dart';
import 'package:re_view_front/features/category/domain/entities/product_category_master.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// The result record distinguishes selecting all products from dismissing.
Future<({ProductCategory? category})?> showHomeCategorySheet(
  BuildContext context,
) {
  FocusScope.of(context).unfocus();
  return showModalBottomSheet<({ProductCategory? category})>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => HomeCategorySheet(
      onSelected: (category) => Navigator.of(context).pop((category: category)),
    ),
  );
}

class HomeCategorySheet extends StatelessWidget {
  const HomeCategorySheet({super.key, required this.onSelected});
  final ValueChanged<ProductCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.navCategory,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(l10n.homeViewAll),
                    leading: const Icon(Icons.apps),
                    onTap: () => onSelected(null),
                  ),
                  for (final category in productCategoryTree)
                    _CategoryBranch(category: category, onSelected: onSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBranch extends StatelessWidget {
  const _CategoryBranch({required this.category, required this.onSelected});
  final ProductCategory category;
  final ValueChanged<ProductCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (category.children.isEmpty) {
      return ListTile(
        title: Text(category.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onSelected(category),
      );
    }
    return ExpansionTile(
      key: PageStorageKey(category.id),
      title: Text(category.label),
      childrenPadding: const EdgeInsets.only(left: AppSpacing.md),
      children: [
        ListTile(
          title: Text(
            '${category.label} ${AppLocalizations.of(context).homeViewAll}',
          ),
          onTap: () => onSelected(category),
        ),
        for (final child in category.children)
          _CategoryBranch(category: child, onSelected: onSelected),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class SearchSuggestionPanel extends StatelessWidget {
  const SearchSuggestionPanel({
    super.key,
    required this.relatedKeywords,
    required this.suggestionItems,
    required this.relatedFailed,
    required this.relatedResolved,
    required this.onRelatedRetry,
    required this.popularKeywords,
    required this.recentQueries,
    required this.products,
    required this.isLoadingRelated,
    required this.onKeywordPressed,
    required this.onRecentQueryPressed,
    required this.onRecentQueryDeleted,
    required this.onRecentQueriesCleared,
    required this.onProductPressed,
  });

  final List<String> relatedKeywords;
  final List<Widget> suggestionItems;
  final bool relatedFailed;
  final bool relatedResolved;
  final VoidCallback? onRelatedRetry;
  final List<String> popularKeywords;
  final List<String> recentQueries;
  final List<HomeProductData> products;
  final bool isLoadingRelated;
  final ValueChanged<String> onKeywordPressed;
  final ValueChanged<String> onRecentQueryPressed;
  final ValueChanged<String> onRecentQueryDeleted;
  final VoidCallback onRecentQueriesCleared;
  final ValueChanged<HomeProductData> onProductPressed;

  @override
  Widget build(BuildContext context) {
    final visibleRelatedKeywords = relatedKeywords
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .take(6)
        .toList();
    final visiblePopularKeywords = popularKeywords
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .take(6)
        .toList();

    return Material(
      color: Colors.transparent,
      elevation: 14,
      shadowColor: const Color(0x1F0F172A),
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PanelSectionTitle(
                title: AppLocalizations.of(context).homeSearchSuggestionsTitle,
                trailing: IconButton(
                  tooltip: AppLocalizations.of(
                    context,
                  ).homeSearchSuggestionsRetry,
                  onPressed: isLoadingRelated ? null : onRelatedRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (isLoadingRelated)
                _PanelEmptyRow(
                  message: AppLocalizations.of(
                    context,
                  ).homeSearchSuggestionsLoading,
                )
              else if (relatedFailed)
                _PanelEmptyRow(
                  message: AppLocalizations.of(
                    context,
                  ).homeSearchSuggestionsError,
                )
              else if (visibleRelatedKeywords.isEmpty)
                _PanelEmptyRow(
                  message: relatedResolved
                      ? AppLocalizations.of(context).homeSearchSuggestionsEmpty
                      : AppLocalizations.of(context).homeSearchSuggestionsHint,
                )
              else
                FocusTraversalGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: suggestionItems,
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              _PanelSectionTitle(
                title: AppLocalizations.of(context).homeRecentSearchTitle,
                trailing: recentQueries.isEmpty
                    ? null
                    : TextButton.icon(
                        onPressed: onRecentQueriesCleared,
                        icon: const Icon(Icons.delete_outline, size: 14),
                        label: Text(
                          AppLocalizations.of(
                            context,
                          ).homeRecentSearchDeleteAll,
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.textTertiary,
                          textStyle: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (recentQueries.isEmpty)
                _PanelEmptyRow(
                  message: AppLocalizations.of(context).homeRecentSearchEmpty,
                )
              else
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final query in recentQueries)
                      _RecentSearchChip(
                        label: query,
                        onPressed: () => onRecentQueryPressed(query),
                        onDeleted: () => onRecentQueryDeleted(query),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              _PanelSectionTitle(
                title: AppLocalizations.of(context).homePopularSearchTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (visiblePopularKeywords.isEmpty)
                _PanelEmptyRow(
                  message: AppLocalizations.of(context).homePopularSearchTitle,
                )
              else
                _KeywordWrap(
                  keywords: visiblePopularKeywords,
                  onKeywordPressed: onKeywordPressed,
                ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              _PanelSectionTitle(
                title: AppLocalizations.of(context).homeSearchProductsTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (products.isEmpty)
                const _PanelEmptyRow(message: '추천상품 API 연결 대기 중')
              else
                for (final (index, product) in products.indexed)
                  _SuggestedProductTile(
                    key: ValueKey('search-suggestion-product-$index'),
                    product: product,
                    onPressed: () => onProductPressed(product),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelSectionTitle extends StatelessWidget {
  const _PanelSectionTitle({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _PanelEmptyRow extends StatelessWidget {
  const _PanelEmptyRow({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _KeywordWrap extends StatelessWidget {
  const _KeywordWrap({required this.keywords, required this.onKeywordPressed});

  final List<String> keywords;
  final ValueChanged<String> onKeywordPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final keyword in keywords)
          _KeywordChip(
            label: keyword,
            onPressed: () => onKeywordPressed(keyword),
          ),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _PlainPanelChip(
      onPressed: onPressed,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RecentSearchChip extends StatelessWidget {
  const _RecentSearchChip({
    required this.label,
    required this.onPressed,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return _PlainPanelChip(
      onPressed: onPressed,
      backgroundColor: const Color(0xFFF8FAFC),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            size: 14,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onDeleted,
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close, size: 14, color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlainPanelChip extends StatelessWidget {
  const _PlainPanelChip({
    required this.child,
    required this.onPressed,
    this.backgroundColor = AppColors.surface,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Material(
        color: backgroundColor,
        shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 8,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SuggestedProductTile extends StatelessWidget {
  const _SuggestedProductTile({
    required this.product,
    required this.onPressed,
    super.key,
  });

  final HomeProductData product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final rtiLabel = product.rtiLabel.isEmpty ? 'RTI 확인 중' : product.rtiLabel;

    return SizedBox(
      height: 58,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppNetworkImage(
                  url: product.imageUrl,
                  thumbnailWidth: 160,
                  fit: BoxFit.contain,
                  placeholderIcon: Icons.inventory_2_outlined,
                  iconSize: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.label.isEmpty ? '신뢰도 분석 상품' : product.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rtiLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.priceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

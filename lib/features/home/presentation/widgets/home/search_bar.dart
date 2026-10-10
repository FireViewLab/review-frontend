import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/storage/web_storage.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

const _recentSearchStorageKey = 'home_recent_search_queries';
const _suggestionPanelPlaceholder = '__review_suggestion_panel_placeholder__';

class SearchBar extends StatefulWidget {
  const SearchBar({
    this.focusNode,
    this.initialValue,
    this.popularKeywords = const [],
    this.recommendedProducts = const [],
    this.onSuggestionsRequested,
    this.onSubmitted,
    this.onSearchPressed,
    super.key,
  });

  final FocusNode? focusNode;
  final String? initialValue;
  final List<String> popularKeywords;
  final List<HomeProductData> recommendedProducts;
  final Future<List<String>> Function(String query)? onSuggestionsRequested;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSearchPressed;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _fallbackFocusNode;
  final _suggestions = SuggestionsController<String>();
  int _relatedGeneration = 0;
  bool _relatedFailed = false;
  bool _relatedResolved = false;
  bool _isFocused = false;
  bool _isHovered = false;
  List<String> _recentQueries = const [];
  List<String> _relatedKeywords = const [];

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _fallbackFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(_invalidateRelated);
    _fallbackFocusNode = FocusNode();
    _effectiveFocusNode.addListener(_syncFocusState);
    _isFocused = _effectiveFocusNode.hasFocus;
    _recentQueries = _readRecentQueries();
  }

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _fallbackFocusNode).removeListener(
        _syncFocusState,
      );
      _effectiveFocusNode.addListener(_syncFocusState);
      _isFocused = _effectiveFocusNode.hasFocus;
    }

    final nextValue = widget.initialValue ?? '';
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != nextValue) {
      _controller.text = nextValue;
      _controller.selection = TextSelection.collapsed(offset: nextValue.length);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_syncFocusState);
    _fallbackFocusNode.dispose();
    _relatedGeneration++;
    _controller.removeListener(_invalidateRelated);
    _suggestions.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered || _isFocused
        ? const Color(0xFFF8FAFF)
        : AppColors.surface;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused || _isHovered
                ? AppColors.primary
                : AppColors.borderStrong,
            width: _isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            if (_isFocused)
              const BoxShadow(
                color: Color(0x1A2563EB),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ColoredBox(
            color: backgroundColor,
            child: TypeAheadField<String>(
              controller: _controller,
              suggestionsController: _suggestions,
              focusNode: _effectiveFocusNode,
              debounceDuration: const Duration(milliseconds: 300),
              hideOnEmpty: false,
              hideOnError: false,
              hideOnLoading: false,
              retainOnLoading: false,
              hideOnSelect: true,
              offset: const Offset(0, 8),
              constraints: const BoxConstraints(maxHeight: 520),
              suggestionsCallback: _loadRelatedKeywords,
              onSelected: _submitQuery,
              itemBuilder: (context, keyword) {
                if (keyword == _suggestionPanelPlaceholder) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Text(
                    keyword,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
              listBuilder: (context, children) =>
                  _buildSuggestionPanel(suggestionItems: children),
              loadingBuilder: (context) =>
                  _buildSuggestionPanel(isLoadingRelated: true),
              emptyBuilder: (context) => _buildSuggestionPanel(),
              errorBuilder: (context, error) => _buildSuggestionPanel(),
              decorationBuilder: (context, child) => child,
              builder: (context, controller, focusNode) => TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: _submitQuery,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).homeSearchHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: IconButton(
                    tooltip: '검색',
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed:
                        widget.onSubmitted == null &&
                            widget.onSearchPressed == null
                        ? null
                        : () => _submitQuery(controller.text, byIcon: true),
                  ),
                  filled: true,
                  fillColor: backgroundColor,
                  hoverColor: backgroundColor,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 13,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitQuery(String value, {bool byIcon = false}) {
    final query = value.trim();
    if (query.isEmpty || query == _suggestionPanelPlaceholder) {
      return;
    }

    if (_controller.text != query) {
      _controller.text = query;
      _controller.selection = TextSelection.collapsed(offset: query.length);
    }
    _effectiveFocusNode.unfocus();
    _saveRecentQuery(query);
    if (byIcon && widget.onSearchPressed != null) {
      widget.onSearchPressed!(query);
      return;
    }

    widget.onSubmitted?.call(query);
  }

  void _saveRecentQuery(String query) {
    final nextQueries = [
      query,
      ..._recentQueries.where((item) => item != query),
    ].take(5).toList(growable: false);

    _writeRecentQueries(nextQueries);
    if (mounted) {
      setState(() => _recentQueries = nextQueries);
    }
  }

  void _removeRecentQuery(String query) {
    final nextQueries = _recentQueries
        .where((item) => item != query)
        .toList(growable: false);
    _writeRecentQueries(nextQueries);
    setState(() => _recentQueries = nextQueries);
  }

  void _clearRecentQueries() {
    WebStorage.remove(_recentSearchStorageKey);
    setState(() => _recentQueries = const []);
  }

  List<String> _readRecentQueries() {
    final value = WebStorage.read(_recentSearchStorageKey);
    if (value == null || value.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<String>()
          .map((query) => query.trim())
          .where((query) => query.isNotEmpty)
          .take(5)
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  void _writeRecentQueries(List<String> queries) {
    if (queries.isEmpty) {
      WebStorage.remove(_recentSearchStorageKey);
      return;
    }

    WebStorage.write(_recentSearchStorageKey, jsonEncode(queries));
  }

  void _setHovered(bool value) {
    if (_isHovered == value) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isHovered != value) {
        setState(() => _isHovered = value);
      }
    });
  }

  void _syncFocusState() {
    final nextValue = _effectiveFocusNode.hasFocus;
    if (_isFocused == nextValue) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isFocused != nextValue) {
        setState(() => _isFocused = nextValue);
      }
    });
  }

  void _invalidateRelated() {
    _relatedGeneration++;
    if (!mounted) return;
    setState(() {
      _relatedKeywords = const [];
      _relatedFailed = false;
      _relatedResolved = false;
    });
  }

  Future<List<String>> _loadRelatedKeywords(String pattern) async {
    final generation = ++_relatedGeneration;
    final query = pattern.trim();
    if (query.length < 2 ||
        query.length > 120 ||
        widget.onSuggestionsRequested == null) {
      return const [_suggestionPanelPlaceholder];
    }
    bool current() =>
        mounted &&
        generation == _relatedGeneration &&
        _controller.text.trim() == query;
    try {
      final keywords = await widget.onSuggestionsRequested!(query);
      final seen = <String>{query.toLowerCase()};
      final visibleKeywords = keywords
          .map((keyword) => keyword.trim())
          .where(
            (keyword) =>
                keyword.isNotEmpty &&
                keyword != _suggestionPanelPlaceholder &&
                seen.add(keyword.toLowerCase()),
          )
          .take(6)
          .toList(growable: false);
      if (!current()) return const [_suggestionPanelPlaceholder];
      setState(() {
        _relatedKeywords = visibleKeywords;
        _relatedFailed = false;
        _relatedResolved = true;
      });
      return visibleKeywords.isEmpty
          ? const [_suggestionPanelPlaceholder]
          : visibleKeywords;
    } catch (_) {
      if (current()) {
        setState(() {
          _relatedKeywords = const [];
          _relatedFailed = true;
          _relatedResolved = true;
        });
      }
      return const [_suggestionPanelPlaceholder];
    }
  }

  Widget _buildSuggestionPanel({
    bool isLoadingRelated = false,
    List<Widget> suggestionItems = const [],
  }) {
    return _SearchSuggestionPanel(
      relatedKeywords: _relatedKeywords,
      suggestionItems: suggestionItems,
      relatedFailed: _relatedFailed,
      relatedResolved: _relatedResolved,
      onRelatedRetry: _controller.text.trim().length >= 2
          ? _suggestions.refresh
          : null,
      popularKeywords: widget.popularKeywords,
      recentQueries: _recentQueries,
      products: widget.recommendedProducts.take(2).toList(),
      isLoadingRelated: isLoadingRelated,
      onKeywordPressed: _submitQuery,
      onRecentQueryPressed: _submitQuery,
      onRecentQueryDeleted: _removeRecentQuery,
      onRecentQueriesCleared: _clearRecentQueries,
      onProductPressed: (product) => _submitQuery(product.name),
    );
  }
}

class _SearchSuggestionPanel extends StatelessWidget {
  const _SearchSuggestionPanel({
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

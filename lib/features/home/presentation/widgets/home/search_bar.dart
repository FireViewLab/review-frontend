import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/storage/web_storage.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/search_suggestion_panel.dart';

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
    return SearchSuggestionPanel(
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

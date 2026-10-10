import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class SearchAutocompleteRemoteDataSource {
  Future<List<String>> fetchSuggestions(String query);
}

/// Dedicated unauthenticated client; never reuse the application's API client.
class GoogleSearchAutocompleteRemoteDataSource
    implements SearchAutocompleteRemoteDataSource {
  GoogleSearchAutocompleteRemoteDataSource({required Dio dio}) : _dio = dio;

  static const _ttl = Duration(minutes: 5);
  static const _maxEntries = 40;
  final Dio _dio;
  final _cache = <String, ({DateTime expires, List<String> items})>{};
  CancelToken? _pending;

  void dispose() {
    _pending?.cancel();
    _dio.close();
    _cache.clear();
  }

  @override
  Future<List<String>> fetchSuggestions(String query) async {
    _pending?.cancel('Input changed');
    final keyword = query.trim();
    if (keyword.length < 2 || keyword.length > 120) return const [];
    final now = DateTime.now();
    _cache.removeWhere((_, entry) => !entry.expires.isAfter(now));
    final cached = _cache.remove(keyword);
    if (cached != null) {
      _cache[keyword] = cached;
      return cached.items;
    }
    final token = CancelToken();
    _pending = token;
    // A fixed same-origin edge route forwards only to Google suggestions.
    final origin = kIsWeb ? Uri.base : Uri.parse('https://re-view.kr');
    final uri = origin
        .resolve('/search-suggestions')
        .replace(queryParameters: {'q': keyword});
    try {
      final response = await _dio.getUri<String>(
        uri,
        cancelToken: token,
        options: Options(
          responseType: ResponseType.plain,
          sendTimeout: const Duration(seconds: 2),
          receiveTimeout: const Duration(seconds: 3),
          headers: const {'Accept': 'application/json'},
        ),
      );
      if (token.isCancelled) throw const FormatException('Superseded');
      final decoded = jsonDecode(response.data ?? '');
      if (decoded is! List ||
          decoded.length < 2 ||
          decoded[0] is! String ||
          decoded[0] != keyword ||
          decoded[1] is! List) {
        throw const FormatException('Invalid suggestions response');
      }
      final values = decoded[1] as List;
      if (values.isNotEmpty &&
          !values.any((value) => value is String && value.trim().isNotEmpty)) {
        throw const FormatException('Invalid suggestion entries');
      }
      final seen = <String>{keyword.toLowerCase()};
      final suggestions = <String>[];
      for (final value in values) {
        if (value is! String) continue;
        final text = value.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (text.isEmpty ||
            text.length > 120 ||
            text == '__review_suggestion_panel_placeholder__' ||
            !seen.add(text.toLowerCase())) {
          continue;
        }
        suggestions.add(text);
        if (suggestions.length == 6) break;
      }
      final items = List<String>.unmodifiable(suggestions);
      // Cache valid empty results briefly too, never malformed/timeouts.
      _cache[keyword] = (expires: now.add(_ttl), items: items);
      while (_cache.length > _maxEntries) {
        _cache.remove(_cache.keys.first);
      }
      return items;
    } finally {
      if (identical(_pending, token)) _pending = null;
    }
  }
}

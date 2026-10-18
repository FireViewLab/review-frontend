import 'dart:async';

typedef SearchSuggestionsRequested =
    Future<List<String>> Function(String query);

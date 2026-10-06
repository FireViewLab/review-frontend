import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/search/domain/entities/search_response.dart';
import 'package:re_view_front/features/search/domain/repositories/search_repository.dart';
import 'package:re_view_front/features/search/domain/usecases/search_products_use_case.dart';
import 'package:re_view_front/features/search/presentation/providers/search_providers.dart';
import 'package:re_view_front/features/search/presentation/view_models/search_state.dart';

void main() {
  test(
    'delayed and superseded searches retain the current loading state',
    () async {
      final repository = _DelayedSearch();
      final container = ProviderContainer(
        overrides: [searchRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final vm = container.read(searchViewModelProvider.notifier);
      final old = vm.search('old');
      final latest = vm.search('new');
      expect(container.read(searchViewModelProvider), isA<SearchLoading>());
      repository.requests.first.complete(
        const Success(SearchResponse(products: [], totalCount: 0)),
      );
      await old;
      expect(container.read(searchViewModelProvider), isA<SearchLoading>());
      repository.requests.last.complete(
        const Success(SearchResponse(products: [], totalCount: 0)),
      );
      await latest;
      expect(container.read(searchViewModelProvider), isA<SearchEmpty>());
    },
  );
}

class _DelayedSearch implements SearchRepository {
  final requests = <Completer<Result<SearchResponse>>>[];
  @override
  Future<Result<SearchResponse>> searchProducts(SearchParams params) {
    final pending = Completer<Result<SearchResponse>>();
    requests.add(pending);
    return pending.future;
  }
}

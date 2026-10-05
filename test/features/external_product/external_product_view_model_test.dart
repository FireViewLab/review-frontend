import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

import 'external_product_fakes.dart';

void main() {
  late FakeExternalProductRepository repository;
  late ProviderContainer container;
  final provider = externalProductViewModelProvider(kurlyRef);

  ProviderContainer build() {
    final created = ProviderContainer(
      overrides: [
        externalProductRepositoryProvider.overrideWithValue(repository),
        externalProductPollIntervalProvider.overrideWithValue(
          const Duration(milliseconds: 5),
        ),
      ],
    );
    created.listen(provider, (_, _) {});
    return created;
  }

  Future<void> waitFor(ExternalProductPhase phase) async {
    for (var i = 0; i < 200; i++) {
      if (container.read(provider).phase == phase) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    fail('phase never became $phase: ${container.read(provider).phase}');
  }

  setUp(() => repository = FakeExternalProductRepository());
  tearDown(() => container.dispose());

  test('shows a fresh product with its reviews', () async {
    container = build();
    await waitFor(ExternalProductPhase.ready);
    final state = container.read(provider);
    expect(state.product?.name, kurlyProduct.name);
    expect(state.reviews, hasLength(2));
    expect(state.isStale, isFalse);
    expect(state.hasAnalysis, isFalse);
  });

  test('shows stale data instead of waiting', () async {
    repository.products = [Success(readyOf(status: CollectionStatus.stale))];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    expect(container.read(provider).isStale, isTrue);
  });

  test('waits for a new product to be collected, then loads it', () async {
    repository.products = [const Success(queued), Success(readyOf())];
    repository.jobs = const [
      Success(CollectionJob(id: 9, status: CollectionJobStatus.pending)),
      Success(CollectionJob(id: 9, status: CollectionJobStatus.succeeded)),
    ];
    container = build();
    await waitFor(ExternalProductPhase.collecting);
    await waitFor(ExternalProductPhase.ready);
    expect(repository.jobRequests, [9, 9]);
    expect(repository.cursors, hasLength(2));
  });

  test('shows the product when only its reviews failed to collect', () async {
    repository.products = [
      const Success(queued),
      Success(readyOf(reviews: const [])),
    ];
    repository.jobs = const [
      Success(CollectionJob(id: 9, status: CollectionJobStatus.partial)),
    ];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    expect(container.read(provider).reviews, isEmpty);
  });

  test('stops with the server reason when collection fails', () async {
    repository.products = [const Success(queued)];
    repository.jobs = const [
      Success(
        CollectionJob(
          id: 9,
          status: CollectionJobStatus.failed,
          lastError: '상품 페이지를 찾지 못했습니다',
        ),
      ),
    ];
    container = build();
    await waitFor(ExternalProductPhase.unavailable);
    expect(container.read(provider).collectionError, '상품 페이지를 찾지 못했습니다');
  });

  test('keeps waiting when a status check fails once', () async {
    repository.products = [const Success(queued), Success(readyOf())];
    repository.jobs = const [
      FailureResult(Failure(message: '일시 오류')),
      Success(CollectionJob(id: 9, status: CollectionJobStatus.succeeded)),
    ];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    expect(repository.jobRequests, hasLength(2));
  });

  test('re-checks the product when no job id is given', () async {
    repository.products = [
      const Success(ExternalProductSnapshot(status: CollectionStatus.queued)),
      Success(readyOf()),
    ];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    expect(repository.jobRequests, isEmpty);
  });

  test('treats unavailable and request failures differently', () async {
    repository.products = [
      const Success(
        ExternalProductSnapshot(status: CollectionStatus.unavailable),
      ),
    ];
    container = build();
    await waitFor(ExternalProductPhase.unavailable);
    container.dispose();

    repository = FakeExternalProductRepository()..products = [failure];
    container = build();
    await waitFor(ExternalProductPhase.failure);
  });

  test('appends the next review page and skips repeated reviews', () async {
    repository.products = [
      Success(readyOf(nextCursor: 'c1')),
      Success(readyOf(reviews: [reviewOf('2'), reviewOf('3')])),
    ];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    await container.read(provider.notifier).loadMoreReviews();

    final state = container.read(provider);
    expect(repository.cursors, [null, 'c1']);
    expect(state.reviews.map((r) => r.reviewId), ['1', '2', '3']);
    expect(state.hasMoreReviews, isFalse);

    await container.read(provider.notifier).loadMoreReviews();
    expect(repository.cursors, hasLength(2));
  });

  test('keeps the reviews and the cursor when the next page fails', () async {
    repository.products = [Success(readyOf(nextCursor: 'c1')), failure];
    container = build();
    await waitFor(ExternalProductPhase.ready);
    await container.read(provider.notifier).loadMoreReviews();

    final state = container.read(provider);
    expect(state.loadMoreFailed, isTrue);
    expect(state.reviews, hasLength(2));
    expect(state.nextCursor, 'c1');
  });

  test('ignores a response that arrives after a reload', () async {
    final slow = Completer<Result<ExternalProductSnapshot>>();
    repository.pendingProduct = slow;
    container = build();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    repository.pendingProduct = null;
    repository.products = [
      Success(readyOf(reviews: [reviewOf('new')])),
    ];
    await container.read(provider.notifier).load();
    slow.complete(Success(readyOf(reviews: [reviewOf('old')])));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(container.read(provider).reviews.single.reviewId, 'new');
  });
}

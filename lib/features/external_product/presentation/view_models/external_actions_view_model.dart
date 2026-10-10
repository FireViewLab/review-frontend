import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_actions_providers.dart';

typedef ExternalActionTarget = ({
  ExternalProductRef product,
  int? springProductId,
});

class ExternalActionsState {
  const ExternalActionsState({
    this.busy = false,
    this.wished = false,
    this.cartAdded = false,
    this.initializing = false,
  });
  final bool busy, wished, cartAdded, initializing;
}

final externalActionsProvider = NotifierProvider.autoDispose
    .family<
      ExternalActionsViewModel,
      ExternalActionsState,
      ExternalActionTarget
    >(ExternalActionsViewModel.new);

class ExternalActionsViewModel extends Notifier<ExternalActionsState> {
  ExternalActionsViewModel(this.target);
  final ExternalActionTarget target;
  int? _id;
  int _generation = 0;
  @override
  ExternalActionsState build() {
    _id = target.springProductId;
    final loggedIn = ref.watch(authSessionProvider).isLoggedIn;
    final generation = ++_generation;
    if (loggedIn && _id != null) {
      Future.microtask(() => _initialize(generation));
      return const ExternalActionsState(initializing: true);
    }
    return const ExternalActionsState();
  }

  Future<void> _initialize(int generation) async {
    if (!ref.mounted || generation != _generation) return;
    final ids = await ref.read(wishlistProductIdsProvider.future);
    if (!ref.mounted || generation != _generation) return;
    state = ExternalActionsState(wished: ids.contains(_id));
  }

  Future<Result<void>?> act({required bool wishlist}) async {
    if (state.busy || state.initializing) return null;
    if (!ref.read(isLoggedInProvider)) {
      return const FailureResult(
        Failure(message: 'Login required', statusCode: 401),
      );
    }
    final generation = _generation;
    final previous = state;
    state = ExternalActionsState(
      busy: true,
      wished: previous.wished,
      cartAdded: previous.cartAdded,
    );
    if (_id == null) {
      final tag = await ref
          .read(externalActionsRepositoryProvider)
          .tag(target.product);
      if (!ref.mounted || generation != _generation) return null;
      if (tag case FailureResult<int>(:final failure)) {
        state = previous;
        return FailureResult(failure);
      }
      _id = (tag as Success<int>).value;
    }
    final result = wishlist
        ? (previous.wished
              ? await ref.read(wishlistRepositoryProvider).removeWishlist(_id!)
              : await ref.read(wishlistRepositoryProvider).addWishlist(_id!))
        : await ref.read(cartRepositoryProvider).addItem(_id!);
    if (!ref.mounted || generation != _generation) return null;
    final successful =
        result is Success<void> ||
        (wishlist &&
            result is FailureResult<void> &&
            result.failure.code == 'WISHLIST_ALREADY_EXISTS');
    state = ExternalActionsState(
      wished: wishlist && successful ? !previous.wished : previous.wished,
      cartAdded: !wishlist && successful ? true : previous.cartAdded,
    );
    if (successful) {
      if (wishlist) {
        refreshWishlistSnapshot(ref);
        ref.invalidate(wishlistButtonProvider(_id!));
      } else {
        refreshCartSnapshot(ref);
        ref.invalidate(cartButtonProvider(_id!));
      }
      return const Success(null);
    }
    return result;
  }
}

typedef ExternalReviewTarget = ({ExternalProductRef product, String reviewId});
final externalReviewActionsProvider = NotifierProvider.autoDispose
    .family<ExternalReviewActionsViewModel, bool, ExternalReviewTarget>(
      ExternalReviewActionsViewModel.new,
    );

class ExternalReviewActionsViewModel extends Notifier<bool> {
  ExternalReviewActionsViewModel(this.target);
  final ExternalReviewTarget target;
  int _generation = 0;
  @override
  bool build() {
    ref.watch(authSessionProvider);
    _generation++;
    return false;
  }

  Future<Result<void>?> submit({
    String? feedbackType,
    String? reason,
    String? detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) async {
    if (state) return null;
    if (!ref.read(isLoggedInProvider)) {
      return const FailureResult(
        Failure(message: 'Login required', statusCode: 401),
      );
    }
    final generation = _generation;
    state = true;
    final repo = ref.read(externalActionsRepositoryProvider);
    final result = feedbackType != null
        ? await repo.feedback(target.product, target.reviewId, feedbackType)
        : await repo.report(
            target.product,
            target.reviewId,
            reason: reason!,
            detail: detail!,
            includeAiEvidence: includeAiEvidence,
            attachmentUrl: attachmentUrl,
          );
    if (!ref.mounted || generation != _generation) return null;
    state = false;
    return result;
  }
}

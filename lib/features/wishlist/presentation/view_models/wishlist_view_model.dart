import 'package:re_view_front/shared/presentation/action_feedback.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';

class WishlistViewModel extends Notifier<WishlistState> {
  late GetWishlistUseCase _getWishlistUseCase;
  late ToggleWishlistUseCase _toggleWishlistUseCase;

  int _generation = 0;

  @override
  WishlistState build() {
    _generation++;
    final loggedIn = ref.watch(authSessionProvider).isLoggedIn;
    _getWishlistUseCase = ref.watch(getWishlistUseCaseProvider);
    _toggleWishlistUseCase = ref.watch(toggleWishlistUseCaseProvider);
    if (loggedIn) {
      Future.microtask(() {
        if (ref.mounted) load();
      });
    }
    return loggedIn ? const WishlistInitial() : const WishlistEmpty();
  }

  Future<void> load() async {
    if (!ref.mounted) return;
    if (!ref.read(isLoggedInProvider)) {
      state = const WishlistEmpty();
      return;
    }

    final generation = ++_generation;
    final previous = state is WishlistSuccess ? state as WishlistSuccess : null;
    if (previous == null) state = const WishlistLoading();

    final result = await _getWishlistUseCase();

    if (!ref.mounted || generation != _generation) return;
    state = result.when(
      success: (data) => data.items.isEmpty
          ? const WishlistEmpty()
          : WishlistSuccess(items: data.items, summary: data.summary),
      failure: (failure) =>
          previous?.copyWith(
            togglingProductIds: {},
            errorMessage: failure.message,
          ) ??
          WishlistFailure(failure),
    );
  }

  Future<Result<void>?> removeItem(int productId) async {
    if (!ref.read(isLoggedInProvider)) return null;

    final current = state;
    if (current is! WishlistSuccess || current.togglingProductIds.isNotEmpty) {
      return null;
    }
    final generation = _generation;

    state = current.copyWith(togglingProductIds: {productId}, clearError: true);

    final result = await _toggleWishlistUseCase.remove(productId);

    if (!ref.mounted || generation != _generation) return null;

    await result.when<Future<void>>(
      success: (_) async {
        ActionFeedback.selection();
        refreshWishlistSnapshot(ref);
        await load();
      },
      failure: (failure) async {
        if (state is WishlistSuccess) {
          final s = state as WishlistSuccess;
          state = s.copyWith(
            togglingProductIds: {},
            errorMessage: failure.message,
          );
        }
      },
    );
    return result;
  }

  Future<Result<void>?> restoreItem(int productId) async {
    if (!ref.read(isLoggedInProvider)) return null;
    final current = state;
    if (current is! WishlistEmpty && current is! WishlistSuccess) return null;
    if (current is WishlistSuccess && current.togglingProductIds.isNotEmpty) {
      return null;
    }
    final generation = _generation;
    final session = ref.read(authSessionProvider);
    state = current is WishlistSuccess
        ? current.copyWith(togglingProductIds: {productId}, clearError: true)
        : const WishlistLoading();
    final result = await _toggleWishlistUseCase.add(productId);
    if (!ref.mounted ||
        generation != _generation ||
        ref.read(authSessionProvider) != session) {
      return null;
    }
    final alreadySaved =
        result is FailureResult<void> &&
        result.failure.code == 'WISHLIST_ALREADY_EXISTS';
    if (result is Success<void> || alreadySaved) {
      if (result is Success<void>) ActionFeedback.selection();
      refreshWishlistSnapshot(ref);
      ref.invalidate(wishlistButtonProvider(productId));
      await load();
      return const Success(null);
    }
    await load();
    return result;
  }
}

import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/warning_products_section.dart';
import 'package:re_view_front/features/recent_products/presentation/widgets/recent_products_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_body.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  final _topKey = GlobalKey();
  final _savedKey = GlobalKey();
  final _recentKey = GlobalKey();
  final _settingsKey = GlobalKey();
  final _accountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wishlistViewModelProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myPageState = ref.watch(myPageViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistCount = switch (wishlistState) {
      WishlistSuccess(:final items) => items.length,
      WishlistEmpty() => 0,
      _ => null,
    };

    return switch (myPageState) {
      MyPageLoading() => SizedBox(
        height: 360,
        child: AppLoadingView(
          message: AppLocalizations.of(context).myPageLoading,
        ),
      ),
      MyPageFailure(:final failure) => SizedBox(
        height: 360,
        child: AppErrorView(
          message: failure.message,
          onRetry: () => ref.read(myPageViewModelProvider.notifier).load(),
        ),
      ),
      MyPageSuccess(:final profile) => MyPageBody(
        profile: profile,
        wishlistState: wishlistState,
        wishlistCount: wishlistCount,
        onProductTap: _goProductDetail,
        onWishlistTap: () => context.go(RoutePaths.wishlist),
        onPasswordTap: () => context.go(RoutePaths.passwordReset),
        onRecentTap: () => showRecentProducts(context),
        onReviewTap: () => showWarningProducts(context),
        onSettingsTap: () => _scrollTo(_settingsKey),
        onAccountTap: () => _scrollTo(_accountKey),
        topKey: _topKey,
        savedKey: _savedKey,
        recentKey: _recentKey,
        settingsKey: _settingsKey,
        accountKey: _accountKey,
      ),
    };
  }

  void _goProductDetail(String productId) {
    if (productId.startsWith('/product/')) {
      context.go(productId);
      return;
    }
    context.goNamed(
      RouteNames.productDetail,
      pathParameters: {'id': productId},
    );
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: AppMotion.slow,
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }
}

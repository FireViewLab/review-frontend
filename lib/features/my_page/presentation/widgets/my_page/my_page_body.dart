// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/home/presentation/view_models/home_dashboard_state.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';
import 'package:re_view_front/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:re_view_front/features/wishlist/presentation/view_models/wishlist_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_stats.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_common.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_saved_products.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_activity.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_trust_summary.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_account.dart';
import 'package:re_view_front/features/my_page/presentation/widgets/my_page/my_page_navigation.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({
    required this.profile,
    required this.dashboardState,
    required this.wishlistState,
    required this.wishlistCount,
    required this.onProductTap,
    required this.onWishlistTap,
    required this.onPasswordTap,
    required this.onRecentTap,
    required this.onReviewTap,
    required this.onSettingsTap,
    required this.onAccountTap,
    required this.topKey,
    required this.savedKey,
    required this.recentKey,
    required this.settingsKey,
    required this.accountKey,
  });

  final UserProfile profile;
  final HomeDashboardState dashboardState;
  final WishlistState wishlistState;
  final int wishlistCount;
  final ValueChanged<String> onProductTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onPasswordTap;
  final VoidCallback onRecentTap;
  final VoidCallback onReviewTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onAccountTap;
  final GlobalKey topKey;
  final GlobalKey savedKey;
  final GlobalKey recentKey;
  final GlobalKey settingsKey;
  final GlobalKey accountKey;

  @override
  Widget build(BuildContext context) {
    final savedItems = _wishlistItems;
    final recentProducts = _recentProducts;
    final riskyProducts = _riskyProducts;
    final savedAverageRti = _savedAverageRti;
    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer(
          builder: (context, ref, _) => MyPageStatGrid(
            wishlistCount: wishlistCount,
            recentCount: recentProducts.length,
            riskyCount: riskyProducts.length,
            notificationCount:
                ref.watch(unreadNotificationCountProvider).value ?? 0,
            onWishlistTap: onWishlistTap,
            onRecentTap: onRecentTap,
            onReviewTap: onReviewTap,
            onNotificationTap: () => context.go(RoutePaths.notifications),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        KeyedSubtree(
          key: savedKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyPageSectionHeader(
                title: AppLocalizations.of(context).myPageInterestProducts,
                onMore: onWishlistTap,
              ),
              const SizedBox(height: AppSpacing.md),
              MyPageSavedProductsSection(
                items: savedItems,
                isLoading:
                    wishlistState is WishlistLoading ||
                    wishlistState is WishlistInitial,
                onProductTap: (id) => onProductTap(id.toString()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        MyPageResponsiveTwoColumn(
          left: KeyedSubtree(
            key: recentKey,
            child: MyPageRecentActivitySection(
              savedItems: savedItems,
              recentProducts: recentProducts,
              onProductTap: onProductTap,
            ),
          ),
          right: KeyedSubtree(
            key: settingsKey,
            child: MyPageTrustSummaryPanel(
              savedAverageRti: savedAverageRti,
              riskyCount: riskyProducts.length,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        KeyedSubtree(
          key: accountKey,
          child: MyPageAccountSection(
            profile: profile,
            onPasswordTap: onPasswordTap,
            onSettingsTap: onSettingsTap,
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyedSubtree(
          key: topKey,
          child: MyPageTitle(profile: profile),
        ),
        const SizedBox(height: AppSpacing.lg),
        mainContent,
      ],
    );
  }

  List<WishlistItem> get _wishlistItems {
    return switch (wishlistState) {
      WishlistSuccess(:final items) => items,
      _ => const [],
    };
  }

  List<DashboardProduct> get _recentProducts {
    return switch (dashboardState) {
      HomeDashboardSuccess(:final dashboard) => dashboard.recentProducts,
      _ => const [],
    };
  }

  List<DashboardProduct> get _riskyProducts {
    return switch (dashboardState) {
      HomeDashboardSuccess(:final dashboard) => dashboard.riskyProducts,
      _ => const [],
    };
  }

  double? get _savedAverageRti {
    final scoredItems = _wishlistItems.where(
      (item) => item.avgRti != null && item.avgRti! > 0,
    );
    if (scoredItems.isEmpty) return null;

    final total = scoredItems.fold<double>(
      0,
      (sum, item) => sum + item.avgRti!,
    );
    return total / scoredItems.length;
  }
}

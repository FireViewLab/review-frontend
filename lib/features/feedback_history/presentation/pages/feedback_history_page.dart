import 'package:re_view_front/features/external_product/presentation/widgets/external_history_review_content.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_history_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/feedback_history/domain/entities/feedback_item.dart';
import 'package:re_view_front/features/feedback_history/presentation/providers/feedback_history_providers.dart';
import 'package:re_view_front/features/feedback_history/presentation/view_models/feedback_history_state.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';

class FeedbackHistoryPage extends ConsumerStatefulWidget {
  const FeedbackHistoryPage({super.key});

  @override
  ConsumerState<FeedbackHistoryPage> createState() =>
      _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends ConsumerState<FeedbackHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(feedbackHistoryViewModelProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackHistoryViewModelProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final nickname = ref.watch(userNicknameProvider).value;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              navItems: homeNavItems,
              selectedNavItem: '',
              isLoggedIn: isLoggedIn,
              nickname: nickname,
              onLoginPressed: () => context.go(RoutePaths.login),
              onWishPressed: () => context.go(RoutePaths.wishlist),
              onCartPressed: () => context.go(RoutePaths.cart),
              onNavItemPressed: (item) => openHomeNavItem(context, item),
              onLogoPressed: () => context.go(RoutePaths.home),
              onSearchSubmitted: (q) {
                if (q.trim().isNotEmpty) {
                  context.goNamed(
                    RouteNames.search,
                    queryParameters: {'q': q.trim()},
                  );
                }
              },
              searchKeywords: const [],
              searchRecommendedProducts: const [],
              onSearchSuggestionsRequested: _handleSearchSuggestionsRequested,
              onMyPagePressed: () =>
                  context.go(isLoggedIn ? RoutePaths.myPage : RoutePaths.login),
              onProfileWishPressed: () => context.go(RoutePaths.wishlist),
              onProfileOrderPressed: () => context.go(RoutePaths.cart),
              onLogoutPressed: () {
                ref.read(authTokenStoreProvider.notifier).clear();
                context.go(RoutePaths.landing);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1320,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(onBack: () => context.go(RoutePaths.myPage)),
                  const SizedBox(height: AppSpacing.xl),
                  switch (state) {
                    FeedbackHistoryInitial() ||
                    FeedbackHistoryLoading() =>
                      SizedBox(
                        height: 320,
                        child: AppLoadingView(
                          message: AppLocalizations.of(context).feedbackHistoryLoading,
                        ),
                      ),
                    FeedbackHistoryFailure(:final failure) => SizedBox(
                      height: 320,
                      child: AppErrorView(
                        message: failure.message,
                        onRetry: () => ref
                            .read(feedbackHistoryViewModelProvider.notifier)
                            .load(),
                      ),
                    ),
                    FeedbackHistoryEmpty() => _EmptyBody(
                      onGoHome: () => context.go(RoutePaths.home),
                    ),
                    FeedbackHistorySuccess(:final items) => _FeedbackList(
                      items: items,
                      onProductTap: (productId) => context.goNamed(
                        RouteNames.productDetail,
                        pathParameters: {'id': productId.toString()},
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _handleSearchSuggestionsRequested(String query) {
    return ref
        .read(searchAutocompleteRemoteDataSourceProvider)
        .fetchSuggestions(query);
  }


}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () => context.go(RoutePaths.home),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(AppLocalizations.of(context).navHome),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(AppLocalizations.of(context).navMyPage),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.chevron_right, size: 16),
            ),
            Text(
              AppLocalizations.of(context).feedbackHistoryTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).feedbackHistoryTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          AppLocalizations.of(context).feedbackHistorySubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.rate_review_outlined,
            size: 56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context).feedbackHistoryEmpty,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context).feedbackHistoryEmptyDesc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: onGoHome,
            child: Text(AppLocalizations.of(context).wishlistBrowse),
          ),
        ],
      ),
    );
  }
}

class _FeedbackList extends StatelessWidget {
  const _FeedbackList({required this.items, required this.onProductTap});

  final List<FeedbackItem> items;
  final ValueChanged<int> onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).feedbackHistoryCount(items.length),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final item in items) ...[
          _FeedbackCard(
            item: item,
            onProductTap: externalHistoryTarget(item.productExternalId) != null
                ? () => context.go(externalHistoryTarget(item.productExternalId)!.routePath)
                : item.productId != null
                ? () => onProductTap(item.productId!)
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.item, this.onProductTap});

  final FeedbackItem item;
  final VoidCallback? onProductTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusChip(status: item.status),
                const SizedBox(width: AppSpacing.sm),
                _TypeChip(typeLabel: item.typeLabel),
                const Spacer(),
                if (item.createdAt != null)
                  Text(
                    _formatDate(item.createdAt!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (item.productName.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      item.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (onProductTap != null)
                    InkWell(
                      onTap: onProductTap,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        child: Text(
                          l10n.feedbackHistoryViewProduct,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if ((item.reviewContent ?? item.productName).isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ExternalHistoryReviewContent(
                  reviewContent: item.reviewContent,
                  productName: item.productName,
                  productExternalId: item.productExternalId,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status.toUpperCase()) {
      'SUBMITTED' => (l10n.feedbackStatusSubmitted, const Color(0xFF6366F1)),
      'UNDER_REVIEW' => (l10n.feedbackStatusPending, const Color(0xFFD97706)),
      'RESOLVED' || 'ACCEPTED' => (l10n.feedbackStatusAccepted, const Color(0xFF16A34A)),
      'REJECTED' => (l10n.feedbackStatusRejected, AppColors.error),
      _ => (l10n.feedbackStatusPending, const Color(0xFFD97706)),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.typeLabel});

  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          typeLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

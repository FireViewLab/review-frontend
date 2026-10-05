import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/home_navigation.dart';
import 'package:re_view_front/features/home/presentation/providers/home_providers.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/home_header.dart';
import 'package:re_view_front/features/plan/presentation/plan_labels.dart';
import 'package:re_view_front/features/plan/presentation/providers/plan_providers.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_state.dart';
import 'package:re_view_front/features/plan/presentation/widgets/plan_cards.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

/// 현재 요금제를 보고 다른 요금제로 바꾸는 화면.
class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onSearchSuggestionsRequested: (query) => ref
                  .read(searchAutocompleteRemoteDataSourceProvider)
                  .fetchSuggestions(query),
              onMyPagePressed: () => context.go(RoutePaths.myPage),
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
              maxWidth: 1040,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: const PlanContent(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 요금제 화면의 본문. 헤더 없이 따로 쓸 수 있다.
class PlanContent extends ConsumerWidget {
  const PlanContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(planViewModelProvider);
    final vm = ref.read(planViewModelProvider.notifier);

    ref.listen(planViewModelProvider.select((s) => s.notice), (_, notice) {
      if (notice == null) return;
      final plan = planLabel(
        l10n,
        ref.read(planViewModelProvider).noticeCode ?? '',
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(switch (notice) {
              PlanNotice.changed => l10n.planChanged(plan),
              PlanNotice.unavailable => l10n.planChangeUnavailable,
              PlanNotice.failed => l10n.planChangeFailed,
            }),
          ),
        );
      vm.clearNotice();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.planTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.planSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        switch (state.status) {
          PlanStatus.loading => const SizedBox(
            height: 320,
            child: AppLoadingView(),
          ),
          PlanStatus.failure => SizedBox(
            height: 320,
            child: AppErrorView(message: l10n.planLoadFailed, onRetry: vm.load),
          ),
          PlanStatus.ready => _PlanBody(
            state: state,
            onSelect: (code) => _confirmChange(context, ref, code),
          ),
        },
      ],
    );
  }

  Future<void> _confirmChange(
    BuildContext context,
    WidgetRef ref,
    String code,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.planConfirmTitle(planLabel(l10n, code))),
        content: Text(l10n.planConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.planCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.planConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(planViewModelProvider.notifier).change(code);
  }
}

class _PlanBody extends StatelessWidget {
  const _PlanBody({required this.state, required this.onSelect});

  final PlanState state;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final quota = state.quota!;
    final current = quota.planCode.toUpperCase();
    List<Widget> cards({required bool fillHeight}) => [
      for (final option in state.options)
        PlanOptionCard(
          option: option,
          isCurrent: option.code.toUpperCase() == current,
          isChanging: state.changingCode == option.code,
          currentQuota: quota,
          fillHeight: fillHeight,
          onSelect: state.isChanging ? null : () => onSelect(option.code),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CurrentPlanCard(quota: quota, expiresAt: state.expiresAt),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            // 좁은 화면에서는 카드를 세로로 쌓는다.
            if (constraints.maxWidth < 720) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final card in cards(fillHeight: false))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: card,
                    ),
                ],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, card) in cards(
                    fillHeight: true,
                  ).indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: card),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

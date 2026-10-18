import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/plan/presentation/plan_labels.dart';
import 'package:re_view_front/features/plan/presentation/providers/plan_providers.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_state.dart';
import 'package:re_view_front/features/plan/presentation/widgets/plan_cards.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

/// 현재 요금제를 보고 다른 요금제로 바꾸는 화면. 계정 영역의 공통 틀 안에 들어간다.
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
              PlanNotice.refreshFailed =>
                '요금제 변경 요청은 처리됐지만 현재 플랜과 한도를 확인하지 못했습니다. 다시 불러와 확인해 주세요.',
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
        OutlinedButton.icon(
          onPressed: () => context.push(RoutePaths.testPayment),
          icon: const Icon(Icons.science_outlined),
          label: const Text('토스 TEST 서비스 결제'),
        ),
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

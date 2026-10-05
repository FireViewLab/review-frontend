import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/plan/domain/entities/plan_option.dart';
import 'package:re_view_front/features/plan/presentation/plan_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

String _two(int value) => value.toString().padLeft(2, '0');

/// 지금 쓰는 요금제와 오늘 사용량.
class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({super.key, required this.quota, this.expiresAt});

  final ChatQuota quota;
  final DateTime? expiresAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final resetAt = quota.resetAt?.toLocal();
    final expires = expiresAt?.toLocal();
    final details = [
      if (resetAt != null)
        l10n.planResetAt('${_two(resetAt.hour)}:${_two(resetAt.minute)}'),
      if (expires != null)
        l10n.planExpiresAt(
          '${expires.year}.${_two(expires.month)}.${_two(expires.day)}',
        ),
    ];

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.planCurrent,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            planLabel(l10n, quota.planCode, fallback: quota.planName),
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            quota.isUnlimited
                ? l10n.planUsageUnlimited(quota.usedToday)
                : l10n.planUsageToday(quota.usedToday, quota.dailyLimit),
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!quota.isUnlimited && quota.dailyLimit > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: (quota.usedToday / quota.dailyLimit).clamp(0, 1),
                  backgroundColor: AppColors.border,
                  color: quota.remaining <= 0
                      ? AppColors.warning
                      : AppColors.primary,
                ),
              ),
            ),
          ],
          if (details.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              details.join(' · '),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 고를 수 있는 요금제 하나를 보여 주는 카드.
class PlanOptionCard extends StatelessWidget {
  const PlanOptionCard({
    super.key,
    required this.option,
    required this.isCurrent,
    required this.isChanging,
    required this.onSelect,
    this.currentQuota,
    this.fillHeight = false,
  });

  /// 옆 카드와 높이를 맞춰 버튼을 아래에 붙인다. 높이가 정해진 가로 배치에서만 쓴다.
  final bool fillHeight;

  final PlanOption option;
  final bool isCurrent;
  final bool isChanging;

  /// null이면 누를 수 없다.
  final VoidCallback? onSelect;

  /// 이 카드가 현재 요금제일 때, 목록에 한도가 없으면 여기서 가져온다.
  final ChatQuota? currentQuota;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final code = option.code.toUpperCase();
    final dailyLimit =
        option.dailyLimit ?? (isCurrent ? currentQuota?.dailyLimit : null);
    // 프로 모드는 서버가 프로 요금제에만 열어 준다.
    final hasPro = option.proAvailable ?? code == 'PRO';

    final features = [
      if (dailyLimit == ChatQuota.unlimited)
        l10n.planDailyUnlimited
      else if (dailyLimit != null)
        l10n.planDailyQuestions(dailyLimit)
      else
        switch (code) {
          'FREE' => l10n.planFeatureLimited,
          'PLUS' => l10n.planFeatureMore,
          'PRO' => l10n.planFeatureMost,
          _ => null,
        },
      l10n.planFeatureStandard,
      if (hasPro) l10n.planFeaturePro,
    ].whereType<String>();

    return _Panel(
      highlighted: isCurrent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  planLabel(l10n, option.code),
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  child: Text(
                    l10n.planCurrentBadge,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      feature,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (fillHeight) const Spacer(),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 44,
            child: isCurrent
                ? OutlinedButton(
                    onPressed: null,
                    child: Text(l10n.planCurrentBadge),
                  )
                : FilledButton(
                    onPressed: onSelect,
                    child: isChanging
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : Text(l10n.planSelect),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.highlighted = false});

  final Widget child;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}

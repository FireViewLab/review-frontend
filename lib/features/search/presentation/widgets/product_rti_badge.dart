import 'package:re_view_front/shared/presentation/analysis_formatters.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class RtiBadge extends ConsumerWidget {
  const RtiBadge({
    super.key,
    required this.value,
    required this.color,
    this.analysis,
  });

  final AnalysisDisplay? analysis;
  final int? value;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(confirmedDisplayPreferencesProvider);
    if (preferences?.rtiLabelStyle == 'NONE') return const SizedBox.shrink();
    final large = preferences?.rtiLabelStyle == 'BADGE_LARGE';
    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        borderRadius: AppRadius.small,
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value == null
                  ? Icons.hourglass_empty
                  : Icons.verified_user_outlined,
              color: value == null ? AppColors.textTertiary : color,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                analysis?.isV2 == true
                    ? analysis!.badgeText(context)
                    : (value == null ? '분석 전' : 'RTI $value'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: value == null ? AppColors.textTertiary : color,
                  fontWeight: FontWeight.w900,
                  fontSize: large ? 15 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final reasons = analysis?.localizedReasons(context) ?? const <String>[];
    return reasons.isEmpty
        ? badge
        : Tooltip(message: reasons.join('\n'), child: badge);
  }
}

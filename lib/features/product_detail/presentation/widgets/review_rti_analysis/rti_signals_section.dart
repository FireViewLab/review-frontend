import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/review_analysis_section.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_section_card.dart';

class RtiSignalsSection extends StatelessWidget {
  const RtiSignalsSection({super.key, required this.signals});

  final List<RtiSignal> signals;

  @override
  Widget build(BuildContext context) {
    return RtiSectionCard(
      title: 'RTI 구성 신호',
      showInfo: true,
      infoTooltip: 'RTI 점수를 구성하는 신호와 각각의 점수입니다.\n텍스트·행동·네트워크 분석을 종합해 산출합니다.',
      child: Column(
        children: signals
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: RtiSignalBar(signal: s),
              ),
            )
            .toList(),
      ),
    );
  }
}

class RtiSignalBar extends StatelessWidget {
  const RtiSignalBar({super.key, required this.signal});

  final RtiSignal signal;

  IconData get _icon => switch (signal.iconType) {
    'text' => Icons.person_outline,
    'behavior' => Icons.check_circle_outline,
    'pattern' => Icons.text_fields_outlined,
    'purchase' => Icons.verified_user_outlined,
    _ => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(signal.color);
    final ratio = (signal.score / 100).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 16, color: color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      signal.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${signal.score}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio),
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : AppMotion.slow,
                  curve: Curves.easeOutCubic,
                  builder: (_, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Judgment Basis Section ───────────────────────────────────────────────────

class RtiJudgmentBasisSection extends StatelessWidget {
  const RtiJudgmentBasisSection({super.key, required this.bases});

  final List<RtiJudgmentBasis> bases;

  @override
  Widget build(BuildContext context) {
    return RtiSectionCard(
      title: AppLocalizations.of(context).reportReasons,
      showInfo: true,
      infoTooltip: '리뷰 신뢰도를 판단한 구체적인 근거와\n각 근거가 점수에 기여한 비중입니다.',
      child: Column(
        children: bases
            .map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: RtiJudgmentBasisItem(basis: b),
              ),
            )
            .toList(),
      ),
    );
  }
}

class RtiJudgmentBasisItem extends StatelessWidget {
  const RtiJudgmentBasisItem({super.key, required this.basis});

  final RtiJudgmentBasis basis;

  IconData get _icon => switch (basis.iconType) {
    'repeat' => Icons.repeat_outlined,
    'context' => Icons.sentiment_satisfied_alt_outlined,
    'history' => Icons.scatter_plot_outlined,
    'similarity' => Icons.alarm_outlined,
    _ => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(basis.color);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 14, color: color),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ReviewEvidenceFormatter.text(
                    context,
                    basis.label.isNotEmpty ? basis.label : basis.description,
                  ),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(
                  ReviewEvidenceFormatter.text(
                    context,
                    basis.description,
                    detailed: true,
                  ),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${basis.percentage}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reasons Section (fallback when no rtiDetail) ────────────────────────────

class RtiReasonsSection extends StatelessWidget {
  const RtiReasonsSection({
    super.key,
    required this.reasons,
    required this.color,
  });
  final List<String> reasons;
  final Color color;
  @override
  Widget build(BuildContext context) => RtiSectionCard(
    title: AppLocalizations.of(context).reportReasons,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final reason in ReviewEvidenceFormatter.list(
          context,
          reasons,
          detailed: true,
        ))
          ReviewEvidenceText(text: reason),
      ],
    ),
  );
}

// ─── Footer ───────────────────────────────────────────────────────────────────

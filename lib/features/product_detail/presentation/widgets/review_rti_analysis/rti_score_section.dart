import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_section_card.dart';

class RtiRiskSummarySection extends StatelessWidget {
  const RtiRiskSummarySection({
    super.key,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    final total = safeCount + warnCount + dangerCount;

    return RtiSectionCard(
      title: '종합 위험 요약',
      showInfo: true,
      infoTooltip: '이 상품의 전체 리뷰에 대한\nAI 신뢰도 분석 결과입니다.',
      child: Column(
        children: [
          RtiRiskBar(
            label: '안전',
            count: safeCount,
            total: total,
            color: const Color(0xFF22C55E),
          ),
          const SizedBox(height: AppSpacing.xs),
          RtiRiskBar(
            label: '의심',
            count: warnCount,
            total: total,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: AppSpacing.xs),
          RtiRiskBar(
            label: '위험',
            count: dangerCount,
            total: total,
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class RtiRiskBar extends StatelessWidget {
  const RtiRiskBar({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    final pct = (ratio * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: ClipRRect(
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
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 52,
          child: Text(
            '$count ($pct%)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ─── RTI Score Card ───────────────────────────────────────────────────────────

class RtiScoreCard extends StatelessWidget {
  const RtiScoreCard({super.key, required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(review.rtiColor);

    return RtiSectionCard(
      title: AppLocalizations.of(context).reviewResultTitle,
      showInfo: true,
      infoTooltip: 'RTI 신뢰도 점수는 구매 인증, 텍스트 신뢰도,\n반복 표현, 시점 패턴 등을 종합해 산출됩니다.',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            review.rtiScore != null ? 'RTI ${review.rtiScore}' : '분석 전',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 36,
              height: 1,
            ),
          ),
          if (review.rtiScore != null &&
              review.rtiLabel?.isNotEmpty == true) ...[
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RtiGradeBadge(label: review.rtiLabel!, color: color),
            ),
          ],
        ],
      ),
    );
  }
}

class RtiGradeBadge extends StatelessWidget {
  const RtiGradeBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RTI Signals Section ──────────────────────────────────────────────────────

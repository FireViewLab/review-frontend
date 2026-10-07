import 'package:re_view_front/shared/widgets/rti_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/domain/entities/review_rti_detail.dart';
import 'package:re_view_front/features/review_report/presentation/providers/review_report_dep_providers.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

void showReviewRtiAnalysisDialog(
  BuildContext context,
  ProductReview review, {
  int safeCount = 0,
  int warnCount = 0,
  int dangerCount = 0,
  int? productId,
  String productName = '',
}) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.overlay,
    builder: (_) => ReviewRtiAnalysisDialog(
      review: review,
      safeCount: safeCount,
      warnCount: warnCount,
      dangerCount: dangerCount,
      productId: productId,
      productName: productName,
    ),
  );
}

class ReviewRtiAnalysisDialog extends StatelessWidget {
  const ReviewRtiAnalysisDialog({
    super.key,
    required this.review,
    this.safeCount = 0,
    this.warnCount = 0,
    this.dangerCount = 0,
    this.productId,
    this.productName = '',
  });

  final ProductReview review;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width < 600 ? 12 : 24,
        vertical: 16,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 860),
        child: ClipRRect(
          borderRadius: AppRadius.large,
          child: Material(
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(onClose: () => Navigator.of(context).pop()),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: _DialogBody(
                      review: review,
                      safeCount: safeCount,
                      warnCount: warnCount,
                      dangerCount: dangerCount,
                    ),
                  ),
                ),
                _DialogFooter(
                  onClose: () => Navigator.of(context).pop(),
                  review: review,
                  productId: productId,
                  productName: productName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Analysis',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '리뷰 상세 분석',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'RTI는 구매 인증, 텍스트 신뢰도, 반복 표현, 시점 패턴 등 다양한 신호를 종합해 리뷰를 분석합니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceMuted,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dialog Body ─────────────────────────────────────────────────────────────

class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.review,
    required this.safeCount,
    required this.warnCount,
    required this.dangerCount,
  });

  final ProductReview review;
  final int safeCount;
  final int warnCount;
  final int dangerCount;

  @override
  Widget build(BuildContext context) {
    final detail = review.rtiDetail;
    final total = safeCount + warnCount + dangerCount;

    final panels = <Widget>[
      // Left panel: selected review + risk summary
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SelectedReviewSection(review: review),
          if (total > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _RiskSummarySection(
              safeCount: safeCount,
              warnCount: warnCount,
              dangerCount: dangerCount,
            ),
          ],
        ],
      ),
      // Right panel: score card + signal bars + judgment bases
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RtiScoreCard(review: review),
          if (detail != null && detail.signals.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _RtiSignalsSection(signals: detail.signals),
          ],
          if (detail != null && detail.judgmentBases.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _JudgmentBasisSection(bases: detail.judgmentBases),
          ] else if (detail == null && review.reasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _ReasonsSection(
              reasons: review.reasons,
              color: colorFromHex(review.rtiColor),
            ),
          ],
        ],
      ),
    ];
    if (MediaQuery.sizeOf(context).width < 700) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          panels[0],
          const SizedBox(height: AppSpacing.md),
          panels[1],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: panels[0]),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: panels[1]),
      ],
    );
  }
}

// ─── Selected Review Section ─────────────────────────────────────────────────

class _SelectedReviewSection extends StatelessWidget {
  const _SelectedReviewSection({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final images = review.imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
    return _SectionCard(
      title: '선택된 리뷰',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewAuthorRow(review: review),
          const SizedBox(height: AppSpacing.sm),
          Text(
            review.content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              height: 1.65,
            ),
          ),
          if (review.hashtags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: review.hashtags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '# $tag',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 64,
              child: Builder(
                builder: (_) {
                  final total = images.length;
                  final shown = total.clamp(0, 3);
                  final hasMore = total > 3;
                  final itemCount = shown + (hasMore ? 1 : 0);
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemCount,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (_, i) {
                      if (i >= shown) {
                        return ImagePreviewThumbnail(
                          imageUrls: images,
                          index: shown,
                          size: 64,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: AppRadius.small,
                              border: Border.all(color: AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+${total - 3}',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        );
                      }
                      return ImagePreviewThumbnail(
                        imageUrls: images,
                        index: i,
                        size: 64,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewAuthorRow extends StatelessWidget {
  const _ReviewAuthorRow({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primaryLight,
          backgroundImage: review.authorAvatarUrl != null
              ? NetworkImage(review.authorAvatarUrl!)
              : null,
          child: review.authorAvatarUrl == null
              ? const Icon(Icons.person, size: 18, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  _PlatformBadge(platform: review.platform),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (review.isVerifiedPurchase) ...[
                    const Icon(
                      Icons.shield_outlined,
                      size: 11,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '구매인증',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  for (var i = 0; i < 5; i++)
                    Icon(
                      i < review.rating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFF59E0B),
                      size: 12,
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    review.createdAt,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final String platform;

  Color get _color {
    return switch (platform) {
      '네이버쇼핑' => const Color(0xFF03C75A),
      '쿠팡' => const Color(0xFFEE2F3B),
      '11번가' => const Color(0xFFFF5000),
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        platform,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Risk Summary Section (종합 위험 요약) ────────────────────────────────────

class _RiskSummarySection extends StatelessWidget {
  const _RiskSummarySection({
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

    return _SectionCard(
      title: '종합 위험 요약',
      showInfo: true,
      infoTooltip: '이 상품의 전체 리뷰에 대한\nAI 신뢰도 분석 결과입니다.',
      child: Column(
        children: [
          _RiskBar(
            label: '안전',
            count: safeCount,
            total: total,
            color: const Color(0xFF22C55E),
          ),
          const SizedBox(height: AppSpacing.xs),
          _RiskBar(
            label: '의심',
            count: warnCount,
            total: total,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: AppSpacing.xs),
          _RiskBar(
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

class _RiskBar extends StatelessWidget {
  const _RiskBar({
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
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: AppMotion.slow,
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
              fontSize: 11,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ─── RTI Score Card ───────────────────────────────────────────────────────────

class _RtiScoreCard extends StatelessWidget {
  const _RtiScoreCard({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(review.rtiColor);

    return _SectionCard(
      title: 'RTI 신뢰도 점수',
      showInfo: true,
      infoTooltip: 'RTI 신뢰도 점수는 구매 인증, 텍스트 신뢰도,\n반복 표현, 시점 패턴 등을 종합해 산출됩니다.',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            review.rtiScore > 0 ? 'RTI ${review.rtiScore}' : 'RTI -',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.sizeOf(context).width < 700 ? 32 : 52,
              height: 1,
            ),
          ),
          if (review.rtiLabel.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RtiGradeBadge(label: review.rtiLabel, color: color),
            ),
          ],
        ],
      ),
    );
  }
}

class _RtiGradeBadge extends StatelessWidget {
  const _RtiGradeBadge({required this.label, required this.color});

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
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RTI Signals Section ──────────────────────────────────────────────────────

class _RtiSignalsSection extends StatelessWidget {
  const _RtiSignalsSection({required this.signals});

  final List<RtiSignal> signals;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'A. RTI 구성 신호',
      showInfo: true,
      infoTooltip: 'RTI 점수를 구성하는 신호와 각각의 점수입니다.\n텍스트·행동·네트워크 분석을 종합해 산출합니다.',
      child: Column(
        children: signals
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: _SignalBar(signal: s),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.signal});

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
                        fontSize: 12,
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
                  duration: AppMotion.slow,
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

class _JudgmentBasisSection extends StatelessWidget {
  const _JudgmentBasisSection({required this.bases});

  final List<RtiJudgmentBasis> bases;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'B. 판단 근거',
      showInfo: true,
      infoTooltip: '리뷰 신뢰도를 판단한 구체적인 근거와\n각 근거가 점수에 기여한 비중입니다.',
      child: Column(
        children: bases
            .map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: _JudgmentBasisItem(basis: b),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _JudgmentBasisItem extends StatelessWidget {
  const _JudgmentBasisItem({required this.basis});

  final RtiJudgmentBasis basis;

  IconData get _icon => switch (basis.iconType) {
    'repeat' => Icons.repeat_outlined,
    'context' => Icons.sentiment_satisfied_alt_outlined,
    'history' => Icons.scatter_plot_outlined,
    'similarity' => Icons.alarm_outlined,
    _ => Icons.info_outline,
  };

  Color _percentageColor(Color dataColor) {
    if (basis.percentage >= 80) return AppColors.success;
    if (basis.percentage >= 65) return const Color(0xFFD97706);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(basis.color);

    return Row(
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
                basis.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                basis.description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
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
            color: _percentageColor(color),
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Reasons Section (fallback when no rtiDetail) ────────────────────────────

class _ReasonsSection extends StatelessWidget {
  const _ReasonsSection({required this.reasons, required this.color});

  final List<String> reasons;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: '판단 근거',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reasons
            .map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle, size: 5, color: color),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        r,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _DialogFooter extends ConsumerWidget {
  const _DialogFooter({
    required this.onClose,
    required this.review,
    this.productId,
    this.productName = '',
  });

  final VoidCallback onClose;
  final ProductReview review;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alreadyReported = ref
        .watch(reportedReviewIdsProvider)
        .contains(review.id);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 13,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '분석 결과는 참고용이며 최종 판단은 여러 리뷰를 함께 확인해주세요.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: onClose,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderStrong),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: const Text('닫기', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: () => showRtiCriteriaDialog(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: const Text('분석 기준', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: AppSpacing.xs),
          OutlinedButton(
            onPressed: alreadyReported
                ? () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('이미 신고한 리뷰'),
                        content: const Text(
                          '이 리뷰는 이미 신고하셨습니다.\n중복 신고는 접수되지 않아요.',
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  }
                : () {
                    Navigator.of(context).pop();
                    context.goNamed(
                      RouteNames.reviewReport,
                      extra: {
                        'reviewId': review.id,
                        'productId': productId,
                        'productName': productName,
                        'reviewContent': review.content,
                        'rtiScore': review.rtiScore.toDouble(),
                        'rtiGrade': review.rtiLabel,
                      },
                    );
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: alreadyReported
                    ? AppColors.textTertiary
                    : AppColors.error,
              ),
              foregroundColor: alreadyReported
                  ? AppColors.textTertiary
                  : AppColors.error,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
            ),
            child: Text(
              alreadyReported ? '신고 완료' : '리뷰 신고',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared: Section Card ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.showInfo = false,
    this.infoTooltip,
  });

  final String title;
  final Widget child;
  final bool showInfo;
  final String? infoTooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (showInfo) ...[
                const SizedBox(width: AppSpacing.xxs),
                Tooltip(
                  message: infoTooltip ?? '',
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 4),
                  preferBelow: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.4,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

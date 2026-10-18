import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:re_view_front/shared/widgets/review_analysis_section.dart';
import 'package:re_view_front/shared/widgets/review_photo_view.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/product_report_card.dart';
import 'package:re_view_front/shared/widgets/rti_score_ring.dart';

/// Results supplied for this review. A missing score never becomes zero/safe.
class ExternalReviewAnalysis extends StatelessWidget {
  const ExternalReviewAnalysis({
    super.key,
    required this.review,
    required this.analysisStatus,
  });
  final ExternalReview review;
  final String analysisStatus;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final level = review.level?.trim();
    final hasResult =
        analysisStatus.toUpperCase() == 'DONE' &&
        (review.rti != null ||
            (level != null && level.isNotEmpty) ||
            review.reasons.isNotEmpty);
    if (!hasResult) {
      return Text(switch (analysisStatus.toUpperCase()) {
        'QUEUED' || 'RUNNING' => l.reportRunning,
        'FAILED' => l.reportFailed,
        'STALE' => l.reportStale,
        'DISABLED' => l.reportDisabled,
        'DONE' => l.reviewAnalysisMissing,
        'NOT_ANALYZED' => l.reportBefore,
        _ => l.reportUnavailable,
      }, style: Theme.of(context).textTheme.bodySmall);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResultBadges(review: review),
        if (review.reasons.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              ReviewEvidenceFormatter.text(context, review.reasons.first),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        TextButton.icon(
          icon: const Icon(Icons.fact_check_outlined, size: 18),
          label: Text(l.reportDetails),
          onPressed: () => showProductReport(
            context,
            ExternalReviewAnalysisDetails(review: review),
            title: l.reviewResultTitle,
            icon: Icons.rate_review_outlined,
          ),
        ),
      ],
    );
  }
}

/// Shared by the per-review dialog and the product report; opens no API request.
///
/// [embedded]는 상품 리포트의 리뷰 목록처럼 다른 카드 안에 넣을 때 쓰는
/// 평평한 배치다.
class ExternalReviewAnalysisDetails extends StatelessWidget {
  const ExternalReviewAnalysisDetails({
    super.key,
    required this.review,
    this.embedded = false,
  });
  final ExternalReview review;
  final bool embedded;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final images = validReviewImages(review.images);
    final reasons = ReviewEvidenceFormatter.list(
      context,
      review.reasons,
      detailed: true,
    );
    final quote = _ReviewQuote(review: review, images: images);
    final reasonList = reasons.isEmpty ? null : _ReasonList(reasons: reasons);

    if (embedded) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Verdict(review: review, ringSize: 56),
            const SizedBox(height: AppSpacing.md),
            quote,
            if (reasonList != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                l.reportReasons,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              reasonList,
            ],
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.large,
            border: Border.all(color: AppColors.border),
          ),
          child: _Verdict(review: review, ringSize: 96, showSummary: true),
        ),
        if (reasonList != null) ...[
          const SizedBox(height: AppSpacing.md),
          ReviewAnalysisSection(title: l.reportReasons, child: reasonList),
        ],
        const SizedBox(height: AppSpacing.md),
        ReviewAnalysisSection(title: l.reviewOriginal, child: quote),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                l.reviewIndividualScope,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

typedef _LevelStyle = ({String? label, Color color, IconData icon});

_LevelStyle _levelStyle(AppLocalizations l, String? level) =>
    switch (level?.trim().toLowerCase()) {
      'safe' => (
        label: l.reviewAnalysisSafe,
        color: AppColors.success,
        icon: Icons.verified_outlined,
      ),
      'warn' || 'suspicious' => (
        label: l.reviewAnalysisWarn,
        color: AppColors.warning,
        icon: Icons.error_outline,
      ),
      'danger' => (
        label: l.reviewAnalysisDanger,
        color: AppColors.error,
        icon: Icons.gpp_bad_outlined,
      ),
      _ => (
        label: level?.trim(),
        color: AppColors.primary,
        icon: Icons.help_outline,
      ),
    };

/// 점수 게이지와 등급. 점수가 없으면 게이지 없이 등급만 보여 준다.
class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.review,
    required this.ringSize,
    this.showSummary = false,
  });
  final ExternalReview review;
  final double ringSize;
  final bool showSummary;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = _levelStyle(l, review.level);
    final rti = review.rti;
    final firstReason = review.reasons.isEmpty
        ? null
        : ReviewEvidenceFormatter.text(context, review.reasons.first);
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (style.label?.isNotEmpty == true)
          _LevelPill(label: style.label!, color: style.color, icon: style.icon),
        if (showSummary && firstReason != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            firstReason,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
        ],
        if (!showSummary && review.author?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            review.author!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
    if (rti == null) return info;
    return Row(
      children: [
        RtiScoreRing(score: rti, color: style.color, size: ringSize),
        SizedBox(width: ringSize >= 72 ? 20 : AppSpacing.sm),
        Expanded(child: info),
      ],
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({
    required this.label,
    required this.color,
    required this.icon,
  });
  final String label;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: .25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 판단 근거를 번호와 함께 나열한다.
class _ReasonList extends StatelessWidget {
  const _ReasonList({required this.reasons});
  final List<String> reasons;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < reasons.length; i++)
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SelectableText(
                  reasons[i],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

/// 리뷰 원문을 인용 형태로 보여 준다.
class _ReviewQuote extends StatelessWidget {
  const _ReviewQuote({required this.review, required this.images});
  final ExternalReview review;
  final List<String> images;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 3,
          decoration: BoxDecoration(
            color: AppColors.borderStrong,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (review.author?.trim().isNotEmpty == true) ...[
                Text(
                  review.author!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
              ],
              SelectableText(
                review.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.7,
                ),
              ),
              if (images.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (_, index) => ImagePreviewThumbnail(
                      imageUrls: images,
                      index: index,
                      size: 72,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

/// 리뷰 목록 안의 짧은 결과 표시.
class _ResultBadges extends StatelessWidget {
  const _ResultBadges({required this.review});
  final ExternalReview review;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = _levelStyle(l, review.level);
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (review.rti != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'RTI ${_formatRti(review.rti!)}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        if (style.label?.isNotEmpty == true)
          _LevelPill(label: style.label!, color: style.color, icon: style.icon),
      ],
    );
  }
}

String _formatRti(double value) => value == value.roundToDouble()
    ? '${value.toInt()}'
    : value.toStringAsFixed(1);

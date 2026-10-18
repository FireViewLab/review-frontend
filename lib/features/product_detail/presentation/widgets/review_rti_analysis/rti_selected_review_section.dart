import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/review_photo_view.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis/rti_section_card.dart';

class RtiSelectedReviewSection extends StatelessWidget {
  const RtiSelectedReviewSection({super.key, required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    final images = validReviewImages(review.imageUrls);
    return RtiSectionCard(
      title: AppLocalizations.of(context).reviewOriginal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RtiReviewAuthorRow(review: review),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(
            review.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          fontSize: 12,
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

class RtiReviewAuthorRow extends StatelessWidget {
  const RtiReviewAuthorRow({super.key, required this.review});

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
              Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    review.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  RtiPlatformBadge(platform: review.platform),
                ],
              ),
              const SizedBox(height: 2),
              Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
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
                        fontSize: 11,
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
                      fontSize: 12,
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

class RtiPlatformBadge extends StatelessWidget {
  const RtiPlatformBadge({super.key, required this.platform});

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
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Risk Summary Section (종합 위험 요약) ────────────────────────────────────

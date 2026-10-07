import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/presentation/external_platform_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

String _two(int value) => value.toString().padLeft(2, '0');

String formatExternalDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year}.${_two(local.month)}.${_two(local.day)}';
}

String formatExternalPrice(int price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

class ExternalPanel extends StatelessWidget {
  const ExternalPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

/// 상품 이름·가격 등 기본 정보. 수집되지 않은 값은 자리를 만들지 않는다.
class ExternalProductSummary extends StatelessWidget {
  const ExternalProductSummary({
    super.key,
    required this.product,
    required this.isStale,
    required this.onVisitShop,
    required this.actions,
  });

  final ExternalProduct product;
  final bool isStale;

  /// 쇼핑몰 주소가 없으면 null.
  final VoidCallback? onVisitShop;

  /// 찜·장바구니, 질문 버튼 등 상품 아래에 붙는 동작.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final shop = externalPlatformLabel(
      product.ref.platform,
      localeName: l10n.localeName,
    );
    final price = product.price;
    final rating = product.rating;
    final reviewCount = product.reviewCount;
    final meta = {?product.brand, ?product.seller}.join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Chip(label: shop, color: AppColors.primary),
            if (isStale)
              _Chip(
                label: l10n.extProductStale,
                color: AppColors.textSecondary,
                icon: Icons.sync_rounded,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product.name,
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            height: 1.3,
          ),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            meta,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        if (rating != null || reviewCount != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (rating != null) ...[
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  rating.toStringAsFixed(1),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              if (reviewCount != null)
                Text(
                  l10n.extProductReviewCount(reviewCount),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
        if (price != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.extProductPrice(formatExternalPrice(price)),
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (onVisitShop != null)
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: onVisitShop,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(l10n.extProductVisitShop(shop)),
            ),
          ),
        for (final action in actions) ...[
          const SizedBox(height: AppSpacing.sm),
          action,
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 신뢰도 분석이 아직 없을 때 점수 자리에 두는 안내.
///
/// 기본값(예: 50점, 보통)으로 그리면 분석한 상품처럼 보이므로 점수를 만들지 않는다.
class ExternalAnalysisPending extends StatelessWidget {
  const ExternalAnalysisPending({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return ExternalPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_empty_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.extProductAnalysisPendingTitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.extProductAnalysisPendingBody,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 리뷰 한 건. [trailing]에는 신고·피드백 메뉴가 들어간다.
class ExternalReviewTile extends StatelessWidget {
  const ExternalReviewTile({super.key, required this.review, this.trailing});

  final ExternalReview review;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final images = review.images
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final rating = review.rating;
    final writtenAt = review.writtenAt;
    final option = review.option;
    final header = [
      ?review.author,
      if (writtenAt != null) formatExternalDate(writtenAt),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (rating != null) ...[
                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                Text(
                  rating.toStringAsFixed(1),
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  header,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          if (option != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.extProductReviewOption(option),
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          SelectableText(
            review.content,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
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
                itemBuilder: (context, index) => ImagePreviewThumbnail(
                  imageUrls: images,
                  index: index,
                  size: 72,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_ask_button.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_product_action_bar.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_product_sections.dart';
import 'package:re_view_front/features/external_product/presentation/widgets/external_review_actions.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/product_image_viewer.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:url_launcher/url_launcher.dart';

/// Data 서버가 수집한 쇼핑몰 상품의 상세 화면.
class ExternalProductPage extends ConsumerWidget {
  const ExternalProductPage({super.key, required this.productRef});

  final ExternalProductRef productRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppContentView(
              maxWidth: 1120,
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: ExternalProductContent(productRef: productRef),
            ),
          ),
        ],
      ),
    );
  }
}

/// 상품 상세의 본문. 수집 상태에 따라 화면을 가른다.
class ExternalProductContent extends ConsumerWidget {
  const ExternalProductContent({super.key, required this.productRef});

  final ExternalProductRef productRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = externalProductViewModelProvider(productRef);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);
    final product = state.product;

    return switch (state.phase) {
      ExternalProductPhase.loading => const _Centered(
        child: CircularProgressIndicator(),
      ),
      ExternalProductPhase.collecting => _Centered(
        child: _Collecting(isSlow: state.isSlow),
      ),
      ExternalProductPhase.unavailable => _Centered(
        child: AppErrorView(
          title: l10n.extProductUnavailableTitle,
          message: state.collectionError ?? l10n.extProductUnavailableBody,
          retryLabel: l10n.extProductRetry,
          onRetry: vm.load,
        ),
      ),
      ExternalProductPhase.failure => _Centered(
        child: AppErrorView(
          message: l10n.extProductLoadFailed,
          retryLabel: l10n.extProductRetry,
          onRetry: vm.load,
        ),
      ),
      ExternalProductPhase.ready when product != null => _Ready(
        state: state,
        product: product,
        onLoadMore: vm.loadMoreReviews,
      ),
      ExternalProductPhase.ready => const SizedBox.shrink(),
    };
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 420, child: Center(child: child));
  }
}

/// 상품 정보가 준비되기를 기다리는 동안 보여 준다. 진행률은 서버가 알려 주지 않는다.
class _Collecting extends StatelessWidget {
  const _Collecting({required this.isSlow});

  final bool isSlow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Semantics(
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.extProductCollectingTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isSlow
                  ? l10n.extProductCollectingSlow
                  : l10n.extProductCollectingBody,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ready extends ConsumerWidget {
  const _Ready({
    required this.state,
    required this.product,
    required this.onLoadMore,
  });

  final ExternalProductState state;
  final ExternalProduct product;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final url = Uri.tryParse(product.url ?? '');
    final category = product.category;
    final preferences = ref.watch(confirmedDisplayPreferencesProvider);
    final reviews = state.reviews.indexed.toList();
    if (preferences != null) {
      reviews.sort((a, b) {
        if (preferences.reviewSortOrder == 'HELPFUL') {
          final left = a.$2.helpfulCount;
          final right = b.$2.helpfulCount;
          if (left == null && right != null) return 1;
          if (right == null && left != null) return -1;
          if (left != null && right != null && left != right) {
            return right.compareTo(left);
          }
        }
        final left = a.$2.writtenAt;
        final right = b.$2.writtenAt;
        if (left == null && right != null) return 1;
        if (right == null && left != null) return -1;
        if (left != null && right != null && left != right) {
          return right.compareTo(left);
        }
        return a.$1.compareTo(b.$1);
      });
    }

    final image = ProductImageViewer(
      imageUrls: [if (product.thumbnailUrl != null) product.thumbnailUrl!],
    );
    final summary = ExternalProductSummary(
      product: product,
      isStale: state.isStale,
      onVisitShop: url == null || !url.hasScheme
          ? null
          : () => launchUrl(url, mode: LaunchMode.externalApplication),
      actions: [
        ExternalProductActionBar(
          product: product.ref,
          springProductId: state.springProductId,
        ),
        ChatAskButton(productId: product.ref.externalId),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (category != null) ...[
          Text(
            category,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (context.isMobile) ...[
          image,
          const SizedBox(height: AppSpacing.lg),
          summary,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 420, child: image),
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: summary),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
        // 분석 결과의 모양은 서버에서 아직 정해지지 않아, 올 때까지 안내만 둔다.
        if (!state.hasAnalysis) const ExternalAnalysisPending(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.extProductReviewsTitle,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (preferences != null) ...[
          Text(
            l10n.extProductReviewPreferencesNote,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Text(
              l10n.extProductReviewsEmpty,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ExternalPanel(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                for (final (index, review)
                    in reviews.map((entry) => entry.$2).indexed) ...[
                  if (index > 0)
                    const Divider(height: 1, color: AppColors.border),
                  ExternalReviewTile(
                    review: review,
                    trailing: ExternalReviewActions(
                      product: product.ref,
                      reviewId: review.reviewId,
                      productName: product.name,
                      reviewContent: review.content,
                    ),
                  ),
                ],
              ],
            ),
          ),
        if (state.loadMoreFailed)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              l10n.extProductReviewsMoreFailed,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
        if (state.hasMoreReviews) ...[
          const SizedBox(height: AppSpacing.md),
          Center(
            child: OutlinedButton(
              onPressed: state.isLoadingMore ? null : onLoadMore,
              child: state.isLoadingMore
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.extProductReviewsMore),
            ),
          ),
        ],
      ],
    );
  }
}

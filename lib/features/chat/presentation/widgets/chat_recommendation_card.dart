import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_recommendation.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/external_platform_labels.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class ChatRecommendationCard extends ConsumerWidget {
  const ChatRecommendationCard({super.key, required this.product});
  final ChatRecommendation product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final summary = product.summary;
          ref.read(productSummaryCacheProvider).remember(summary);
          // Navigation never rebinds or clears the selected chat session.
          ref
              .read(appRouterProvider)
              .go(
                product.ref.routePath,
                extra: ProductRouteContext(
                  chatProductId: product.ref.externalId,
                  summary: summary,
                ),
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: AppNetworkImage(
                  url: product.thumbnailUrl ?? '',
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      externalPlatformLabel(switch (product.ref.platform
                          .toLowerCase()) {
                        '11st' || '11street' => 'elevenst',
                        _ => product.ref.platform,
                      }, localeName: l.localeName),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (product.price != null)
                      Text(formatSearchPrice(product.price)),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        if (product.reviewCount != null)
                          Text(
                            '${l.extProductReviewsTitle} ${formatSearchCount(product.reviewCount!)}',
                          ),
                        if (product.rating != null) Text('★ ${product.rating}'),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/external_platform_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class ChatHistoryProduct extends ConsumerWidget {
  const ChatHistoryProduct({required this.session, super.key});
  final ChatSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = session.productId?.trim() ?? '';
    if (id.isEmpty) return Text(l10n.chatGeneralContext);
    final name = session.productName?.trim();
    final product = name?.isNotEmpty == true
        ? null
        : ref.watch(chatHistoryProductProvider(id));
    final platform = ExternalProductRef.resolve(externalId: id)?.platform;
    final label = name?.isNotEmpty == true
        ? name!
        : product?.asData?.value?.name ??
              (product?.isLoading == true
                  ? l10n.chatHistoryProductLoading
                  : platform == null
                  ? l10n.chatTargetProduct
                  : externalPlatformLabel(
                      platform,
                      localeName: l10n.localeName,
                    ));
    final image = session.productImageUrl?.trim().isNotEmpty == true
        ? session.productImageUrl
        : product?.asData?.value?.thumbnailUrl;
    return Row(
      children: [
        ExcludeSemantics(
          child: SizedBox.square(
            dimension: 32,
            child: image == null || image.isEmpty
                ? const Icon(Icons.shopping_bag_outlined)
                : AppNetworkImage(
                    url: image,
                    iconSize: 20,
                    borderRadius: AppRadius.large,
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}

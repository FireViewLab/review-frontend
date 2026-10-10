import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 화면 본문 안에서 어시스턴트를 여는 버튼. 상품 분석 옆에 둔다.
///
/// 상품 문맥을 고정한 빈 새 대화를 연다. 이전 서버 대화 기록은 삭제하지 않는다.
class ChatAskButton extends ConsumerWidget {
  const ChatAskButton({super.key, this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.md));
    return Material(
      color: AppColors.primaryLight,
      borderRadius: radius,
      child: InkWell(
        onTap: () {
          final route = ref
              .read(appRouterProvider)
              .routerDelegate
              .currentConfiguration;
          final extra = route.extra;
          final externalId =
              (extra is ProductRouteContext ? extra.chatProductId : null) ??
              productId ??
              ExternalProductRef.fromRoute(route.uri)?.externalId;
          ref
              .read(chatViewModelProvider.notifier)
              .openConversation(
                productId: externalId?.trim().isEmpty == true
                    ? null
                    : externalId?.trim(),
              );
        },
        borderRadius: radius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ChatMark(size: 24),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).chatProductCta,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

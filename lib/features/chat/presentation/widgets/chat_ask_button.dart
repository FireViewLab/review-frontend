import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 화면 본문 안에서 어시스턴트를 여는 버튼. 상품 분석 옆에 둔다.
///
/// 패널만 연다. 다른 상품으로 이어지던 대화가 있으면 패널이 새 대화를 권한다.
class ChatAskButton extends ConsumerWidget {
  const ChatAskButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.md));
    return Material(
      color: AppColors.primaryLight,
      borderRadius: radius,
      child: InkWell(
        onTap: ref.read(chatViewModelProvider.notifier).open,
        borderRadius: radius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ChatSparkle(size: 24),
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

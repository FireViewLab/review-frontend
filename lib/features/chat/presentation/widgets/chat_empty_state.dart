import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 대화를 시작하기 전 화면. 어시스턴트가 답할 수 있는 질문을 카드로 보여 준다.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    super.key,
    required this.productId,
    required this.onSuggestionSelected,
  });

  final String? productId;

  /// 추천 질문을 눌렀을 때. 하루 질문 수에 한도가 있어 바로 보내지 않고 입력창에 넣는다.
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final suggestions = productId != null
        ? [
            (Icons.verified_outlined, l10n.chatSuggestProduct1),
            (Icons.campaign_outlined, l10n.chatSuggestProduct2),
            (Icons.thumbs_up_down_outlined, l10n.chatSuggestProduct3),
            (Icons.compare_arrows_rounded, l10n.chatSuggestProduct4),
          ]
        : [
            (Icons.speed_rounded, l10n.chatSuggestGeneral1),
            (Icons.campaign_outlined, l10n.chatSuggestGeneral2),
            (Icons.fact_check_outlined, l10n.chatSuggestGeneral3),
          ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, AppSpacing.lg, 20, AppSpacing.md),
      children: [
        Text(
          productId != null ? l10n.chatEmptyProductTitle : l10n.chatEmptyTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 22,
            height: 1.3,
            color: ChatStyle.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.chatEmptyBody,
          style: textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final (icon, text) in suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _SuggestionCard(
              icon: icon,
              text: text,
              onTap: () => onSuggestionSelected(text),
            ),
          ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.lg));
    return Material(
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: ChatStyle.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        hoverColor: AppColors.primaryLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ChatStyle.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';

class ChatPanelHeader extends StatelessWidget {
  const ChatPanelHeader({
    super.key,
    required this.quota,
    required this.canStartNew,
    required this.onNew,
    required this.onClose,
    required this.onHistory,
    required this.historyEnabled,
  });

  final ChatQuota? quota;
  final bool canStartNew;
  final VoidCallback onNew;
  final VoidCallback onClose;
  final VoidCallback? onHistory;
  final bool historyEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final quota = this.quota;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, AppSpacing.md, AppSpacing.xs, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const ChatMark(),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.chatTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: ChatStyle.ink,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (quota != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          ChatPanelPlanBadge(quota: quota),
                        ],
                      ],
                    ),
                    Text(
                      l10n.chatSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ChatPanelHeaderAction(
                tooltip: l10n.chatClosePreserve,
                icon: Icons.close_rounded,
                onPressed: onClose,
              ),
            ],
          ),
          if (canStartNew || onHistory != null)
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                if (canStartNew)
                  Tooltip(
                    message: l10n.chatNewConversation,
                    child: TextButton.icon(
                      onPressed: onNew,
                      icon: const Icon(Icons.edit_square, size: 18),
                      label: Text(l10n.chatNewConversation),
                    ),
                  ),
                if (onHistory != null)
                  Tooltip(
                    message: historyEnabled
                        ? l10n.chatPreviousConversations
                        : l10n.chatHistoryWait,
                    child: TextButton.icon(
                      onPressed: historyEnabled ? onHistory : null,
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: Text(l10n.chatPreviousConversations),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class ChatPanelHeaderAction extends StatelessWidget {
  const ChatPanelHeaderAction({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      color: AppColors.textSecondary,
    );
  }
}

/// 서버가 알려 준 요금제. 값이 없으면 배지를 그리지 않는다.
class ChatPanelPlanBadge extends StatelessWidget {
  const ChatPanelPlanBadge({super.key, required this.quota});

  final ChatQuota quota;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = quota.planCode.toUpperCase();
    final label = switch (code) {
      'FREE' => l10n.chatPlanFree,
      'PLUS' => l10n.chatPlanPlus,
      'PRO' => l10n.chatPlanPro,
      _ => quota.planName,
    };
    if (label == null || label.isEmpty) return const SizedBox.shrink();

    final isPro = code == 'PRO';
    final isPlus = code == 'PLUS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPro
            ? ChatStyle.ink
            : isPlus
            ? AppColors.primaryLight
            : AppColors.surface,
        border: isPro || isPlus ? null : Border.all(color: ChatStyle.line),
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isPro
              ? AppColors.onPrimary
              : isPlus
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

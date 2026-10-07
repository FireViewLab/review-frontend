import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ChatHistoryView extends StatelessWidget {
  const ChatHistoryView({
    super.key,
    required this.state,
    required this.onBack,
    required this.onSelect,
    required this.onLoadMore,
    required this.onRetry,
  });
  final ChatState state;
  final VoidCallback onBack;
  final ValueChanged<ChatSession> onSelect;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final loading =
        state.isLoadingMessages ||
        (state.isLoadingSessions && state.sessions.isEmpty);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: [
              IconButton(
                tooltip: l10n.chatBackToConversation,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              Expanded(
                child: Text(
                  l10n.chatPreviousConversations,
                  style: textTheme.titleSmall?.copyWith(
                    color: ChatStyle.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state.historyError != null)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Text(l10n.chatHistoryLoadError, textAlign: TextAlign.center),
                TextButton(onPressed: onRetry, child: Text(l10n.chatRetry)),
              ],
            ),
          ),
        Expanded(
          child: loading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppSpacing.md),
                      Text(l10n.chatHistoryLoading),
                    ],
                  ),
                )
              : state.sessions.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      state.historyError == null ? l10n.chatHistoryEmpty : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.sessions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.sessions.length) {
                      if (state.isLastSessionPage) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: state.isLoadingSessions
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: onLoadMore,
                                child: Text(l10n.chatHistoryLoadMore),
                              ),
                      );
                    }
                    final session = state.sessions[index];
                    final date = session.lastMessageAt ?? session.createdAt;
                    final local = date?.toLocal();
                    final title = session.title.trim().isEmpty
                        ? l10n.chatHistoryUntitled
                        : session.title;
                    return InkWell(
                      onTap: () => onSelect(session),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: ChatStyle.ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    session.productId?.trim().isNotEmpty == true
                                        ? '${l10n.chatTargetProduct}: ${session.productId}'
                                        : l10n.chatGeneralContext,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (local != null)
                                    Text(
                                      '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

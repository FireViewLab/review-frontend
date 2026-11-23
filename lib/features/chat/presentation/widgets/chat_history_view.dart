import 'package:intl/intl.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_history_groups.dart';
import 'package:re_view_front/shared/widgets/empty_state_view.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_history_product.dart';
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
    final groups = ChatHistoryGroup.fromSessions(state.sessions);
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
              ? state.historyError == null
                    ? EmptyStateView(
                        title: l10n.chatHistoryEmpty,
                        message: l10n.chatHistoryEmptyHint,
                      )
                    : const SizedBox.shrink()
              : ListView.builder(
                  itemCount: groups.length + 1,
                  itemBuilder: (context, index) {
                    if (index == groups.length) {
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
                    final group = groups[index];
                    return _ProductConversations(
                      key: ValueKey(group.productId),
                      group: group,
                      onSelect: onSelect,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ProductConversations extends StatelessWidget {
  const _ProductConversations({
    super.key,
    required this.group,
    required this.onSelect,
  });
  final ChatHistoryGroup group;
  final ValueChanged<ChatSession> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: ChatHistoryProduct(session: group.sessions.first),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final conversations in group.conversations)
          if (conversations.length == 1)
            _ConversationRow(session: conversations.single, onSelect: onSelect)
          else
            ExpansionTile(
              key: ValueKey(conversations.first.title.trim()),
              tilePadding: EdgeInsets.zero,
              title: Text(
                conversations.first.title.trim().isEmpty
                    ? AppLocalizations.of(context).chatHistoryUntitled
                    : conversations.first.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                ).chatHistoryConversationCount(conversations.length),
              ),
              children: [
                for (final session in conversations)
                  _ConversationRow(
                    key: ValueKey(session.id),
                    session: session,
                    onSelect: onSelect,
                  ),
              ],
            ),
      ],
    ),
  );
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({
    super.key,
    required this.session,
    required this.onSelect,
  });
  final ChatSession session;
  final ValueChanged<ChatSession> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = (session.lastMessageAt ?? session.createdAt)?.toLocal();
    final now = DateTime.now();
    final today =
        date != null &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final time = date == null
        ? null
        : today
        ? l10n.chatHistoryToday(
            DateFormat('HH:mm', l10n.localeName).format(date),
          )
        : DateFormat('MM.dd', l10n.localeName).format(date);
    return InkWell(
      onTap: () => onSelect(session),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title.trim().isEmpty
                        ? l10n.chatHistoryUntitled
                        : session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ChatStyle.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (time != null)
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
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
  }
}

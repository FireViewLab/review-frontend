import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'chat_composer.dart';
import 'chat_empty_state.dart';
import 'chat_message_bubble.dart';

/// 대화 화면. 추천 질문이 입력창을 채울 수 있도록 입력 상태를 여기서 들고 있다.
class ChatConversation extends ConsumerStatefulWidget {
  const ChatConversation({
    super.key,
    required this.state,
    required this.productId,
    required this.autofocus,
    required this.onPlanPressed,
  });

  final ChatState state;
  final String? productId;
  final bool autofocus;
  final VoidCallback onPlanPressed;

  @override
  ConsumerState<ChatConversation> createState() => _ConversationState();
}

class _ConversationState extends ConsumerState<ChatConversation> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _composerKey = GlobalKey<ChatComposerState>();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _fillInput(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _composerKey.currentState?.focusInput();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final productId = state.hasBoundContext || state.sessionId != null
        ? state.sessionProductId
        : widget.productId;
    final vm = ref.read(chatViewModelProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * .3),
            child: SingleChildScrollView(
              child: ChatContextBar(state: state, productId: widget.productId),
            ),
          ),
          Expanded(
            child: state.hasConversation
                ? ChatConversationMessageList(
                    state: state,
                    productId: productId,
                    onPlanPressed: widget.onPlanPressed,
                  )
                : ChatEmptyState(
                    productId: productId,
                    onSuggestionSelected: _fillInput,
                  ),
          ),
          // 글자를 크게 쓰거나 화면이 낮아도 입력 영역이 패널 밖으로 넘치지 않게 한다.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.6),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isLoadingQuota || state.quotaLoadFailed)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.isLoadingQuota
                                  ? AppLocalizations.of(
                                      context,
                                    ).chatQuotaLoading
                                  : AppLocalizations.of(
                                      context,
                                    ).chatQuotaUnavailable,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          if (state.quotaLoadFailed && !state.isLoadingQuota)
                            TextButton(
                              onPressed: vm.refreshQuota,
                              child: Text(
                                AppLocalizations.of(context).chatQuotaRefresh,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ChatComposer(
                    key: _composerKey,
                    controller: _controller,
                    focusNode: _focusNode,
                    isSending: state.isSending,
                    quota: state.quota,
                    mode: state.mode,
                    canUsePro: state.canUsePro,
                    limitReached: state.limitReached,
                    onQuotaReset: vm.refreshQuota,
                    onPlanPressed: widget.onPlanPressed,
                    autofocus: widget.autofocus,
                    onSend: (text) => vm.send(text, productId: productId),
                    onModeChanged: vm.setMode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 상품 상세에서 열었을 때 대화 기준 상품을 알려 준다.
class ChatContextBar extends ConsumerWidget {
  const ChatContextBar({
    super.key,
    required this.state,
    required this.productId,
  });

  final ChatState state;
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final target = state.hasBoundContext || state.sessionId != null
        ? state.sessionProductId
        : productId;
    final other =
        productId != null &&
        (state.hasBoundContext || state.sessionId != null) &&
        target != productId;
    final source = state.isHistoryConversation
        ? l10n.chatHistoryContext
        : state.sessionId == null
        ? l10n.chatFreshContext
        : l10n.chatActiveContext;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: other ? ChatStyle.noticeBackground : AppColors.surface,
        border: Border.all(
          color: other ? ChatStyle.noticeBorder : ChatStyle.line,
        ),
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(source, style: Theme.of(context).textTheme.labelSmall),
          Tooltip(
            message: target ?? l10n.chatGeneralContext,
            child: Text(
              target == null
                  ? l10n.chatGeneralContext
                  : '${l10n.chatTargetProduct}: $target',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (other) ...[
            Text(
              l10n.chatOtherProductNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => ref
                    .read(chatViewModelProvider.notifier)
                    .startNew(productId: productId),
                child: Text(l10n.chatStartWithThisProduct),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatConversationMessageList extends ConsumerWidget {
  const ChatConversationMessageList({
    super.key,
    required this.state,
    required this.productId,
    required this.onPlanPressed,
  });

  final ChatState state;
  final String? productId;
  final VoidCallback onPlanPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = state.messages;
    final extra = state.isSending ? 1 : 0;
    // reverse로 그려서 새 메시지가 오면 항상 맨 아래가 보이게 한다.
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(20, AppSpacing.md, 20, AppSpacing.xs),
      itemCount: messages.length + extra,
      itemBuilder: (context, index) {
        if (state.isSending && index == 0) {
          return ChatThinkingIndicator(startedAt: state.sendStartedAt);
        }
        final message = messages[messages.length - 1 - (index - extra)];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (message.error != null && state.lastFailedQuestion != null)
                ChatMessageBubble(
                  message: ChatMessage(
                    role: ChatRole.user,
                    content: state.lastFailedQuestion!,
                  ),
                ),
              ChatMessageBubble(
                message: message,
                quotaResetAt: state.quota?.resetAt,
                onPlanPressed: onPlanPressed,
                onRetry: message.error == null
                    ? null
                    : () => ref
                          .read(chatViewModelProvider.notifier)
                          .retry(productId: productId),
              ),
            ],
          ),
        );
      },
    );
  }
}

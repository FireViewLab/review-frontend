import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_composer.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_history_view.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ChatPanel extends ConsumerWidget {
  const ChatPanel({
    super.key,
    required this.productId,
    required this.onLoginPressed,
    required this.onPlanPressed,
    this.fullScreen = false,
  });

  /// 현재 화면의 상품. 상품 상세가 아니면 null.
  final String? productId;
  final VoidCallback onLoginPressed;

  /// 요금제 화면으로 간다. 한도 초과·프로 잠금 안내에서 쓴다.
  final VoidCallback onPlanPressed;

  /// 모바일 전체 화면이면 모서리와 그림자를 없앤다.
  final bool fullScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final state = ref.watch(chatViewModelProvider);
    final vm = ref.read(chatViewModelProvider.notifier);
    final radius = fullScreen
        ? BorderRadius.zero
        : const BorderRadius.all(Radius.circular(AppRadius.xl));

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      label: AppLocalizations.of(context).chatTitle,
      child: CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.escape): vm.close},
        child: FocusScope(
          autofocus: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: fullScreen
                  ? null
                  : const [
                      BoxShadow(
                        color: Color(0x290F172A),
                        blurRadius: 48,
                        offset: Offset(0, 20),
                      ),
                    ],
            ),
            child: Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: radius,
                side: fullScreen
                    ? BorderSide.none
                    : const BorderSide(color: ChatStyle.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _Header(
                    quota: isLoggedIn ? state.quota : null,
                    canStartNew:
                        isLoggedIn &&
                        (state.hasConversation || state.isHistoryOpen),
                    onNew: () => vm.startNew(productId: productId),
                    onClose: vm.close,
                    onHistory: isLoggedIn ? vm.showHistory : null,
                    historyEnabled:
                        !state.isSending && !state.isLoadingMessages,
                  ),
                  const Divider(height: 1, color: ChatStyle.line),
                  if (isLoggedIn && state.isHistoryOpen)
                    Expanded(
                      child: ChatHistoryView(
                        state: state,
                        onBack: vm.closeHistory,
                        onSelect: vm.resumeSession,
                        onLoadMore: vm.loadMoreSessions,
                        onRetry: vm.showHistory,
                      ),
                    )
                  else if (isLoggedIn)
                    Expanded(
                      child: _Conversation(
                        state: state,
                        productId: productId,
                        autofocus: !fullScreen,
                        onPlanPressed: onPlanPressed,
                      ),
                    )
                  else
                    Expanded(
                      child: _LoginPrompt(onLoginPressed: onLoginPressed),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
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
      child: Row(
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
                      _PlanBadge(quota: quota),
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
          if (canStartNew)
            _HeaderAction(
              tooltip: l10n.chatNewConversation,
              icon: Icons.edit_square,
              onPressed: onNew,
            ),
          if (onHistory != null)
            _HeaderAction(
              tooltip: l10n.chatPreviousConversations,
              icon: Icons.history_rounded,
              onPressed: historyEnabled ? onHistory : null,
            ),
          _HeaderAction(
            tooltip: l10n.chatClose,
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
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
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 20),
      color: AppColors.textSecondary,
    );
  }
}

/// 서버가 알려 준 요금제. 값이 없으면 배지를 그리지 않는다.
class _PlanBadge extends StatelessWidget {
  const _PlanBadge({required this.quota});

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

/// 대화 화면. 추천 질문이 입력창을 채울 수 있도록 입력 상태를 여기서 들고 있다.
class _Conversation extends ConsumerStatefulWidget {
  const _Conversation({
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
  ConsumerState<_Conversation> createState() => _ConversationState();
}

class _ConversationState extends ConsumerState<_Conversation> {
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
    final productId = widget.productId;
    final vm = ref.read(chatViewModelProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          _ContextBar(state: state, productId: productId),
          Expanded(
            child: state.hasConversation
                ? _MessageList(
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
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.7),
            child: SingleChildScrollView(
              child: ChatComposer(
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
            ),
          ),
        ],
      ),
    );
  }
}

/// 상품 상세에서 열었을 때 대화 기준 상품을 알려 준다.
class _ContextBar extends ConsumerWidget {
  const _ContextBar({required this.state, required this.productId});

  final ChatState state;
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = this.productId;
    if (productId == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final isOtherProduct =
        state.sessionId != null && state.sessionProductId != productId;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOtherProduct ? ChatStyle.noticeBackground : AppColors.surface,
        border: Border.all(
          color: isOtherProduct ? ChatStyle.noticeBorder : ChatStyle.line,
        ),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          Icon(
            isOtherProduct
                ? Icons.info_outline_rounded
                : Icons.inventory_2_outlined,
            size: 16,
            color: isOtherProduct ? ChatStyle.noticeText : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                isOtherProduct
                    ? l10n.chatOtherProductNotice
                    : l10n.chatProductContext,
                style: textStyle?.copyWith(
                  color: ChatStyle.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isOtherProduct)
            TextButton(
              onPressed: state.isSending
                  ? null
                  : () => ref
                        .read(chatViewModelProvider.notifier)
                        .startNew(productId: productId),
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: Text(l10n.chatStartWithThisProduct),
            ),
        ],
      ),
    );
  }
}

class _MessageList extends ConsumerWidget {
  const _MessageList({
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
          child: ChatMessageBubble(
            message: message,
            quotaResetAt: state.quota?.resetAt,
            onPlanPressed: onPlanPressed,
            onRetry: message.error == null
                ? null
                : () => ref
                      .read(chatViewModelProvider.notifier)
                      .retry(productId: productId),
          ),
        );
      },
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLoginPressed});

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ChatMark(size: 48),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.chatLoginTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: ChatStyle.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.chatLoginBody,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onLoginPressed,
              style: FilledButton.styleFrom(
                backgroundColor: ChatStyle.ink,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),
              child: Text(l10n.chatLoginButton),
            ),
          ),
        ],
      ),
    );
  }
}

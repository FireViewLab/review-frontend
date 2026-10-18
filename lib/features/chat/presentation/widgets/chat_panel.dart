import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_history_view.dart';
import 'chat_panel_header.dart';
import 'chat_conversation.dart';

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
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * .35,
                      ),
                      child: SingleChildScrollView(
                        child: ChatPanelHeader(
                          quota: isLoggedIn ? state.quota : null,
                          canStartNew: isLoggedIn,
                          onNew: () => vm.startNew(productId: productId),
                          onClose: vm.close,
                          onHistory: isLoggedIn ? vm.showHistory : null,
                          historyEnabled:
                              !state.isSending && !state.isLoadingMessages,
                        ),
                      ),
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
                        child: ChatConversation(
                          key: ValueKey(state.conversationRevision),
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
      ),
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
    return SingleChildScrollView(
      child: Padding(
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
      ),
    );
  }
}

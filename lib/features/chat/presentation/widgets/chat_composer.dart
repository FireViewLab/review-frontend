import 'dart:async';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'chat_composer_quota.dart';
import 'chat_composer_controls.dart';

/// 서버 `TopicGuard.MAX_QUESTION_LENGTH`와 같은 값.
const _maxQuestionLength = 500;

/// 질문 입력창. 요금제에 따른 남은 횟수와 답변 모드를 함께 보여 준다.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.quota,
    required this.mode,
    required this.canUsePro,
    required this.limitReached,
    required this.onSend,
    required this.onModeChanged,
    required this.onQuotaReset,
    required this.onPlanPressed,
    this.autofocus = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;

  /// 서버에서 확인한 사용량. null이면 횟수와 모드 선택을 보여 주지 않는다.
  final ChatQuota? quota;
  final ChatMode mode;
  final bool canUsePro;

  /// 서버가 한도 초과로 거절한 뒤 아직 사용량을 다시 확인하지 못한 상태.
  final bool limitReached;

  /// 한도 초기화 시각이 지났을 때. 사용량을 다시 받아 오는 데 쓴다.
  final VoidCallback onQuotaReset;

  /// 요금제 화면으로 간다.
  final VoidCallback onPlanPressed;
  final ValueChanged<String> onSend;
  final ValueChanged<ChatMode> onModeChanged;
  final bool autofocus;

  @override
  State<ChatComposer> createState() => ChatComposerState();
}

class ChatComposerState extends State<ChatComposer> {
  Timer? _lockedHintTimer;
  Timer? _refocusTimer;
  Timer? _resetTimer;
  bool _showLockedHint = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    _scheduleReset();
  }

  @override
  void didUpdateWidget(ChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quota?.resetAt != widget.quota?.resetAt) _scheduleReset();
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    _lockedHintTimer?.cancel();
    _refocusTimer?.cancel();
    _resetTimer?.cancel();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  /// 패널을 열어 둔 채 초기화 시각을 넘기면 입력을 다시 열고 사용량을 새로 받는다.
  void _scheduleReset() {
    _resetTimer?.cancel();
    final resetAt = widget.quota?.resetAt;
    if (resetAt == null) return;
    final wait = resetAt.difference(DateTime.now());
    if (wait.isNegative) return;
    _resetTimer = Timer(wait + const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {});
      widget.onQuotaReset();
    });
  }

  /// 입력창에 포커스를 준다. 버튼이나 추천 질문을 누른 뒤 이어서 입력할 때 쓴다.
  ///
  /// 웹에서는 입력창 밖을 누른 직후 브라우저가 포커스를 한 번 더 가져가므로,
  /// 잠시 뒤에 다시 확인해서 잡는다.
  void focusInput() {
    widget.focusNode.requestFocus();
    _refocusTimer?.cancel();
    _refocusTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted && !widget.focusNode.hasFocus) {
        widget.focusNode.requestFocus();
      }
    });
  }

  bool get _exhausted =>
      widget.limitReached ||
      (widget.quota?.isExhaustedAt(DateTime.now()) ?? false);

  /// 서버는 UTF-16 길이로 500자를 잰다. 이모지는 화면 글자 수보다 길게 잡힌다.
  bool get _tooLong => widget.controller.text.length > _maxQuestionLength;

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isEmpty || widget.isSending || _exhausted || _tooLong) return;
    widget.onSend(text);
    widget.controller.clear();
    focusInput();
  }

  void _selectMode(ChatMode mode) {
    if (mode == ChatMode.pro && !widget.canUsePro) {
      setState(() => _showLockedHint = true);
      _lockedHintTimer?.cancel();
      _lockedHintTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _showLockedHint = false);
      });
      return;
    }
    widget.onModeChanged(mode);
    // 모드를 고른 뒤 바로 이어서 입력할 수 있게 한다.
    focusInput();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final quota = widget.quota;
    final exhausted = _exhausted;
    final focused = widget.focusNode.hasFocus;
    final hint = _showLockedHint
        ? l10n.chatModeProLocked
        : widget.mode == ChatMode.pro
        ? l10n.chatModeProActive
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (exhausted)
            ChatComposerLimitBanner(
              resetAt: quota?.resetAt,
              onPlanPressed: widget.onPlanPressed,
            )
          else if (quota != null)
            ChatComposerQuotaLine(quota: quota),
          GestureDetector(
            // 입력 상자의 빈 곳을 눌러도 글자를 칠 수 있게 한다.
            behavior: HitTestBehavior.translucent,
            onTap: exhausted ? null : widget.focusNode.requestFocus,
            child: Container(
              decoration: BoxDecoration(
                color: exhausted ? AppColors.surfaceMuted : AppColors.surface,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: focused ? AppColors.primary : ChatStyle.line,
                  width: focused ? 1.5 : 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(14, 4, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    autofocus: widget.autofocus,
                    enabled: !exhausted,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: _maxQuestionLength,
                    // multiline이 아니면 여러 줄 입력창에서도 Enter가 전송으로 동작한다.
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    // onSubmitted만 두면 전송 뒤 포커스가 빠져 이어서 입력할 수 없다.
                    onEditingComplete: _submit,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: ChatStyle.ink,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.chatInputHint,
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: AppColors.textTertiary,
                      ),
                      counterText: '',
                      isDense: true,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                  ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, _) {
                      final length = widget.controller.text.length;
                      final canSend =
                          !widget.isSending &&
                          !exhausted &&
                          !_tooLong &&
                          widget.controller.text.trim().isNotEmpty;
                      final modeSwitch = quota == null
                          ? null
                          : ChatComposerModeSwitch(
                              mode: widget.mode,
                              proAvailable: widget.canUsePro,
                              onSelected: widget.isSending ? null : _selectMode,
                            );
                      final actions = Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (length > 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '$length/$_maxQuestionLength',
                                style: textTheme.labelSmall?.copyWith(
                                  color: _tooLong
                                      ? AppColors.error
                                      : AppColors.textTertiary,
                                  fontWeight: _tooLong ? FontWeight.w700 : null,
                                ),
                              ),
                            ),
                          ChatComposerSendButton(
                            tooltip: l10n.chatSend,
                            onPressed: canSend ? _submit : null,
                          ),
                        ],
                      );
                      return ChatComposerActionLayout(
                        modeSwitch: modeSwitch,
                        actions: actions,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  _showLockedHint
                      ? Icons.lock_outline_rounded
                      : Icons.workspace_premium_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hint,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_showLockedHint)
                  TextButton(
                    onPressed: widget.onPlanPressed,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(l10n.chatViewPlans),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(
            l10n.chatDisclaimer,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

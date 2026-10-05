import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

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
            _LimitBanner(
              resetAt: quota?.resetAt,
              onPlanPressed: widget.onPlanPressed,
            )
          else if (quota != null)
            _QuotaLine(quota: quota),
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
                          : _ModeSwitch(
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
                          _SendButton(
                            tooltip: l10n.chatSend,
                            onPressed: canSend ? _submit : null,
                          ),
                        ],
                      );
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // 좁은 화면이나 큰 글자에서는 모드 선택을 윗줄로 올린다.
                          final tight =
                              constraints.maxWidth < 300 ||
                              MediaQuery.textScalerOf(context).scale(1) > 1.3;
                          // 그래도 넘치면 잘리는 대신 줄어들게 한다.
                          Widget fit(Widget child) => FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: child,
                          );
                          if (tight && modeSwitch != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                fit(modeSwitch),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: fit(actions),
                                ),
                              ],
                            );
                          }
                          return Row(
                            // Spacer를 쓰면 남는 폭을 나눠 가져 보내기 버튼이 오른쪽 끝에 붙지 않는다.
                            mainAxisAlignment: modeSwitch == null
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              if (modeSwitch != null)
                                Flexible(child: fit(modeSwitch)),
                              actions,
                            ],
                          );
                        },
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

/// 요금제의 오늘 남은 질문 수. 서버에서 받은 숫자만 보여 준다.
class _QuotaLine extends StatelessWidget {
  const _QuotaLine({required this.quota});

  final ChatQuota quota;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final low = !quota.isUnlimited && quota.remaining <= 1;
    final color = low ? ChatStyle.noticeText : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, AppSpacing.xs),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, size: 14, color: color),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              quota.isUnlimited
                  ? l10n.chatQuotaUnlimited
                  : l10n.chatQuotaRemaining(quota.remaining, quota.dailyLimit),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!quota.isUnlimited && quota.dailyLimit > 0)
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                child: SizedBox(
                  width: 64,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: (quota.remaining / quota.dailyLimit).clamp(0, 1),
                    backgroundColor: ChatStyle.line,
                    color: low ? AppColors.warning : AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LimitBanner extends StatelessWidget {
  const _LimitBanner({required this.resetAt, required this.onPlanPressed});

  final DateTime? resetAt;
  final VoidCallback onPlanPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ChatStyle.noticeBackground,
        border: Border.all(color: ChatStyle.noticeBorder),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.hourglass_bottom_rounded,
            size: 16,
            color: ChatStyle.noticeText,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.chatQuotaExceededTitle,
                    style: const TextStyle(
                      color: ChatStyle.noticeText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '  ${chatQuotaResetText(l10n, resetAt)}'),
                ],
              ),
              style: textTheme.bodySmall?.copyWith(color: ChatStyle.ink),
            ),
          ),
          TextButton(
            onPressed: onPlanPressed,
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(l10n.chatViewPlans),
          ),
        ],
      ),
    );
  }
}

/// 기본/프로 답변 모드 선택. 프로를 쓸 수 없는 요금제에는 자물쇠로 표시한다.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.mode,
    required this.proAvailable,
    required this.onSelected,
  });

  final ChatMode mode;
  final bool proAvailable;
  final ValueChanged<ChatMode>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeSegment(
            label: l10n.chatModeStandard,
            selected: mode == ChatMode.standard,
            onTap: onSelected == null
                ? null
                : () => onSelected!(ChatMode.standard),
          ),
          _ModeSegment(
            label: l10n.chatModePro,
            icon: proAvailable
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            selected: mode == ChatMode.pro,
            muted: !proAvailable,
            onTap: onSelected == null ? null : () => onSelected!(ChatMode.pro),
          ),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.muted = false,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? ChatStyle.ink
        : muted
        ? AppColors.textTertiary
        : AppColors.textSecondary;
    final icon = this.icon;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.surface : Colors.transparent,
        elevation: selected ? 1 : 0,
        shadowColor: AppColors.shadow,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 12,
                    color: selected ? AppColors.primary : color,
                  ),
                  const SizedBox(width: 3),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? AppColors.primary : ChatStyle.line,
            ),
            child: InkWell(
              onTap: onPressed,
              child: SizedBox.square(
                dimension: 40,
                child: Icon(
                  Icons.arrow_upward_rounded,
                  size: 20,
                  color: enabled ? AppColors.onPrimary : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

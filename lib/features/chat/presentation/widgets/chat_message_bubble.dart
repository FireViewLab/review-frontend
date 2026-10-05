import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.quotaResetAt,
    this.onPlanPressed,
  });

  final ChatMessage message;
  final VoidCallback? onRetry;

  /// 한도 초과 안내에 보여 줄 초기화 시각. 서버에서 받은 값만 넘긴다.
  final DateTime? quotaResetAt;

  /// 요금제 화면으로 간다. 한도·요금제 안내에 링크로 붙는다.
  final VoidCallback? onPlanPressed;

  @override
  Widget build(BuildContext context) {
    final error = message.error;
    if (message.role == ChatRole.user) return _UserBubble(message.content);
    if (error != null) {
      return _ErrorNotice(
        kind: error,
        onRetry: onRetry,
        quotaResetAt: quotaResetAt,
        onPlanPressed: onPlanPressed,
      );
    }
    if (message.blocked) return _BlockedNotice(message.content);
    return _AssistantAnswer(message.content);
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.85,
        alignment: Alignment.centerRight,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: ChatStyle.ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 어시스턴트 이름표. 답변과 대기 표시 위에 붙는다.
class _AssistantLabel extends StatelessWidget {
  const _AssistantLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ChatMark(size: 20),
        const SizedBox(width: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).chatTitle,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// 말풍선 없이 패널 폭을 그대로 쓰는 답변.
class _AssistantAnswer extends StatelessWidget {
  const _AssistantAnswer(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AssistantLabel(),
        const SizedBox(height: AppSpacing.xs),
        SelectableText(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: 1.6,
            color: ChatStyle.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        _CopyButton(text),
      ],
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton(this.text);

  final String text;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  Timer? _timer;
  bool _copied = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    if (!mounted) return;
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: _copied ? l10n.chatCopied : l10n.chatCopy,
      onPressed: _copy,
      visualDensity: VisualDensity.compact,
      iconSize: 16,
      color: _copied ? AppColors.success : AppColors.textTertiary,
      icon: Icon(_copied ? Icons.check_rounded : Icons.content_copy_rounded),
    );
  }
}

/// 답변 대신 보여 주는 안내 카드. 색만으로 구분하지 않도록 아이콘과 제목을 함께 쓴다.
class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.background,
    required this.border,
    required this.foreground,
    this.title,
    this.body,
    this.action,
  });

  final IconData icon;
  final Color background;
  final Color border;
  final Color foreground;
  final String? title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = this.title;
    final body = this.body;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 18, color: foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (title != null && body != null) const SizedBox(height: 2),
                if (body != null)
                  Text(
                    body,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: ChatStyle.ink,
                    ),
                  ),
                ?action,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedNotice extends StatelessWidget {
  const _BlockedNotice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.info_outline_rounded,
      background: ChatStyle.noticeBackground,
      border: ChatStyle.noticeBorder,
      foreground: ChatStyle.noticeText,
      title: AppLocalizations.of(context).chatBlockedTitle,
      body: text,
    );
  }
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({
    required this.kind,
    required this.onRetry,
    required this.quotaResetAt,
    required this.onPlanPressed,
  });

  final ChatErrorKind kind;
  final VoidCallback? onRetry;
  final DateTime? quotaResetAt;
  final VoidCallback? onPlanPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget? action(String label, IconData icon, [VoidCallback? onPressed]) {
      final callback = onPressed ?? onRetry;
      if (callback == null) return null;
      return TextButton.icon(
        onPressed: callback,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    switch (kind) {
      case ChatErrorKind.quotaExceeded:
        return _NoticeCard(
          icon: Icons.hourglass_bottom_rounded,
          background: ChatStyle.noticeBackground,
          border: ChatStyle.noticeBorder,
          foreground: ChatStyle.noticeText,
          title: l10n.chatQuotaExceededTitle,
          body: chatQuotaResetText(l10n, quotaResetAt),
          action: onPlanPressed == null
              ? null
              : action(
                  l10n.chatViewPlans,
                  Icons.arrow_forward_rounded,
                  onPlanPressed,
                ),
        );
      case ChatErrorKind.planRequired:
        return _NoticeCard(
          icon: Icons.lock_outline_rounded,
          background: ChatStyle.noticeBackground,
          border: ChatStyle.noticeBorder,
          foreground: ChatStyle.noticeText,
          title: l10n.chatPlanRequiredTitle,
          action: Wrap(
            spacing: AppSpacing.md,
            children: [
              ?action(l10n.chatPlanRequiredAction, Icons.refresh_rounded),
              if (onPlanPressed != null)
                ?action(
                  l10n.chatViewPlans,
                  Icons.arrow_forward_rounded,
                  onPlanPressed,
                ),
            ],
          ),
        );
      case ChatErrorKind.unavailable ||
          ChatErrorKind.timeout ||
          ChatErrorKind.network ||
          ChatErrorKind.unknown:
        return _NoticeCard(
          icon: Icons.error_outline_rounded,
          background: ChatStyle.errorBackground,
          border: ChatStyle.errorBorder,
          foreground: ChatStyle.errorText,
          body: switch (kind) {
            ChatErrorKind.unavailable => l10n.chatErrorUnavailable,
            ChatErrorKind.timeout => l10n.chatErrorTimeout,
            ChatErrorKind.network => l10n.chatErrorNetwork,
            _ => l10n.chatErrorUnknown,
          },
          action: action(l10n.chatRetry, Icons.refresh_rounded),
        );
    }
  }
}

/// 한도가 언제 풀리는지 알려 주는 문구. 시각을 모르면 시각 없이 안내한다.
String chatQuotaResetText(AppLocalizations l10n, DateTime? resetAt) {
  if (resetAt == null) return l10n.chatQuotaExceededBodyNoTime;
  final local = resetAt.toLocal();
  String two(int value) => value.toString().padLeft(2, '0');
  return l10n.chatQuotaExceededBody('${two(local.hour)}:${two(local.minute)}');
}

/// 답변을 기다리는 동안 보여 주는 표시. 응답은 한 번에 오고 최대 70초가 걸린다.
///
/// 문구는 기다린 시간에 따라 바뀌지만 진행률은 아니다. 서버가 단계를 알려 주지 않는다.
class ChatThinkingIndicator extends StatefulWidget {
  const ChatThinkingIndicator({super.key, required this.startedAt});

  final DateTime? startedAt;

  @override
  State<ChatThinkingIndicator> createState() => _ChatThinkingIndicatorState();
}

class _ChatThinkingIndicatorState extends State<ChatThinkingIndicator>
    with SingleTickerProviderStateMixin {
  static const _longAfter = Duration(seconds: 10);
  static const _veryLongAfter = Duration(seconds: 30);

  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    // 패널을 닫았다 열어도 처음부터 다시 세지 않도록 시작 시각을 기준으로 잡는다.
    final elapsed = _elapsed;
    for (final threshold in [_longAfter, _veryLongAfter]) {
      if (elapsed < threshold) {
        _timers.add(
          Timer(threshold - elapsed, () {
            if (mounted) setState(() {});
          }),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 움직임 줄이기를 켠 사용자에게는 점을 멈춰 둔다.
    if (MediaQuery.disableAnimationsOf(context)) {
      _dots.stop();
    } else if (!_dots.isAnimating) {
      _dots.repeat();
    }
  }

  Duration get _elapsed {
    final startedAt = widget.startedAt;
    return startedAt == null
        ? Duration.zero
        : DateTime.now().difference(startedAt);
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final elapsed = _elapsed;
    final text = elapsed >= _veryLongAfter
        ? l10n.chatThinkingVeryLong
        : elapsed >= _longAfter
        ? l10n.chatThinkingLong
        : l10n.chatThinking;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AssistantLabel(),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            liveRegion: true,
            child: Row(
              children: [
                ExcludeSemantics(child: _Dots(animation: _dots)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Opacity(
                // 점 세 개가 차례로 밝아진다.
                opacity:
                    0.25 +
                    0.75 *
                        (1 -
                            ((animation.value * 3 - i) % 3 - 0.5).abs().clamp(
                              0,
                              1,
                            )),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

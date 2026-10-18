import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';

/// 기본/프로 답변 모드 선택. 프로를 쓸 수 없는 요금제에는 자물쇠로 표시한다.
class ChatComposerModeSwitch extends StatelessWidget {
  const ChatComposerModeSwitch({
    super.key,
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
          ChatComposerModeSegment(
            label: l10n.chatModeStandard,
            selected: mode == ChatMode.standard,
            onTap: onSelected == null
                ? null
                : () => onSelected!(ChatMode.standard),
          ),
          ChatComposerModeSegment(
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

class ChatComposerModeSegment extends StatelessWidget {
  const ChatComposerModeSegment({
    super.key,
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

class ChatComposerSendButton extends StatelessWidget {
  const ChatComposerSendButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

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

class ChatComposerActionLayout extends StatelessWidget {
  const ChatComposerActionLayout({
    super.key,
    required this.modeSwitch,
    required this.actions,
  });

  final Widget? modeSwitch;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final modeSwitch = this.modeSwitch;
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
              Align(alignment: Alignment.centerRight, child: fit(actions)),
            ],
          );
        }
        return Row(
          // Spacer를 쓰면 남는 폭을 나눠 가져 보내기 버튼이 오른쪽 끝에 붙지 않는다.
          mainAxisAlignment: modeSwitch == null
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
          children: [
            if (modeSwitch != null) Flexible(child: fit(modeSwitch)),
            actions,
          ],
        );
      },
    );
  }
}

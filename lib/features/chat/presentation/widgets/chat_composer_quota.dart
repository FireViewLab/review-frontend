import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'chat_message_bubble.dart';

/// 요금제의 오늘 남은 질문 수. 서버에서 받은 숫자만 보여 준다.
class ChatComposerQuotaLine extends StatelessWidget {
  const ChatComposerQuotaLine({super.key, required this.quota});

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

class ChatComposerLimitBanner extends StatelessWidget {
  const ChatComposerLimitBanner({
    super.key,
    required this.resetAt,
    required this.onPlanPressed,
  });

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

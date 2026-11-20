import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/presentation/review_owl_assets.dart';

/// 말풍선 색. 진행 안내·완료·주의에 맞춰 고른다.
enum OwlGuideTone { info, success, warning }

/// 리뷰엉이가 말풍선으로 설명하는 공용 위젯.
///
/// 글자가 커지면 말풍선이 아래로 늘어나고, 스크린리더는 "리뷰엉이"와
/// 말풍선 내용을 한 덩어리로 읽는다. 캐릭터 이미지는 장식이라 읽지 않는다.
class OwlGuide extends StatelessWidget {
  const OwlGuide({
    required this.message,
    this.title,
    this.tone = OwlGuideTone.info,
    this.action,
    this.avatarSize = 52,
    super.key,
  });

  final String message;
  final String? title;
  final OwlGuideTone tone;

  /// 말풍선 아래에 붙는 버튼 등.
  final Widget? action;
  final double avatarSize;

  Color get _bubbleColor => switch (tone) {
    OwlGuideTone.info => AppColors.primaryLight,
    OwlGuideTone.success => AppColors.successSoft,
    OwlGuideTone.warning => AppColors.warningSoft,
  };

  Color get _accentColor => switch (tone) {
    OwlGuideTone.info => AppColors.primary,
    OwlGuideTone.success => AppColors.success,
    OwlGuideTone.warning => AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = AppLocalizations.of(context).owlGuideName;
    return Semantics(
      container: true,
      label: name,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Container(
              width: avatarSize,
              height: avatarSize,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: _bubbleColor, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  ReviewOwlAssets.face,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Icon(Icons.emoji_nature_outlined, color: _accentColor),
                ),
              ),
            ),
          ),
          // 말풍선 꼬리. 얼굴 가운데 높이에 맞춘다.
          Padding(
            padding: EdgeInsets.only(top: avatarSize / 2 - 7),
            child: CustomPaint(
              size: const Size(8, 14),
              painter: _BubbleTailPainter(_bubbleColor),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _bubbleColor,
                borderRadius: AppRadius.large,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? name,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    if (action != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      action!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color;
}

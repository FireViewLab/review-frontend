import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class HeroBannerEdgeFade extends StatelessWidget {
  const HeroBannerEdgeFade({super.key, required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: const [AppColors.background, Color(0x00F8FAFC)],
          ),
        ),
      ),
    );
  }
}

class HeroBannerProgress extends StatelessWidget {
  const HeroBannerProgress({
    super.key,
    required this.itemCount,
    required this.activeIndex,
    required this.isPaused,
    required this.reducedMotion,
    required this.onPauseToggle,
  });

  final int itemCount;
  final int activeIndex;
  final bool isPaused;
  final bool reducedMotion;
  final VoidCallback onPauseToggle;

  @override
  Widget build(BuildContext context) {
    // Keep the original slim pill while retaining a larger pause hit target.
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 6,
            bottom: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.34),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x140F172A),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (itemCount > 8)
                  Text('${activeIndex + 1}/$itemCount')
                else
                  for (var i = 0; i < itemCount; i++)
                    Container(
                      width: i == activeIndex ? 28 : 7,
                      height: 6,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: i == activeIndex
                            ? AppColors.textPrimary.withValues(alpha: 0.92)
                            : Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                const SizedBox(width: AppSpacing.xxs),
                const SizedBox.square(dimension: 24),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 48,
            child: IconButton(
              tooltip: isPaused ? '재생' : '일시정지',
              onPressed: reducedMotion ? null : onPauseToggle,
              icon: Icon(
                isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                size: 16,
              ),
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class HeroBannerCircleControl extends StatelessWidget {
  const HeroBannerCircleControl({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppColors.shadow,
      child: IconButton(
        tooltip: icon == Icons.chevron_left ? '이전 배너' : '다음 배너',
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

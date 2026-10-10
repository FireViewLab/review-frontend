import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

/// RTI/ATI 점수를 0~100 그라데이션 바와 마커로 표시하는 게이지.
///
/// 좌측(안전, 파랑) → 우측(위험, 빨강) 방향이며, [score] 위치에 마커를 둔다.
class AdminScoreGauge extends StatelessWidget {
  const AdminScoreGauge({
    super.key,
    required this.score,
    this.max = 100,
    this.scaleLabels = const ['0', '25', '50', '75', '100'],
  });

  final double score;
  final double max;
  final List<String> scaleLabels;

  @override
  Widget build(BuildContext context) {
    final fraction = (score / max).clamp(0.0, 1.0);
    const trackHeight = 8.0;
    const thumbSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: thumbSize,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final thumbLeft =
                  (width - thumbSize) * fraction;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: trackHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(trackHeight / 2),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.info,
                            AppColors.primary,
                            AppColors.warning,
                            AppColors.error,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: thumbLeft,
                    top: 0,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textPrimary,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(color: AppColors.shadow, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (scaleLabels.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in scaleLabels)
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

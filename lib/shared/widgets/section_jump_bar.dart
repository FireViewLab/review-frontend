import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

/// 바로가기 한 칸. [target]은 이동할 섹션에 붙인 키다.
class SectionJumpItem {
  const SectionJumpItem({required this.label, required this.target});

  final String label;
  final GlobalKey target;
}

/// 긴 상세 화면에서 섹션으로 바로 이동하는 가로 칩 목록.
class SectionJumpBar extends StatelessWidget {
  const SectionJumpBar({required this.items, super.key});

  final List<SectionJumpItem> items;

  void _jump(BuildContext context, GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : AppMotion.slow,
      curve: Curves.easeOutCubic,
      alignment: 0.02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in items) ...[
            ActionChip(
              label: Text(item.label),
              onPressed: () => _jump(context, item.target),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

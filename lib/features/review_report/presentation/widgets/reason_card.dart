import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

class ReasonCard extends StatefulWidget {
  const ReasonCard({
    super.key,
    required this.reason,
    required this.isSelected,
    required this.onTap,
  });

  final ReportReason reason;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ReasonCard> createState() => _ReasonCardState();
}

class _ReasonCardState extends State<ReasonCard> {
  bool _hovering = false;

  IconData get _icon => switch (widget.reason) {
    ReportReason.fakeReview => Icons.warning_amber_outlined,
    ReportReason.aiGenerated => Icons.smart_toy_outlined,
    ReportReason.irrelevantContent => Icons.link_off_outlined,
    ReportReason.inappropriate => Icons.block_outlined,
    ReportReason.adReview => Icons.campaign_outlined,
    ReportReason.repetitiveContent => Icons.repeat,
    ReportReason.other => Icons.flag_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;

    final borderColor = selected
        ? AppColors.primary
        : _hovering
        ? AppColors.borderStrong
        : AppColors.border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.base),
          curve: AppMotion.enter,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.06)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _icon,
                      size: 18,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  _SelectionCheckbox(selected: selected),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.reason.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Flexible(
                child: Text(
                  widget.reason.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCheckbox extends StatelessWidget {
  const _SelectionCheckbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.base),
      curve: AppMotion.enter,
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderStrong,
          width: 1.5,
        ),
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.base),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                key: ValueKey('checked'),
                size: 14,
                color: Colors.white,
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}

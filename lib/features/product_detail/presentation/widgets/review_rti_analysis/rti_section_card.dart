import 'package:re_view_front/shared/widgets/review_analysis_section.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

class RtiSectionCard extends StatelessWidget {
  const RtiSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.showInfo = false,
    this.infoTooltip,
  });
  final String title;
  final Widget child;
  final bool showInfo;
  final String? infoTooltip;
  @override
  Widget build(BuildContext context) => ReviewAnalysisSection(
    title: title,
    trailing: showInfo
        ? Tooltip(
            message: infoTooltip ?? '',
            triggerMode: TooltipTriggerMode.tap,
            child: const Icon(
              Icons.info_outline,
              size: 18,
              color: AppColors.textSecondary,
            ),
          )
        : null,
    child: child,
  );
}

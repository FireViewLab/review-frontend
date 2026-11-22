import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/reason_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/section_card.dart';

class ReasonSelectorSection extends StatelessWidget {
  const ReasonSelectorSection({
    super.key,
    required this.selectedReasons,
    required this.onToggled,
    this.onShowCriteria,
  });

  final Set<ReportReason> selectedReasons;
  final ValueChanged<ReportReason> onToggled;
  final VoidCallback? onShowCriteria;

  static const _reasons = [
    ReportReason.fakeReview,
    ReportReason.aiGenerated,
    ReportReason.irrelevantContent,
    ReportReason.inappropriate,
  ];

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedReasons.isNotEmpty;

    return SectionCard(
      title: AppLocalizations.of(context).reportReasonTitle,
      description: AppLocalizations.of(context).reportReasonDescription,
      trailing: TextButton(
        onPressed: onShowCriteria,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppLocalizations.of(context).reportViewCriteria,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.base),
            curve: AppMotion.enter,
            alignment: Alignment.topLeft,
            child: hasSelection
                ? Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).adminSelectedCount(selectedReasons.length),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 720 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: crossAxisCount == 4 ? 1.0 : 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final reason in _reasons)
                    ReasonCard(
                      reason: reason,
                      isSelected: selectedReasons.contains(reason),
                      onTap: () => onToggled(reason),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

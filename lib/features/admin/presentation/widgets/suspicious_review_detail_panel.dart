import 'package:re_view_front/shared/presentation/review_evidence_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_score_gauge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_status_badge.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_text_format.dart';
import 'package:re_view_front/features/admin/presentation/widgets/trust_grade_tone.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

class SuspiciousReviewDetailPanel extends StatelessWidget {
  const SuspiciousReviewDetailPanel({
    super.key,
    required this.review,
    required this.onClose,
  });

  final AdminSuspiciousReview review;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final r = review;
    return AdminDetailPanel(
      title: l10n.adminReviewDetails,
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r.productName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          InkWell(
            onTap: () => context.go('/product/${r.productId}'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.adminViewProduct,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            label: l10n.adminRtiAnalysis,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      r.rtiScore.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        l10n.adminScoreUnit,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (r.trustGrade != null)
                      AdminStatusBadge(
                        label: r.trustGrade!.localizedLabel(l10n),
                        tone: r.trustGrade!.tone,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AdminScoreGauge(score: r.rtiScore),
              ],
            ),
          ),
          _Section(
            label: l10n.adminReviewContent,
            child: Text(
              r.content.isEmpty ? '-' : r.content,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          if (r.reasons.isNotEmpty)
            _Section(
              label: l10n.adminDetectedSignals(r.reasons.length),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final reason in ReviewEvidenceFormatter.list(
                    context,
                    r.reasons,
                  ))
                    AdminStatusBadge(
                      label: reason,
                      tone: AdminBadgeTone.danger,
                    ),
                ],
              ),
            ),
          _Section(
            label: l10n.adminVerifiedPurchase,
            child: AdminStatusBadge(
              label: r.isVerifiedPurchase
                  ? l10n.adminVerified
                  : l10n.adminNotVerified,
              tone: r.isVerifiedPurchase
                  ? AdminBadgeTone.success
                  : AdminBadgeTone.neutral,
            ),
          ),
          _Section(
            label: l10n.adminReviewerInfo,
            child: _InfoBox(
              rows: [
                (
                  l10n.adminReviewer,
                  r.reviewerNickname.isEmpty ? '-' : r.reviewerNickname,
                ),
                (l10n.adminRating, '★ ${r.rating}'),
                (l10n.adminWrittenAt, formatAdminDateTime(r.writtenAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    rows[i].$1,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

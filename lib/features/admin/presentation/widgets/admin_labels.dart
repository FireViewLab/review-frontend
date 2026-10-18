import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

extension ReportStatusLabel on ReportStatus {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
    ReportStatus.pending => l10n.adminReportPending,
    ReportStatus.underReview => l10n.adminUnderReview,
    ReportStatus.accepted => l10n.adminReportAccepted,
    ReportStatus.rejected => l10n.adminReportRejected,
  };
}

extension AnalysisFeedbackStatusLabel on AnalysisFeedbackStatus {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
    AnalysisFeedbackStatus.submitted => l10n.adminFeedbackSubmitted,
    AnalysisFeedbackStatus.underReview => l10n.adminUnderReview,
    AnalysisFeedbackStatus.resolved => l10n.adminFeedbackResolved,
    AnalysisFeedbackStatus.rejected => l10n.adminFeedbackRejected,
  };
}

extension TrustGradeLabel on TrustGrade {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
    TrustGrade.danger => l10n.adminDanger,
    TrustGrade.warning => l10n.adminWarning,
    TrustGrade.safe => l10n.adminSafe,
  };
}

String analysisUserJudgmentLabel(String? code, AppLocalizations l10n) =>
    switch (code) {
      'MORE_TRUSTWORTHY' => l10n.adminJudgmentTrustworthy,
      'MORE_RISKY' => l10n.adminJudgmentRisky,
      'UNDECIDED' => l10n.adminJudgmentUndecided,
      _ => '-',
    };

String adminUserPlanLabel(String? code, AppLocalizations l10n) =>
    switch (code) {
      'FREE' => l10n.chatPlanFree,
      'PLUS' => l10n.chatPlanPlus,
      'PRO' => l10n.chatPlanPro,
      _ => l10n.adminUserPlanUnknown,
    };

extension AdminPlanTierLabel on AdminPlanTier {
  String localizedLabel(AppLocalizations l10n) =>
      adminUserPlanLabel(name.toUpperCase(), l10n);
}

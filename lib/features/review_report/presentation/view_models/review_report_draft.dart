import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';

class ReviewReportDraft {
  const ReviewReportDraft({
    this.reviewId,
    this.reasons = const {},
    this.detail = '',
    this.reportType,
    this.disclosure,
    this.includeAiEvidence = false,
    this.agreePrivacy = false,
    this.agreeNotFalse = false,
    this.attachments = const [],
  });

  final int? reviewId;
  final Set<ReportReason> reasons;
  final String detail;
  final String? reportType;
  final String? disclosure;
  final bool includeAiEvidence;
  final bool agreePrivacy;
  final bool agreeNotFalse;
  final List<PlatformFile> attachments;

  bool get isEmpty =>
      reasons.isEmpty &&
      detail.isEmpty &&
      reportType == null &&
      disclosure == null &&
      !includeAiEvidence &&
      !agreePrivacy &&
      !agreeNotFalse &&
      attachments.isEmpty;

  ReviewReportDraft copyWith({
    int? reviewId,
    Set<ReportReason>? reasons,
    String? detail,
    Object? reportType = _sentinel,
    Object? disclosure = _sentinel,
    bool? includeAiEvidence,
    bool? agreePrivacy,
    bool? agreeNotFalse,
    List<PlatformFile>? attachments,
  }) {
    return ReviewReportDraft(
      reviewId: reviewId ?? this.reviewId,
      reasons: reasons ?? this.reasons,
      detail: detail ?? this.detail,
      reportType: identical(reportType, _sentinel)
          ? this.reportType
          : reportType as String?,
      disclosure: identical(disclosure, _sentinel)
          ? this.disclosure
          : disclosure as String?,
      includeAiEvidence: includeAiEvidence ?? this.includeAiEvidence,
      agreePrivacy: agreePrivacy ?? this.agreePrivacy,
      agreeNotFalse: agreeNotFalse ?? this.agreeNotFalse,
      attachments: attachments ?? this.attachments,
    );
  }
}

const _sentinel = Object();

class ReviewReportDraftNotifier extends Notifier<ReviewReportDraft> {
  @override
  ReviewReportDraft build() => const ReviewReportDraft();

  void bind(int reviewId) {
    if (state.reviewId != reviewId) {
      state = ReviewReportDraft(reviewId: reviewId);
    }
  }

  void toggleReason(ReportReason reason) {
    final next = {...state.reasons};
    if (next.contains(reason)) {
      next.remove(reason);
    } else {
      next.add(reason);
    }
    state = state.copyWith(reasons: next);
  }

  void setDetail(String value) {
    if (state.detail == value) return;
    state = state.copyWith(detail: value);
  }

  void setReportType(String? value) =>
      state = state.copyWith(reportType: value);

  void setDisclosure(String? value) =>
      state = state.copyWith(disclosure: value);

  void setIncludeAiEvidence(bool value) =>
      state = state.copyWith(includeAiEvidence: value);

  void setAgreePrivacy(bool value) =>
      state = state.copyWith(agreePrivacy: value);

  void setAgreeNotFalse(bool value) =>
      state = state.copyWith(agreeNotFalse: value);

  void setAttachments(List<PlatformFile> value) =>
      state = state.copyWith(attachments: value);

  void clear() => state = const ReviewReportDraft();
}

final reviewReportDraftProvider =
    NotifierProvider<ReviewReportDraftNotifier, ReviewReportDraft>(
  ReviewReportDraftNotifier.new,
);

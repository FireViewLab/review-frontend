enum ReportReason {
  fakeReview,
  aiGenerated,
  irrelevantContent,
  inappropriate,
  adReview,
  repetitiveContent,
  other;

  String get code => switch (this) {
        ReportReason.fakeReview => 'FAKE_REVIEW',
        ReportReason.aiGenerated => 'AI_GENERATED',
        ReportReason.irrelevantContent => 'IRRELEVANT_CONTENT',
        ReportReason.inappropriate => 'INAPPROPRIATE',
        ReportReason.adReview => 'AD_REVIEW',
        ReportReason.repetitiveContent => 'REPETITIVE_CONTENT',
        ReportReason.other => 'OTHER',
      };

  String get label => switch (this) {
        ReportReason.fakeReview => '가짜 리뷰 / 리뷰 날바 의심',
        ReportReason.aiGenerated => 'AI 생성 흔적 의심',
        ReportReason.irrelevantContent => '상품과 무관한 내용',
        ReportReason.inappropriate => '부적절한 표현 / 개인정보',
        ReportReason.adReview => '광고성 리뷰',
        ReportReason.repetitiveContent => '반복 내용',
        ReportReason.other => '기타',
      };

  String get description => switch (this) {
        ReportReason.fakeReview =>
          '반복되고, 과도한 칭찬, 구매 이력 복수가 동조하는 가능성이 있는 리뷰예요.',
        ReportReason.aiGenerated =>
          '반복이 지나치게 정밀하거나, 동일한 문장 구조가 반복되는 리뷰예요.',
        ReportReason.irrelevantContent =>
          '실제 상품 사용 경험과 관련이 없는 내용이거나 다른 상품/페이지의 내용을 포함해요.',
        ReportReason.inappropriate =>
          '비방, 혐오 표현, 이름 등 개인정보가 포함된 리뷰예요.',
        ReportReason.adReview => '광고 리뷰입니다.',
        ReportReason.repetitiveContent => '반복되는 내용입니다.',
        ReportReason.other => '기타 신고 사유입니다.',
      };
}

class ReviewReport {
  const ReviewReport({
    required this.reportId,
    required this.reviewId,
    required this.reason,
    required this.status,
    required this.productName,
    required this.reviewContent,
    this.detail,
    this.attachmentUrl,
    this.includeAiEvidence = false,
    this.externalReviewId,
    this.productExternalId,
    this.createdAt,
  });

  final int reportId;
  final int? reviewId;
  final String reason;
  final String status;
  final String productName;
  final String? reviewContent;
  final String? detail;
  final String? attachmentUrl;
  final bool includeAiEvidence;
  final String? externalReviewId;
  final String? productExternalId;
  final DateTime? createdAt;
}

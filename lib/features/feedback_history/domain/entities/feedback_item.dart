class FeedbackItem {
  const FeedbackItem({
    required this.id,
    required this.typeLabel,
    required this.feedbackCategory,
    required this.status,
    required this.statusDescription,
    required this.productName,
    required this.reviewContent,
    required this.currentStep,
    required this.totalSteps,
    this.productId,
    this.reviewId,
    this.externalReviewId,
    this.productExternalId,
    this.createdAt,
  });

  final int id;
  final String typeLabel;
  final String feedbackCategory;
  final int? productId;
  final int? reviewId;
  final String status;
  final String statusDescription;
  final String productName;
  final String? reviewContent;
  final int currentStep;
  final int totalSteps;
  final String? externalReviewId;
  final String? productExternalId;
  final DateTime? createdAt;
}

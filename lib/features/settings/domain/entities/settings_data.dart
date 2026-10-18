class SettingsData {
  const SettingsData({
    this.notifyRiskyProduct = true,
    this.notifyAnalysisComplete = true,
    this.notifyFeedbackResult = true,
    this.notifyMarketing = false,
    this.rtiThreshold = 50,
    this.hideRiskyReviews = true,
    this.showSuspiciousLabel = true,
    this.prioritizeVerifiedReviews = true,
    this.autoOpenAnalysisPopup = false,
    this.cardDensity = 'COMFORTABLE',
    this.reviewSortOrder = 'VERIFIED_RECENT',
    this.rtiLabelStyle = 'BADGE_SMALL',
    this.theme = 'SYSTEM',
    this.allowDataAnalysis = true,
  });

  final bool notifyRiskyProduct;
  final bool notifyAnalysisComplete;
  final bool notifyFeedbackResult;
  final bool notifyMarketing;
  final int rtiThreshold;
  final bool hideRiskyReviews;
  final bool showSuspiciousLabel;
  final bool prioritizeVerifiedReviews;
  final bool autoOpenAnalysisPopup;
  final String cardDensity;
  final String reviewSortOrder;
  final String rtiLabelStyle;
  final String theme;
  final bool allowDataAnalysis;

  SettingsData copyWith({
    bool? notifyRiskyProduct,
    bool? notifyAnalysisComplete,
    bool? notifyFeedbackResult,
    bool? notifyMarketing,
    int? rtiThreshold,
    bool? hideRiskyReviews,
    bool? showSuspiciousLabel,
    bool? prioritizeVerifiedReviews,
    bool? autoOpenAnalysisPopup,
    String? cardDensity,
    String? reviewSortOrder,
    String? rtiLabelStyle,
    String? theme,
    bool? allowDataAnalysis,
  }) {
    return SettingsData(
      notifyRiskyProduct: notifyRiskyProduct ?? this.notifyRiskyProduct,
      notifyAnalysisComplete:
          notifyAnalysisComplete ?? this.notifyAnalysisComplete,
      notifyFeedbackResult: notifyFeedbackResult ?? this.notifyFeedbackResult,
      notifyMarketing: notifyMarketing ?? this.notifyMarketing,
      rtiThreshold: rtiThreshold ?? this.rtiThreshold,
      hideRiskyReviews: hideRiskyReviews ?? this.hideRiskyReviews,
      showSuspiciousLabel: showSuspiciousLabel ?? this.showSuspiciousLabel,
      prioritizeVerifiedReviews:
          prioritizeVerifiedReviews ?? this.prioritizeVerifiedReviews,
      autoOpenAnalysisPopup:
          autoOpenAnalysisPopup ?? this.autoOpenAnalysisPopup,
      cardDensity: cardDensity ?? this.cardDensity,
      reviewSortOrder: reviewSortOrder ?? this.reviewSortOrder,
      rtiLabelStyle: rtiLabelStyle ?? this.rtiLabelStyle,
      theme: theme ?? this.theme,
      allowDataAnalysis: allowDataAnalysis ?? this.allowDataAnalysis,
    );
  }
}

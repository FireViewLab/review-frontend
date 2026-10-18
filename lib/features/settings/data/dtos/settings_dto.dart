import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

class SettingsDto {
  const SettingsDto(this._json);

  final Map<String, dynamic> _json;

  SettingsData toEntity() {
    const defaults = SettingsData();
    return SettingsData(
      notifyRiskyProduct:
          _json['notifyRiskyProduct'] as bool? ?? defaults.notifyRiskyProduct,
      notifyAnalysisComplete:
          _json['notifyAnalysisComplete'] as bool? ??
          defaults.notifyAnalysisComplete,
      notifyFeedbackResult:
          _json['notifyFeedbackResult'] as bool? ??
          defaults.notifyFeedbackResult,
      notifyMarketing:
          _json['notifyMarketing'] as bool? ?? defaults.notifyMarketing,
      rtiThreshold:
          (_json['rtiThreshold'] as num?)?.toInt() ?? defaults.rtiThreshold,
      hideRiskyReviews:
          _json['hideRiskyReviews'] as bool? ?? defaults.hideRiskyReviews,
      showSuspiciousLabel:
          _json['showSuspiciousLabel'] as bool? ?? defaults.showSuspiciousLabel,
      prioritizeVerifiedReviews:
          _json['prioritizeVerifiedReviews'] as bool? ??
          defaults.prioritizeVerifiedReviews,
      autoOpenAnalysisPopup:
          _json['autoOpenAnalysisPopup'] as bool? ??
          defaults.autoOpenAnalysisPopup,
      cardDensity: _json['cardDensity'] as String? ?? defaults.cardDensity,
      reviewSortOrder:
          _json['reviewSortOrder'] as String? ?? defaults.reviewSortOrder,
      rtiLabelStyle:
          _json['rtiLabelStyle'] as String? ?? defaults.rtiLabelStyle,
      theme: _json['theme'] as String? ?? defaults.theme,
      allowDataAnalysis: _json['allowDataAnalysis'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toUpdateJson(SettingsData settings) => {
    'notifyRiskyProduct': settings.notifyRiskyProduct,
    'notifyAnalysisComplete': settings.notifyAnalysisComplete,
    'notifyFeedbackResult': settings.notifyFeedbackResult,
    'notifyMarketing': settings.notifyMarketing,
    'rtiThreshold': settings.rtiThreshold,
    'hideRiskyReviews': settings.hideRiskyReviews,
    'showSuspiciousLabel': settings.showSuspiciousLabel,
    'prioritizeVerifiedReviews': settings.prioritizeVerifiedReviews,
    'autoOpenAnalysisPopup': settings.autoOpenAnalysisPopup,
    'cardDensity': settings.cardDensity,
    'reviewSortOrder': settings.reviewSortOrder,
    'rtiLabelStyle': settings.rtiLabelStyle,
    'allowDataAnalysis': settings.allowDataAnalysis,
  };
}

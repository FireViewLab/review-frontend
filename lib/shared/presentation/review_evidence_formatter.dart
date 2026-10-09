import 'package:flutter/widgets.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// Display-only interpretation. Raw evidence stays in the data/domain models.
abstract final class ReviewEvidenceFormatter {
  static final _code = RegExp(r'^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)+$');
  static final _upperToken = RegExp(r'^[A-Z][A-Z0-9]+$');

  static String text(
    BuildContext context,
    String raw, {
    bool detailed = false,
  }) {
    final value = raw.trim();
    if (value.isEmpty) return '';
    final l = AppLocalizations.of(context);
    final known = switch (value.toUpperCase()) {
      'REPETITIVE_KEYWORD' || 'TEXT_REPETITIVE_KEYWORD' => (
        l.evidenceRepetitionLabel,
        l.evidenceRepetitionBody,
      ),
      'SHORT_REVIEW' ||
      'TEXT_SHORT_REVIEW' => (l.evidenceShortLabel, l.evidenceShortBody),
      'EXCESSIVE_EXCLAMATION' || 'TEXT_EXCESSIVE_EXCLAMATION' => (
        l.evidenceExclamationLabel,
        l.evidenceExclamationBody,
      ),
      'OVERLY_POSITIVE_SENTIMENT' || 'TEXT_OVERLY_POSITIVE_SENTIMENT' => (
        l.evidencePositiveLabel,
        l.evidencePositiveBody,
      ),
      'PURCHASE_NOT_VERIFIED' || 'BEHAVIOR_PURCHASE_NOT_VERIFIED' => (
        l.evidencePurchaseLabel,
        l.evidencePurchaseBody,
      ),
      'NEW_ACCOUNT' || 'BEHAVIOR_NEW_ACCOUNT' => (
        l.evidenceNewAccountLabel,
        l.evidenceNewAccountBody,
      ),
      'MULTIPLE_REVIEWS_SAME_DAY' || 'BEHAVIOR_MULTIPLE_REVIEWS_SAME_DAY' => (
        l.evidenceDailyLabel,
        l.evidenceDailyBody,
      ),
      'SIMILAR_REVIEW_PATTERN' || 'NETWORK_SIMILAR_REVIEW_PATTERN' => (
        l.evidenceSimilarLabel,
        l.evidenceSimilarBody,
      ),
      'SIMILAR_REVIEW_CLUSTER' || 'NETWORK_SIMILAR_REVIEW_CLUSTER' => (
        l.evidenceClusterLabel,
        l.evidenceClusterBody,
      ),
      'LOW_QUALITY_SCORE' || 'TEXT_LOW_QUALITY_SCORE' => (
        l.evidenceQualityLabel,
        l.evidenceQualityBody,
      ),
      'PURCHASE_UNKNOWN' || 'BEHAVIOR_PURCHASE_UNKNOWN' => (
        l.evidenceUnknownPurchaseLabel,
        l.evidenceUnknownPurchaseBody,
      ),
      'FREE_TRIAL_REVIEW' || 'BEHAVIOR_FREE_TRIAL_REVIEW' => (
        l.evidenceTrialLabel,
        l.evidenceTrialBody,
      ),
      'NO_IMAGE_ATTACHED' || 'BEHAVIOR_NO_IMAGE_ATTACHED' => (
        l.evidenceNoImageLabel,
        l.evidenceNoImageBody,
      ),
      'REPURCHASE_SIGNAL' || 'BEHAVIOR_REPURCHASE_SIGNAL' => (
        l.evidenceRepurchaseLabel,
        l.evidenceRepurchaseBody,
      ),
      _ => null,
    };
    if (known != null) return detailed ? known.$2 : known.$1;
    // Preserve supplied prose; never infer risk or safety from an unknown token.
    if (_code.hasMatch(value) || _upperToken.hasMatch(value)) {
      return detailed ? l.evidenceUnknownBody : l.evidenceUnknownLabel;
    }
    return value;
  }

  /// Deduplicate display items without changing analysis/counting inputs.
  static List<String> list(
    BuildContext context,
    Iterable<String> raw, {
    bool detailed = false,
  }) => <String>{
    for (final item in raw)
      if (item.trim().isNotEmpty) text(context, item, detailed: detailed),
  }.toList(growable: false);
}

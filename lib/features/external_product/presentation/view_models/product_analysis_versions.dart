import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';

class ProductAnalysisVersions {
  ProductAnalysisVersions.fromState(ExternalProductState state) {
    final analysis = state.analysis;
    final display = analysis?.display;
    final v4 =
        display?.isV2 == true ||
        state.reviews.any((review) => review.analysisDisplay.isV2);
    model =
        display?.modelVersion ??
        _mostFrequent(
          state.reviews
              .where((review) => review.analysisDisplay.isV2)
              .map((review) => review.analysisDisplay.modelVersion),
        ) ??
        (v4 ? null : analysis?.modelVersion);
    policy =
        display?.policyVersion ??
        _mostFrequent(
          state.reviews
              .where((review) => review.analysisDisplay.isV2)
              .map((review) => review.analysisDisplay.policyVersion),
        ) ??
        (v4 ? null : analysis?.policyVersion);
  }

  late final String? model;
  late final String? policy;

  static String? _mostFrequent(Iterable<String?> versions) {
    final counts = <String, int>{};
    for (final version in versions) {
      final value = version?.trim();
      if (value == null || value.isEmpty) continue;
      counts.update(value, (count) => count + 1, ifAbsent: () => 1);
    }
    final ranked = counts.entries.toList()
      ..sort((a, b) {
        final count = b.value.compareTo(a.value);
        return count == 0 ? a.key.compareTo(b.key) : count;
      });
    return ranked.firstOrNull?.key;
  }
}

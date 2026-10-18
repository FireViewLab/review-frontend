import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

/// Resolve only a known product or personal feedback target, without a request.
String? notificationRoute(String? targetUrl) {
  if (targetUrl == null) return null;
  final uri = Uri.tryParse(targetUrl);
  if (uri == null) return null;
  final segments = uri.pathSegments;
  if (segments.isNotEmpty &&
      const {'product', 'products'}.contains(segments.first)) {
    if (segments.length == 3) {
      return ExternalProductRef.resolve(
        dataPlatform: segments[1],
        dataProductId: segments[2],
      )?.routePath;
    }
    if (segments.length == 2) {
      final numeric = int.tryParse(segments[1]);
      if (numeric != null && numeric > 0 && numeric <= 9007199254740991) {
        return '/product/$numeric';
      }
      return ExternalProductRef.resolve(externalId: segments[1])?.routePath;
    }
  }
  if (segments.length >= 2 &&
      const {'reports', 'feedback'}.contains(segments[0]) &&
      segments[1] == 'me') {
    return RoutePaths.feedbackHistory;
  }
  return null;
}

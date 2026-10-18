import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

ExternalProductRef? externalHistoryTarget(String? externalId) {
  if (externalId == null) return null;
  final separator = externalId.indexOf('-');
  if (separator <= 0 || separator == externalId.length - 1) return null;
  return ExternalProductRef(
    platform: externalId.substring(0, separator),
    productId: externalId.substring(separator + 1),
  );
}

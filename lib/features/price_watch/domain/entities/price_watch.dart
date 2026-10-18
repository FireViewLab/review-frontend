import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

/// A comparison is usable only when both observations identify the same offer.
class PriceObservation {
  const PriceObservation({
    required this.product,
    required this.platform,
    required this.variant,
    required this.currency,
    required this.price,
    required this.observedAt,
  });
  final ExternalProductRef product;
  final String platform;
  final String variant;
  final String currency;
  final int price;
  final DateTime observedAt;
}

class PriceWatch {
  const PriceWatch({
    required this.product,
    required this.subscribed,
    this.previous,
    this.current,
  });
  final ExternalProductRef product;
  final bool subscribed;
  final PriceObservation? previous;
  final PriceObservation? current;
  int? get decrease {
    final before = previous, after = current;
    if (before == null ||
        after == null ||
        before.product != product ||
        after.product != product ||
        before.platform != after.platform ||
        before.platform.toLowerCase() != product.platform ||
        before.variant.trim().isEmpty ||
        before.variant != after.variant ||
        before.currency.trim().isEmpty ||
        before.currency != after.currency ||
        before.price <= 0 ||
        after.price <= 0 ||
        after.price >= before.price ||
        !after.observedAt.isAfter(before.observedAt) ||
        after.observedAt.isAfter(DateTime.now())) {
      return null;
    }
    return before.price - after.price;
  }

  double? get decreasePercent =>
      decrease == null ? null : decrease! * 100 / previous!.price;
}

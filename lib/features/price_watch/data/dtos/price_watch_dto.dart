import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import '../../domain/entities/price_watch.dart';

/// Proposed integration shape only. Not bound to any existing HTTP endpoint.
/// Missing offer identity or observation metadata never produces a comparison.
class PriceWatchDto {
  const PriceWatchDto(this.json);
  final Map<String, dynamic> json;
  PriceWatch? toEntity(ExternalProductRef expected) {
    final product = ExternalProductRef.resolve(
      dataPlatform: _text(json['platform']),
      dataProductId: _text(json['productId']),
      externalId: _text(json['externalId']),
    );
    if (product != expected || json['subscribed'] is! bool) return null;
    return PriceWatch(
      product: expected,
      subscribed: json['subscribed'] as bool,
      previous: _observation(json['previous'], expected),
      current: _observation(json['current'], expected),
    );
  }

  PriceObservation? _observation(Object? raw, ExternalProductRef expected) {
    if (raw is! Map<String, dynamic>) return null;
    final product = ExternalProductRef.resolve(
      dataPlatform: _text(raw['platform']),
      dataProductId: _text(raw['productId']),
      externalId: _text(raw['externalId']),
    );
    final price = raw['price'];
    final timestamp = _text(raw['observedAt']) ?? '';
    final at = RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(timestamp)
        ? DateTime.tryParse(timestamp)
        : null;
    final variant = _text(raw['variantKey']), currency = _text(raw['currency']);
    if (product != expected ||
        price is! int ||
        price <= 0 ||
        at == null ||
        variant == null ||
        currency == null) {
      return null;
    }
    return PriceObservation(
      product: expected,
      platform: expected.platform,
      variant: variant,
      currency: currency,
      price: price,
      observedAt: at,
    );
  }

  String? _text(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
}

import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import '../entities/price_watch.dart';

abstract interface class PriceWatchRepository {
  bool get isConfigured;
  String get unavailableReason;
  Future<Result<PriceWatch>> getWatch(ExternalProductRef product);
  Future<Result<PriceWatch>> setSubscribed(
    ExternalProductRef product,
    bool subscribed,
  );
}

import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import '../../domain/entities/price_watch.dart';
import '../../domain/repositories/price_watch_repository.dart';

/// No URL or successful response is invented while the server contract is absent.
class UnconfiguredPriceWatchRepository implements PriceWatchRepository {
  const UnconfiguredPriceWatchRepository();
  @override
  bool get isConfigured => false;
  @override
  String get unavailableReason =>
      '이전·현재 가격 조회와 가격 알림 구독을 저장하는 서버 기능이 아직 연결되지 않았어요. 지금은 가격하락 감시나 알림 신청을 할 수 없어요.';
  @override
  Future<Result<PriceWatch>> getWatch(ExternalProductRef product) async =>
      FailureResult(Failure(message: unavailableReason));
  @override
  Future<Result<PriceWatch>> setSubscribed(
    ExternalProductRef product,
    bool subscribed,
  ) async => FailureResult(Failure(message: unavailableReason));
}

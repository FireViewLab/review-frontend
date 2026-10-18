import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/product_detail/domain/repositories/product_detail_repository.dart';

/// The existing authenticated numeric detail GET records a server view.
/// No local history or unsupported write endpoint is substituted for it.
class RecordViewedProductUseCase {
  const RecordViewedProductUseCase(this.repository);
  final ProductDetailRepository repository;
  Future<Result<void>> call(ExternalProductRef target, int id) async {
    if (id <= 0 || id > 9007199254740991) {
      return const FailureResult(Failure(message: '상품 식별 정보를 확인할 수 없습니다.'));
    }
    final result = await repository.getProductDetail(id);
    return result.when(
      success: (detail) => detail.id == id && detail.externalRef == target
          ? const Success<void>(null)
          : const FailureResult(Failure(message: '상품 식별 정보가 일치하지 않습니다.')),
      failure: (failure) => FailureResult(failure),
    );
  }
}

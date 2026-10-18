import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

abstract interface class ExternalActionsRepository {
  Future<Result<int>> tag(ExternalProductRef product);
  Future<Result<void>> feedback(
    ExternalProductRef product,
    String reviewId,
    String type,
  );
  Future<Result<void>> report(
    ExternalProductRef product,
    String reviewId, {
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  });
}

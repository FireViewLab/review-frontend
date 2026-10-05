import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';

class ExternalActionsRemoteDataSource {
  const ExternalActionsRemoteDataSource(this.client);
  final ApiClient client;

  String _key(ExternalProductRef p) =>
      '${Uri.encodeComponent(p.platform)}/${Uri.encodeComponent(p.productId)}';
  Future<Object?> _post(String path, [Map<String, dynamic>? body]) async {
    final response = await client.post(path, data: body);
    return ApiResponse<Object?>.fromJson(
      response.data as Map<String, dynamic>,
    ).requireSuccess();
  }

  Future<int> tag(ExternalProductRef product) async {
    final data =
        await _post('/api/v2/products/${_key(product)}/tag')
            as Map<String, dynamic>;
    final id = (data['springProductId'] as num).toInt();
    if (id <= 0) throw const FormatException('Invalid product tag');
    return id;
  }

  Future<void> feedback(
    ExternalProductRef product,
    String reviewId,
    String type,
  ) async {
    await _post(
      '/api/reviews/external/${_key(product)}/reviews/${Uri.encodeComponent(reviewId)}/feedback',
      {'feedbackType': type},
    );
  }

  Future<void> report(
    ExternalProductRef product,
    String reviewId, {
    required String reason,
    required String detail,
    bool includeAiEvidence = false,
    String? attachmentUrl,
  }) async {
    await _post(
      '/api/reports/external/${_key(product)}/reviews/${Uri.encodeComponent(reviewId)}',
      {
        'reason': reason,
        'detail': detail,
        'includeAiEvidence': includeAiEvidence,
        'attachmentUrl': ?attachmentUrl,
      },
    );
  }
}

import 'product_summary.dart';
export 'product_summary.dart';

/// Data 서버가 수집한 쇼핑몰 상품을 가리키는 식별자.
///
/// 상품 번호만으로는 찾을 수 없고 쇼핑몰 이름과 함께 써야 한다.
class ExternalProductRef {
  const ExternalProductRef({required this.platform, required this.productId});

  /// Prefer explicit fields; split a compound ID only at its first separator.
  static ExternalProductRef? resolve({
    String? dataPlatform,
    String? dataProductId,
    String? externalId,
  }) {
    final platform = dataPlatform?.trim().toLowerCase();
    final id = dataProductId?.trim();
    if (platform != null &&
        platform.isNotEmpty &&
        id != null &&
        id.isNotEmpty) {
      return ExternalProductRef(platform: platform, productId: id);
    }
    final value = externalId?.trim();
    if (value == null) return null;
    final separator = value.indexOf('-');
    if (separator <= 0 || separator == value.length - 1) return null;
    return ExternalProductRef(
      platform: value.substring(0, separator).toLowerCase(),
      productId: value.substring(separator + 1),
    );
  }

  static ExternalProductRef? fromRoute(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length != 3 ||
        segments.first != 'product' ||
        segments[1].isEmpty ||
        segments[2].isEmpty) {
      return null;
    }
    return ExternalProductRef(
      platform: segments[1].toLowerCase(),
      productId: segments[2],
    );
  }

  /// 수집기 이름. 소문자다 (naver, kurly, oliveyoung …).
  final String platform;

  /// 쇼핑몰이 발급한 상품 번호. 숫자처럼 보여도 문자열로 다룬다.
  final String productId;

  /// 챗봇·신고 내역에서 쓰는 한 줄 식별자.
  String get externalId => '$platform-$productId';

  /// 앱 안에서 이 상품 화면으로 가는 경로.
  String get routePath =>
      '/product/${Uri.encodeComponent(platform)}/${Uri.encodeComponent(productId)}';

  @override
  bool operator ==(Object other) =>
      other is ExternalProductRef &&
      other.platform == platform &&
      other.productId == productId;

  @override
  int get hashCode => Object.hash(platform, productId);

  @override
  String toString() => externalId;
}

/// Product context carried alongside navigation; numeric IDs stay out of chat.
class ProductRouteContext {
  const ProductRouteContext({
    this.chatProductId,
    this.summary,
    this.viewAlreadyRecorded = false,
  });
  final String? chatProductId;
  final ProductSummary? summary;
  final bool viewAlreadyRecorded;
}

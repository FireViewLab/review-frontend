/// Data 서버가 수집한 쇼핑몰 상품을 가리키는 식별자.
///
/// 상품 번호만으로는 찾을 수 없고 쇼핑몰 이름과 함께 써야 한다.
class ExternalProductRef {
  const ExternalProductRef({required this.platform, required this.productId});

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

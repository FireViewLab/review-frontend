/// Server image URLs in primary-first order. No fabricated gallery entries.
List<String> productImageUrls({
  String? primary,
  Iterable<String> additional = const [],
}) => [
  ...[?primary, ...additional].map((s) => s.trim()).where((s) {
    final uri = Uri.tryParse(s);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty;
  }).toSet(),
];

/// Optional future gallery fields; absence means no additional images.
List<String> readProductImages(Map<String, dynamic> json) => [
  for (final key in ['imageUrls', 'images', 'gallery'])
    if (json[key] is List)
      for (final image in json[key] as List)
        if (image is String) image,
];

/// 목록용으로 작게 줄인 쇼핑몰 CDN 이미지 주소.
///
/// 확인된 호스트만 바꾸고 나머지는 그대로 돌려준다. 바뀐 주소가 실패할 수 있으니
/// 호출하는 쪽에서 원본 주소로 다시 시도해야 한다.
String productThumbnailUrl(String url, {required int width}) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return url;

  switch (uri.host) {
    case 'image.oliveyoung.co.kr':
      if (uri.queryParameters.containsKey('RS')) return url;
      return uri
          .replace(
            queryParameters: {
              ...uri.queryParameters,
              'RS': '${width}x0',
              'QT': '85',
              'SF': 'webp',
            },
          )
          .toString();
    case 'image.msscdn.net':
      if (!uri.path.startsWith('/images/')) return url;
      return uri
          .replace(
            path: '/thumbnails${uri.path}',
            queryParameters: {'w': '$width'},
          )
          .toString();
    case 'product-image.kurly.com':
    case '3p-image.kurly.com':
    case 'img-cf.kurly.com':
      if (uri.path.startsWith('/hdims/')) return url;
      return uri
          .replace(path: '/hdims/resize/${width}x/quality/85/src${uri.path}')
          .toString();
    default:
      return url;
  }
}

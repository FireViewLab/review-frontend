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

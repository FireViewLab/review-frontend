import 'package:re_view_front/core/utils/product_image_urls.dart';

abstract final class ProductDescriptionFields {
  static const descriptionKeys = [
    'description',
    'detailDescription',
    'descriptionText',
    'description_text',
  ];
  static const imageKeys = [
    'detailImages',
    'detail_images',
    'descriptionImages',
    'description_images',
  ];

  static String? readDescription(Map<String, dynamic> json) {
    for (final key in descriptionKeys) {
      final raw = json[key];
      if (raw is! String) continue;
      final text = _plainText(raw);
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  static List<String> readImages(Map<String, dynamic> json) => productImageUrls(
    additional: [
      for (final key in imageKeys)
        if (json[key] case final List items)
          for (final item in items)
            if (item is String && !RegExp(r'\s').hasMatch(item.trim())) item,
    ],
  ).take(30).toList(growable: false);

  static const _entities = {
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    'nbsp': ' ',
    'ensp': ' ',
    'emsp': ' ',
    'thinsp': ' ',
    'ndash': '–',
    'mdash': '—',
    'hellip': '…',
    'bull': '•',
    'copy': '©',
    'reg': '®',
    'trade': '™',
  };

  static String _plainText(String raw) {
    var text = raw.replaceAllMapped(
      RegExp(r'&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);', caseSensitive: false),
      (match) {
        final entity = match[1]!;
        if (!entity.startsWith('#')) return _entities[entity] ?? match[0]!;
        final hex = entity.toLowerCase().startsWith('#x');
        final code = int.tryParse(
          entity.substring(hex ? 2 : 1),
          radix: hex ? 16 : 10,
        );
        if (code == null ||
            code <= 0 ||
            code > 0x10ffff ||
            (code >= 0xd800 && code <= 0xdfff)) {
          return '';
        }
        return String.fromCharCode(code);
      },
    );
    text = text
        .replaceAll(RegExp(r'<!--[\s\S]*?(?:-->|$)'), '')
        .replaceAll(
          RegExp(
            r'<(script|style|template|noscript)\b[^>]*>[\s\S]*?(?:</\1\s*>|$)',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAllMapped(
          RegExp(r'''<(?:/?[a-zA-Z]|!)(?:"[^"]*"|'[^']*'|[^'">])*>'''),
          (match) =>
              RegExp(
                r'^</?(?:br|p|div|li|ul|ol|h[1-6]|tr|table|section|article|blockquote)\b',
                caseSensitive: false,
              ).hasMatch(match[0]!)
              ? '\n'
              : '',
        )
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]'), '');
    return text
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'[^\S\n]+'), ' ').trim())
        .join('\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}

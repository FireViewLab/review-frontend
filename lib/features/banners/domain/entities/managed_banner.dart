class ManagedBanner {
  const ManagedBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.targetUrl,
    required this.displayOrder,
    required this.active,
    this.mobileImageUrl,
  });
  final String id;
  final String title;
  final String imageUrl;
  final String? mobileImageUrl;
  final String targetUrl;
  final int displayOrder;
  final bool active;
}

class BannerDraft {
  const BannerDraft({
    required this.title,
    required this.imageUrl,
    required this.targetUrl,
    required this.displayOrder,
    required this.active,
    this.mobileImageUrl,
  });
  final String title;
  final String imageUrl;
  final String? mobileImageUrl;
  final String targetUrl;
  final int displayOrder;
  final bool active;

  static bool isImageUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty;
  }

  static bool isTargetUrl(String value) {
    final text = value.trim();
    if (text.contains('\\') || RegExp(r'\s').hasMatch(text)) return false;
    final uri = Uri.tryParse(text);
    if (uri == null || uri.userInfo.isNotEmpty) return false;
    return (text.startsWith('/') &&
            !text.startsWith('//') &&
            !uri.hasScheme &&
            !uri.hasAuthority) ||
        isImageUrl(text);
  }

  bool get isValid =>
      title.trim().isNotEmpty &&
      title.trim().length <= 120 &&
      isImageUrl(imageUrl) &&
      (mobileImageUrl == null || isImageUrl(mobileImageUrl!)) &&
      isTargetUrl(targetUrl) &&
      displayOrder >= 0 &&
      displayOrder <= 2147483647;
}

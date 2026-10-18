import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';

/// Proposed wire format. Enable only after the server contract is confirmed.
class BannerDto {
  static ManagedBanner fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final title = json['title'];
    final image = json['imageUrl'];
    final mobile = json['mobileImageUrl'];
    final target = json['targetUrl'];
    final order = json['displayOrder'];
    final active = json['active'];
    if (id == null ||
        id.isEmpty ||
        title is! String ||
        image is! String ||
        target is! String ||
        order is! int ||
        active is! bool ||
        (mobile != null && mobile is! String)) {
      throw const FormatException('Invalid banner response');
    }
    final draft = BannerDraft(
      title: title,
      imageUrl: image,
      mobileImageUrl: mobile as String?,
      targetUrl: target,
      displayOrder: order,
      active: active,
    );
    if (!draft.isValid) throw const FormatException('Invalid banner fields');
    return ManagedBanner(
      id: id,
      title: title,
      imageUrl: image,
      mobileImageUrl: draft.mobileImageUrl,
      targetUrl: target,
      displayOrder: order,
      active: active,
    );
  }

  static Map<String, dynamic> toJson(
    BannerDraft draft, {
    required bool mobileImages,
  }) => {
    'title': draft.title.trim(),
    'imageUrl': draft.imageUrl.trim(),
    'targetUrl': draft.targetUrl.trim(),
    'displayOrder': draft.displayOrder,
    'active': draft.active,
    if (mobileImages) 'mobileImageUrl': draft.mobileImageUrl?.trim(),
  };
}

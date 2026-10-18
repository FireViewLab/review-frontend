import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/banners/data/dtos/banner_dto.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';

/// No default endpoints: this configuration requires an agreed server contract.
class BannerApiContract {
  const BannerApiContract({
    required this.publicListPath,
    required this.adminCollectionPath,
    this.supportsMobileImages = false,
  });
  final String publicListPath;
  final String adminCollectionPath;
  final bool supportsMobileImages;
}

class BannerRemoteDataSource {
  const BannerRemoteDataSource(this.client, this.contract);
  final ApiClient client;
  final BannerApiContract contract;
  String _path(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !value.startsWith('/api/') ||
        uri.hasScheme ||
        uri.hasAuthority ||
        value.contains('\\')) {
      throw const FormatException(
        'Banner API paths must use the existing API origin',
      );
    }
    return value;
  }

  Object? _payload(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid banner envelope');
    }
    return ApiResponse<Object?>.fromJson(raw).requireSuccess();
  }

  Future<List<ManagedBanner>> list({required bool admin}) async {
    final response = await client.get(
      _path(admin ? contract.adminCollectionPath : contract.publicListPath),
    );
    final raw = _payload(response.data);
    if (raw is! List) throw const FormatException('Invalid banner list');
    final banners = raw.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid banner');
      }
      return BannerDto.fromJson(item);
    }).toList();
    if (banners.map((b) => b.id).toSet().length != banners.length) {
      throw const FormatException('Duplicate banner ids');
    }
    banners.sort((a, b) {
      final order = a.displayOrder.compareTo(b.displayOrder);
      return order != 0 ? order : a.id.compareTo(b.id);
    });
    return admin ? banners : banners.where((b) => b.active).toList();
  }

  Future<ManagedBanner> save(BannerDraft draft, {String? id}) async {
    final data = BannerDto.toJson(
      draft,
      mobileImages: contract.supportsMobileImages,
    );
    final response = id == null
        ? await client.post(_path(contract.adminCollectionPath), data: data)
        : await client.patch(
            '${_path(contract.adminCollectionPath)}/${Uri.encodeComponent(id)}',
            data: data,
          );
    final raw = _payload(response.data);
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Missing saved banner');
    }
    final saved = BannerDto.fromJson(raw);
    if ((id != null && saved.id != id) ||
        saved.title != draft.title.trim() ||
        saved.imageUrl != draft.imageUrl.trim() ||
        saved.targetUrl != draft.targetUrl.trim() ||
        saved.displayOrder != draft.displayOrder ||
        saved.active != draft.active ||
        (contract.supportsMobileImages &&
            saved.mobileImageUrl != draft.mobileImageUrl?.trim())) {
      throw const FormatException(
        'Save response does not match the requested banner',
      );
    }
    return saved;
  }
}

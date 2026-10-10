import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';

abstract interface class BannerRepository {
  Future<Result<List<ManagedBanner>>> getPublicBanners();
  Future<Result<List<ManagedBanner>>> getAdminBanners();
  Future<Result<ManagedBanner>> save(BannerDraft draft, {String? id});
}

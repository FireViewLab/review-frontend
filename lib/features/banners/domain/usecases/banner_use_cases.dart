import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';
import 'package:re_view_front/features/banners/domain/repositories/banner_repository.dart';

class GetBannersUseCase {
  const GetBannersUseCase(this.repository);
  final BannerRepository repository;
  Future<Result<List<ManagedBanner>>> call({bool admin = false}) =>
      admin ? repository.getAdminBanners() : repository.getPublicBanners();
}

class SaveBannerUseCase {
  const SaveBannerUseCase(this.repository);
  final BannerRepository repository;
  Future<Result<ManagedBanner>> call(BannerDraft draft, {String? id}) {
    if (!draft.isValid || id?.isEmpty == true) {
      return Future.value(
        const FailureResult(
          Failure(
            message:
                'Check the banner title, HTTPS image URL, target and nonnegative order.',
            code: 'BANNER_VALIDATION',
          ),
        ),
      );
    }
    return repository.save(draft, id: id);
  }
}

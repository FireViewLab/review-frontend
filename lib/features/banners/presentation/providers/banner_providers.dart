import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/banners/data/datasources/banner_remote_data_source.dart';
import 'package:re_view_front/features/banners/data/repositories/banner_repository_impl.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';
import 'package:re_view_front/features/banners/domain/repositories/banner_repository.dart';
import 'package:re_view_front/features/banners/domain/usecases/banner_use_cases.dart';
import 'package:re_view_front/features/banners/presentation/view_models/admin_banner_view_model.dart';

// Backend main and public OpenAPI do not yet expose banner APIs. Do not enable
// guessed endpoints. Confirm the paths, DTO and server permissions together.
final bannerApiContractProvider = Provider<BannerApiContract?>((ref) => null);
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final contract = ref.watch(bannerApiContractProvider);
  return BannerRepositoryImpl(
    contract == null
        ? null
        : BannerRemoteDataSource(ref.watch(apiClientProvider), contract),
  );
});
final getBannersUseCaseProvider = Provider(
  (ref) => GetBannersUseCase(ref.watch(bannerRepositoryProvider)),
);
final saveBannerUseCaseProvider = Provider(
  (ref) => SaveBannerUseCase(ref.watch(bannerRepositoryProvider)),
);
final publicBannersProvider = FutureProvider.autoDispose<List<ManagedBanner>>((
  ref,
) async {
  final result = await ref.watch(getBannersUseCaseProvider).call();
  return result.when(
    success: (banners) => banners,
    failure: (failure) => throw failure,
  );
});
final adminBannerViewModelProvider =
    NotifierProvider.autoDispose<AdminBannerViewModel, AdminBannerState>(
      AdminBannerViewModel.new,
    );

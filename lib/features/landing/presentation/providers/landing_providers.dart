import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/data/datasources/landing_remote_data_source.dart';
import 'package:re_view_front/features/landing/data/repositories/landing_repository_impl.dart';
import 'package:re_view_front/features/landing/domain/entities/landing_stats.dart';
import 'package:re_view_front/features/landing/domain/repositories/landing_repository.dart';
import 'package:re_view_front/features/landing/domain/usecases/get_landing_data_use_case.dart';

final _landingRemoteDataSourceProvider = Provider<LandingRemoteDataSource>((ref) {
  return LandingRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final _landingRepositoryProvider = Provider<LandingRepository>((ref) {
  return LandingRepositoryImpl(ref.watch(_landingRemoteDataSourceProvider));
});

final _getLandingDataUseCaseProvider = Provider<GetLandingDataUseCase>((ref) {
  return GetLandingDataUseCase(ref.watch(_landingRepositoryProvider));
});

// stats + product를 단일 요청으로 fetch. 두 파생 provider가 이걸 공유해 중복 호출 없음.
final landingDataProvider = FutureProvider<
  ({LandingStats stats, DashboardProduct? featuredProduct})
>((ref) async {
  final useCase = ref.read(_getLandingDataUseCaseProvider);
  return useCase();
});

final landingStatsProvider = Provider<AsyncValue<LandingStats>>((ref) {
  return ref.watch(landingDataProvider).whenData((d) => d.stats);
});

final featuredProductProvider = Provider<AsyncValue<DashboardProduct?>>((ref) {
  return ref.watch(landingDataProvider).whenData<DashboardProduct?>(
    (d) => d.featuredProduct,
  );
});

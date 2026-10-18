import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/banners/data/datasources/banner_remote_data_source.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';
import 'package:re_view_front/features/banners/domain/repositories/banner_repository.dart';

const bannerApiUnavailable = Failure(
  message: '배너 등록 서버 연결이 준비되지 않아 조회·저장할 수 없습니다. 입력과 미리보기는 사용할 수 있습니다.',
  code: 'BANNER_API_UNAVAILABLE',
);

class BannerRepositoryImpl implements BannerRepository {
  const BannerRepositoryImpl(this.source);
  final BannerRemoteDataSource? source;
  Future<Result<T>> _run<T>(
    Future<T> Function(BannerRemoteDataSource) action,
  ) async {
    final configured = source;
    if (configured == null) return const FailureResult(bannerApiUnavailable);
    try {
      return Success(await action(configured));
    } catch (error) {
      final status = error is DioException ? error.response?.statusCode : null;
      return FailureResult(
        Failure(
          message: status == 401
              ? '로그인이 필요합니다.'
              : status == 403
              ? '배너 관리 권한이 없습니다.'
              : '배너 요청을 완료하지 못했습니다. 다시 시도해주세요.',
          statusCode: status,
          code: 'BANNER_REQUEST_FAILED',
        ),
      );
    }
  }

  @override
  Future<Result<List<ManagedBanner>>> getPublicBanners() =>
      _run((s) => s.list(admin: false));
  @override
  Future<Result<List<ManagedBanner>>> getAdminBanners() =>
      _run((s) => s.list(admin: true));
  @override
  Future<Result<ManagedBanner>> save(BannerDraft draft, {String? id}) =>
      _run((s) => s.save(draft, id: id));
}

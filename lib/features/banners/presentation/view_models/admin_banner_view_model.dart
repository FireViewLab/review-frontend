import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';
import 'package:re_view_front/features/banners/presentation/providers/banner_providers.dart';

class AdminBannerState {
  const AdminBannerState({
    this.items = const [],
    this.loading = false,
    this.saving = false,
    this.failure,
  });
  final List<ManagedBanner> items;
  final bool loading;
  final bool saving;
  final Failure? failure;
}

class AdminBannerViewModel extends Notifier<AdminBannerState> {
  bool _loading = false;
  @override
  AdminBannerState build() {
    Future.microtask(loadList);
    return const AdminBannerState(loading: true);
  }

  Future<void> loadList() async {
    if (!ref.mounted || _loading || state.saving) return;
    if (!ref.read(isAdminProvider)) {
      state = const AdminBannerState(
        failure: Failure(message: '배너 관리 권한이 없습니다.', statusCode: 403),
      );
      return;
    }
    _loading = true;
    state = AdminBannerState(items: state.items, loading: true);
    final result = await ref.read(getBannersUseCaseProvider).call(admin: true);
    _loading = false;
    if (!ref.mounted) return;
    state = result.when(
      success: (items) => AdminBannerState(items: items),
      failure: (f) => AdminBannerState(items: state.items, failure: f),
    );
  }

  Future<Result<ManagedBanner>> save(BannerDraft draft, {String? id}) async {
    if (state.saving || state.loading) {
      return const FailureResult(
        Failure(message: '진행 중인 요청이 끝난 뒤 다시 시도해주세요.', code: 'BANNER_BUSY'),
      );
    }
    if (!ref.read(isAdminProvider)) {
      return const FailureResult(
        Failure(message: '배너 관리 권한이 없습니다.', statusCode: 403),
      );
    }
    state = AdminBannerState(items: state.items, saving: true);
    final result = await ref
        .read(saveBannerUseCaseProvider)
        .call(draft, id: id);
    if (!ref.mounted) return result;
    result.when(
      success: (saved) {
        final items = [...state.items.where((b) => b.id != saved.id), saved]
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        state = AdminBannerState(items: items);
        ref.invalidate(publicBannersProvider);
      },
      failure: (f) {
        state = AdminBannerState(items: state.items, failure: f);
      },
    );
    return result;
  }
}

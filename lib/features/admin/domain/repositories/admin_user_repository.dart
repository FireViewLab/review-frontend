import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';

abstract interface class AdminUserRepository {
  /// 가입일 최신순 사용자 목록.
  Future<Result<AdminPage<AdminUser>>> getUsers({
    required int page,
    required int size,
  });

  Future<Result<AdminUser>> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  });
}

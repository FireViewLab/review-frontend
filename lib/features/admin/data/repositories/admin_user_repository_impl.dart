import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/data/admin_failure.dart';
import 'package:re_view_front/features/admin/data/datasources/admin_user_remote_data_source.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_user_repository.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  const AdminUserRepositoryImpl(this._dataSource);

  final AdminUserRemoteDataSource _dataSource;

  @override
  Future<Result<AdminPage<AdminUser>>> getUsers({
    required int page,
    required int size,
  }) async {
    try {
      return Success(await _dataSource.getUsers(page: page, size: size));
    } catch (e) {
      return FailureResult(adminFailureFrom(e));
    }
  }

  @override
  Future<Result<AdminUser>> updatePlan({
    required int userId,
    required AdminPlanTier planTier,
    DateTime? expiresAt,
  }) async {
    try {
      return Success(
        await _dataSource.updatePlan(
          userId: userId,
          planTier: planTier,
          expiresAt: expiresAt,
        ),
      );
    } catch (e) {
      return FailureResult(adminFailureFrom(e));
    }
  }
}

import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_activity.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';

abstract interface class MyPageRepository {
  Future<Result<UserProfile>> getMyProfile();

  /// 최근 찜·피드백 활동 (최신순, 최대 10개).
  Future<Result<List<UserActivity>>> getMyActivities();
}

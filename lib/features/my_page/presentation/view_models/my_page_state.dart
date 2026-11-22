import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/features/my_page/domain/entities/user_profile.dart';

sealed class MyPageState {
  const MyPageState();
}

class MyPageLoading extends MyPageState {
  const MyPageLoading({this.isRefresh = false});

  final bool isRefresh;
}

class MyPageSuccess extends MyPageState {
  const MyPageSuccess(this.profile);

  final UserProfile profile;
}

class MyPageFailure extends MyPageState {
  const MyPageFailure(this.failure);

  final Failure failure;
}

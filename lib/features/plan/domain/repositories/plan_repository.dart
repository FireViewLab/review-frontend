import 'package:re_view_front/core/result/result.dart';

abstract interface class PlanRepository {
  /// 내 요금제 만료일. 무기한이거나 무료면 null.
  Future<Result<DateTime?>> getMyPlanExpiry();

  /// 내 요금제를 [code]로 바꾼다.
  ///
  /// 지금은 결제 없이 바로 바꾼다. 결제를 붙일 때는 이 호출 앞에 결제 확인 단계를 둔다.
  Future<Result<void>> changeMyPlan(String code);
}
